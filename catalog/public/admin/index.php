<?php
/**
 * 電子カタログ管理ページメニュー
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/05/15
 */
//// 設定ファイル読み込み ////
require_once '../../lib-catalog.php';
try {
    //// 認証 ////
    Auth::isAuth('admin');
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '管理ページメニュー',
    ))->display("admin/index.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

