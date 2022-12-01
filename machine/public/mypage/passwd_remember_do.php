<?php

/**
 * パスワード変更ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/09
 */
require_once '../../lib-machine.php';

try {
    $mail = Req::post('mail');

    $my_auth = new MyAuth();

    // captcha認証
    if (!$my_auth->check_recaptcha($_POST['g-recaptcha-response'], $_conf->recaptcha_secret)) {
        throw new Exception("ロボット認証に失敗しました。");
    }

    // メール送信
    $my_auth->send_passwd_remember_mail($mail);

    header('Location: /mypage/passwd_remember_fin.php');
    exit;
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - パスワード再設定',
        'pageDescription' => 'パスワードの再設定を行いますので、メールアドレスを入力してください。再設定を行うためのメールを送信します。',
        'pankuzu'     => array(
            '/mypage/login.php' => 'マイページ - ログイン',
        ),

        'errorMes' => $e->getMessage(),
        "mail"     => $mail,
    ))->display("mypage/sign_up.tpl");
}
