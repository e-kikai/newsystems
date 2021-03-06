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
    $output    = Req::query('output');

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
        'pageTitle'       => 'オークション用CSV出力',
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
    ))->display("admin/machine_auction.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'オークション用CSV出力',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
