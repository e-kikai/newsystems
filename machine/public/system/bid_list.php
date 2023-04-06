<?php

/**
 * 落札結果ページ表示
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/05/08
 */
/// 設定ファイル読み込み ///
require_once '../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('system');

    /// 変数を取得 ///
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');
    $type      = Req::query('type');

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
    }
    if (!empty($e)) {
        throw new Exception($e);
    }

    /// 出品商品情報一覧を取得 ///
    $q = array(
        'bid_open_id' => $bidOpenId,
        'genre_id'    => Req::query('g'),
        'region'      => Req::query('r'),
        'keyword'     => Req::query('k'),
        'list_no'     => Req::query('no'),

        'limit'       => Req::query('limit', 50),
        'page'        => Req::query('page', 1),
        'order'       => Req::query('order'),
    );
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList($q);
    // $genreList      = $bmModel->getGenreList($q);
    // $regionList     = $bmModel->getRegionList($q);
    $count          = $bmModel->getCount($q);

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

    /// @ba-ta 20140926 件数他取得用 ///
    $fullList = $bmModel->getList(array('bid_open_id' => $bidOpenId));
    $sums = array(
        'count'        => count($fullList),
        'min_price'    => 0,
        'result_count' => 0,
        'result_price' => 0,

        'company_num'  => 0,
    );
    $cTemp = array();
    foreach ($fullList as $f) {
        $sums['min_price'] += $f['min_price'];
        $cTemp[] = $f['company_id'];
    }

    $sums['company_num'] = count(array_unique($cTemp));

    if (in_array($bidOpen['status'], array('carryout', 'after'))) {
        // 落札結果を取得
        $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

        $_smarty->assign(array(
            'resultListAsKey' => $resultListAsKey,

            'pageTitle'        => $bidOpen['title'] . ' : 落札結果',
            'pageDescription'  => '入札会落札結果です。',
        ));

        /// @ba-ta 20140926 落札件数・金額合計取得 ///
        foreach ($resultListAsKey as $r) {
            $sums['result_price'] += $r['amount'];
            if (!empty($r['amount'])) {
                $sums['result_count']++;
            }
        }
    } else {
        $_smarty->assign(array(
            'pageTitle'        => $bidOpen['title'] . ' : 入札会商品リスト',
            'pageDescription'  => '入札会商品リストです。',
        ));
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pankuzu' => array('/system/' => '管理者ページ'),
        'bidOpenId'  => $bidOpenId,
        'bidOpen'    => $bidOpen,
        'bidMachineList' => $bidMachineList,
        'genreList'      => $genreList,
        'regionList'     => $regionList,
        'pager'          => $pgn->getPages(),
        'cUri'           => $cUri,

        'q' => $q,

        'sums' => $sums,
    ))->display("system/bid_list.tpl");
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '入札会商品リスト',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
