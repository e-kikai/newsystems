<?php
/**
 * 取扱説明書目録ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2018/07/17
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '機械情報センター 機械取扱説明書について',
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
        ),
    ))->display("admin/manuals.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '機械情報センター 機械取扱説明書について',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
