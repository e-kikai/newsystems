<?php
/**
 * カタログページログインページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../lib-catalog.php';
try {
    switch (Req::query('e')) {
        case 1:
             $_smarty->assign('errorMes', 'アカウント、パスワードが間違っています');
             break;
        case 2:
             $_smarty->assign('errorMes', 'ログインしていません');
             break;
        case 3:
             $_smarty->assign('message', 'ログアウトしました');
             break;
        case 4:
             $_smarty->assign('errorMes', 'このページを表示する権限がありません');
             break;
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => 'ログイン',
        'pageDescription' => 'アカウントとパスワードを入力してください'
    ))->display("login.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'ログイン',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
