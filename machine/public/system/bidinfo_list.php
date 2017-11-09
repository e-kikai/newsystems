<?php
/**
 * 入札会バナー一覧ページ表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/09/03
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数取得 ////
    $end = Req::query('e');
    
    //// 入札会バナー情報を取得 ////
    $bModel = new Bidinfo();
    $bidinfoList = $bModel->getList(array('end' => $end));
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '入札会バナー一覧',
        'pankuzu'     => array('/system/' => '管理者ページ'),
        'bidinfoList' => $bidinfoList,
    ))->display("system/bidinfo_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '入札会バナー一覧',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
