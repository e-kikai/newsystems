<?php
/**
 * 入札会開催一覧ページ表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/05/26
 */
//// 設定ファイル読み込み ////
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    $cModel = new BidOpen();
    $bidOpenList = $cModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会一覧',
        'pageDescription' => '過去のWeb入札会の一覧です。タイトルをクリックすると、過去の入札会の履歴を表示できます',
        'bidOpenList'     => $bidOpenList,
    ))->display("bid_open_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会一覧',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

