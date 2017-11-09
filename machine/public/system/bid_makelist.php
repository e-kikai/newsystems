<?php
/**
 * 出品番号付加、リストPDF生成フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2014/01/27
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    
    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }
    
    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $bidOpen['title'] . ' : 出品番号付加、リストPDF生成',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'bidOpenId' => $bidOpenId,
        'bidOpen'   => $bidOpen,
    ))->display("system/bid_makelist.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '出品番号付加、リストPDF生成',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
