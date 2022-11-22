<?php

/**
 * 入札会マイページログイン処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/11
 */
require_once '../../lib-machine.php';

/// ログイン処理 ///
$auth = new MyAuth();

try {
    $mail = Req::post('mail');

    $my_auth       = new MyAuth();

    // captcha認証
    if (!$my_auth->check_recaptcha($_POST['g-recaptcha-response'], $_conf->recaptcha_secret)) {
        throw new Exception("ロボット認証に失敗しました。");
    }

    // メール送信
    $my_auth = new MyAuth();
    $my_auth->send_confirmation_mail($mail);

    header('Location: /mypage/sign_up_fin.php');
    exit;
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - 確認メールの再送信',
        'pageDescription' => '登録時の確認メールを再送信します。登録したメールアドレスを入力してください。',
        'pankuzu'     => array(
            '/mypage/login.php' => 'マイページ - ログイン',
        ),

        'errorMes' => $e->getMessage(),
        "mail"     => $mail,
    ))->display("mypage/mail_resend.tpl");
}
