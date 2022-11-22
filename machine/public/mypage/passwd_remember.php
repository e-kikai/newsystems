<?php

/**
 * パスワード再設定ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/11
 */
require_once '../../lib-machine.php';
try {

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - パスワード再設定',
        'pageDescription' => 'パスワードの再設定を行いますので、メールアドレスを入力してください。再設定を行うためのメールを送信します。',
        'pankuzu'     => array(
            '/mypage/login.php' => 'マイページ - ログイン',
        ),
    ))->display("mypage/passwd_remember.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - パスワード再設定',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
