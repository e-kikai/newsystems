<?php
/**
 * CSV一括登録フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    //// 会社情報を取得 ////
    $cModel = new Company();
    $companyList = $cModel->getList();

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'CSV一括登録(百貨店汎用)',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'companyList' => $companyList,
    ))->display("system/csv_form.tpl");
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
