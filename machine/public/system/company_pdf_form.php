<?php
/**
 * 会社情報請求書PDF出力フォーム
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.1.0
 * @since   2015/01/09
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '会社情報 請求書PDF出力フォーム',
        'pankuzu'     => array(
            '/system/'                 => '管理者ページ',
            '/system/company_list.php' => '会社一覧',
        ),
    ))->display("system/company_pdf_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'   => '会社情報 請求書PDF出力フォーム',
        'pankuzu'   => array(
            '/system/'                 => '管理者ページ',
            '/system/company_list.php' => '会社一覧',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
