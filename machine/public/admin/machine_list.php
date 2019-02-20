<?php
/**
 * メンバー在庫一覧ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    $user = Auth::isAuth('member');

    //// 変数を取得 ////
    $output = Req::query('output');

    //// 機械情報一覧を取得 ////
    $start_date = null;
    $end_date   = null;
    if (Req::query('startYear') && Req::query('startMonth') && Req::query('startDay')) {
        $start_date = Req::query('startYear'). '-' . Req::query('startMonth') . '-' . Req::query('startDay');
    }
    if (Req::query('endYear') && Req::query('endMonth') && Req::query('endDay')) {
        $end_date = Req::query('endYear'). '-' . Req::query('endMonth') . '-' . Req::query('endDay');
    }

    $q = array(
        'company_id'  => $_user['company_id'],
        'view_option' => 'full',

        'large_genre_id' => Req::query('l'),
        'genre_id'       => Req::query('g'),
        'maker'          => Req::query('m'),
        'keyword'        => Req::query('k'),
        'no'             => Req::query('no'),

        'period'         => Req::query('pe'),
        'start_date'     => $start_date,
        'end_date'       => $end_date,

        // 'sort'        => 'created_at'

        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
    );
    $mModel = new Machine();
    $result = $mModel->search($q);

    //// CSVに出力する場合 ////
    if ($output == 'csv') {
        $filename = date('Ymd') . 'machine_list.csv';
        $header   = array(
            'id'            => '機械ID',
            'no'            => '管理番号',
            'capacity'      => '能力',
            'name'          => '機械名',
            'maker'         => 'メーカー',
            'model'         => '型式',
            'year'          => '年式',
            'location'      => '在庫場所',
            'addr1'         => '都道府県',
            'addr2'         => '市区町村',
            'addr3'         => '番地その他',
            'spec'          => '仕様',
            'accessory'     => '附属品',
            'comment'       => 'コメント',
        );
        B::downloadCsvFile($header, $result['machineList'], $filename);
        exit;
    } else if ($output == 'auction') {
        $auctionList = array();
        // 事前加工
        foreach ($result['machineList'] as $key => $ma) {
          $temp = $ma;
          $temp['auction_name'] = trim($ma['name'] . " " . $ma['maker'] . " " . $ma['model']);
          if (!empty($ma['year'])) { $temp['auction_name'] .= " " . $ma['year'] . "年式"; }
          $temp['auction_spec'] = trim($ma['spec'] . "\n\n" . $ma['accessory'] . "\n\n" . $ma['comment']);
          // $temp['start']  = date("Y/m/d H:i:s", strtotime('+7day'));
          // $temp['end']    = date("Y/m/d H:i:s", strtotime('+14day'));
          $temp['images'] = $ma['top_img'] . " " . implode(' ', $ma['imgs']);
          $auctionList[] = $temp;
        }

        $filename = date('YmdHis') . 'auction_machine_list.csv';
        $header   = array(
            'no'            => '管理番号',
            'auction_name'  => '機械名',
            'auction_spec'  => '仕様',
            '_category_id'  => 'カテゴリID',
            '_start_date'   => '開始日',
            '_start_time'   => '開始時間',
            '_end_date'     => '終了日',
            '_end_time'     => '終了時間',
            '_start_price'  => '開始価格',
            '_lwer_price'   => '最低落札価格',
            '_prompt'       => '即決価格',
            '_hashtags'     => 'ハッシュタグ',
            '_template_id'  => 'テンプレートID',
            'id'            => 'マシンライフID',
            'images'        => 'マシンライフ画像',
        );
        B::downloadCsvFile($header, $auctionList, $filename);
        exit;
    }
    //// 会社情報を取得(絞り込み用) ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'A会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    //// 会社情報を取得(絞り込み用) ////
    $aModel = new Actionlog();
    $actionCountPair = $aModel->getMachineCountPair($_user['company_id']);

    // エラーメッセージ
    /*
    if (empty($result['machineList'])) {
       $error = ('在庫機械情報は登録されていません');
    }
    */

    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($result['count']));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);

    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) { $cUri.= '?'; }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '在庫機械一覧',
        'pageDescription' => '現在の在庫機械一覧です。変更・削除する機械を選択して下さい',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        // 'companyList' => $result['companyList'],
        // 'queryDetail' => $result['queryDetail'],
        'pager'       => $pgn->getPages(),
        'cUri'        => $cUri,

        'q'           => $q,

        'company'     => $company,

        'actionCountPair' => $actionCountPair,
    ))->display("admin/machine_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '在庫機械一覧',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
