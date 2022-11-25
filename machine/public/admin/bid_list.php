<?php

/**
 * 入札会商品リスト(会員用)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/13
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('member');

    /// 変数を取得 ///
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    /// 入札会情報を取得 ///
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('margin', 'bid', 'carryout', 'after'))) {
        $e = "この入札会は現在、入札会の期間ではありません\n";
        $e .= "入札期間 : " . date('Y/m/d H:i', strtotime($bidOpen['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['bid_end_date']));
    }
    if (!empty($e)) {
        throw new Exception($e);
    }

    /// 出品商品情報一覧を取得 ///
    $q = array(
        'bid_open_id'    => $bidOpenId,
        'xl_genre_id'    => Req::query('x'),
        'large_genre_id' => Req::query('l'),
        // 'genre_id'      => Req::query('g'),
        'region'         => Req::query('r'),
        'state'          => Req::query('s'),
        'keyword'        => Req::query('k'),
        'list_no'        => Req::query('no'),

        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
        'order'          => Req::query('order'),
    );
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList($q);
    // $genreList      = $bmModel->getGenreList($q);
    // $regionList     = $bmModel->getRegionList($q);
    $count          = $bmModel->getCount($q);

    // ジャンル・地域一覧を取得
    $sq = array('bid_open_id' => $bidOpenId);
    $xlGenreList    = $bmModel->getXlGenreList($sq);
    $largeGenreList = $bmModel->getLargeGenreList($sq);
    $stateList      = $bmModel->getStateList($sq);
    $regionList     = $bmModel->getRegionList($sq);
    $countAll       = $bmModel->getCount($sq);

    // その他能力
    $mModel = new Machine();
    foreach ($bidMachineList as $key => $m) {
        $oSpec = $mModel->makerOthers($m['spec_labels'], $m['others']);
        if (!empty($oSpec)) {
            $bidMachineList[$key]['spec'] = $oSpec . ' | ' . $m['spec'];
        }
    }

    // 自社の入札情報を取得
    $resultListCompanyAsKey = $bmModel->getResultListCompanyAsKey($bidOpenId, $_user['company_id']);

    if (in_array($bidOpen['status'], array('carryout', 'after'))) {
        // 落札結果を取得
        $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

        $_smarty->assign(array(
            'resultListAsKey' => $resultListAsKey,

            'pageTitle'        => $bidOpen['title'] . ' : 落札結果',
            'pageDescription'  => '入札会落札結果です。出品者へのお問い合せを行えます',
        ));
    } else {
        $_smarty->assign(array(
            'pageTitle'        => $bidOpen['title'] . ' : 入札会商品リスト',
            'pageDescription'  => '入札会商品リストです。出品者へのお問い合せ、入札を行えます',
        ));
    }

    /// CSVに出力する場合 ///
    if ($output == 'csv') {
        $filename = $bidOpenId . '_bid_list.csv';
        $header   = array(
            'id'            => '商品ID',
            'list_no'       => '出品番号',
            'name'          => '商品名',
            'maker'         => 'メーカー',
            'model'         => '型式',
            'year'          => '年式',
            'addr1'         => '出品地域',
            'capacity'      => '能力',
            'spec'          => '仕様',
            'min_price'     => '最低入札金額',
            /*
            'accessory'     => '附属品',
            'comment'       => 'コメント',
            'carryout_note' => '引取留意事項',
            */
        );
        B::downloadCsvFile($header, $bidMachineList, $filename);
        exit;
    }

    /// ページャ ///
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);

    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) {
        $cUri .= '?';
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'bidMachineList' => $bidMachineList,
        'largeGenreList' => $largeGenreList,
        'regionList'     => $regionList,
        'stateList'      => $stateList,
        'xlGenreList'    => $xlGenreList,
        'count'          => $count,
        'countAll'       => $countAll,
        'pager'          => $pgn->getPages(),
        'cUri'           => $cUri,

        'q' => $q,

        'resultListCompanyAsKey' => $resultListCompanyAsKey,
    ))->display("admin/bid_list.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => '入札会商品リスト',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
