<?php

/**
 * メール再送信ページ
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
        'pageTitle'       => 'マイページ - 確認メールの再送信',
        'pageDescription' => '登録時の確認メールを再送信します。登録したメールアドレスを入力してください。',
        'pankuzu'     => array(
            '/mypage/login.php' => 'マイページ - ログイン',
        ),
    ))->display("mypage/mail_resend.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - 確認メールの再送信',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
