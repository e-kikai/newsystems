<?php
/**
 * 入札会の入札数一覧ページ(隠しページ)表示
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/07/10
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    }
    if (!empty($e)) { throw new Exception($e); }

    $bbModel = new BidBid();
    $bidBidList = $bbModel->getListAll(array('bid_open_id' => $bidOpenId));

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '入札数詳細 ' . $bidOpen["title"],
        'pankuzu'    => array('/system/' => '管理者ページ', '/system/bid_bid_list_all.php' => '入札数一覧'),
        'bidOpen'    => $bidOpen,
        'bidBidList' => $bidBidList,
    ))->display("system/bid_bid_list_detail.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '入札数詳細',
        'pankuzu'   => array('/system/' => '管理者ページ', '/system/bid_bid_list_all.php' => '入札数一覧'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
