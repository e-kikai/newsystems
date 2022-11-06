<?php

/**
 * パスワード変更フォーム
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-catalog.php';
/// ログイン処理 ///
try {
    /// 認証 ///
    Auth::isAuth('catalog');

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'パスワード変更',
        'pageDescription' => 'アカウントと現在のパスワード、変更するパスワードを入力してください',
    ))->display("passwd_change.tpl");
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
