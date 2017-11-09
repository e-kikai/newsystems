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
    
    $cModel = new BidOpen();
    $bidOpenList = $cModel->getBidCountList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '入札会 入札数一覧',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'bidOpenList'   => $bidOpenList,
    ))->display("system/bid_bid_list_all.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '入札会 入札数一覧',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

