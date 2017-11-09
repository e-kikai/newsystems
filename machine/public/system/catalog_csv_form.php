<?php
/**
 * 電子カタログCSV一括登録・変更
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/02/14
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '電子カタログCSV一括登録・変更',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
    ))->display("system/catalog_csv_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'CSV一括登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
