<?php
/**
 * Web入札会マイリスト使用状況表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2014/10/01
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
    
    //// マイリストログを取得 ////
    $boModel = new BidOpen();
    $bidOpen       = $boModel->get($bidOpenId);
    $mylistLogList = $boModel->getMylistLog($bidOpenId);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => $bidOpen['title']. 'マイリスト使用状況',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'bidOpenId'  => $bidOpenId,
        'bidOpen'    => $bidOpen,
        'mylistLogList' => $mylistLogList,
    ))->display("system/bid_mylist_log.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'マイリスト使用状況',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

