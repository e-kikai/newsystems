<?php

/**
 * ユーザ登録ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/09
 */
require_once '../../lib-machine.php';

try {
    $data = Req::post('data');

    $my_user_model = new MyUser();
    $my_auth       = new MyAuth();

    // 国内事業者チェック
    if ($_POST["domestic"] == false) {
        throw new Exception("Web入札会には国内事業者のみ参加できます。\n\n申し訳ありませんが、国外の事業者は入札に参加・取引を行うことができません。\nご了承ください。");
    }

    // パスワード重複チェック
    if ($data["passwd"] != $_POST['passwd_02']) throw new Exception("パスワードとパスワード(確認用)が異なっています。");

    // 既存チェック
    $user = $my_user_model->get_by_mail($data["mail"]);
    if (!empty($user)) {
        throw new Exception("このメールアドレスは、既に登録されています。\n\nパスワードの再設定、確認メールの再送信は、下のリンクから行えます。");
    }

    // captcha認証
    if (!$my_auth->check_recaptcha($_POST['g-recaptcha-response'], $_conf->recaptcha_secret)) {
        throw new Exception("ロボット認証に失敗しました。");
    }

    // ユーザ情報保存処理
    $my_user_model->my_insert($data);

    // メール送信
    $my_auth = new MyAuth();
    $my_auth->send_confirmation_mail($data["mail"]);

    header('Location: /mypage/sign_up_fin.php');
    exit;
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - 入札会ユーザ登録',
        'pageDescription' => '入札会で入札を行うため、ユーザ登録を行います。必要な情報を入力して「登録する」をクリックしてください。',
        'pankuzu'         => array(
            '/mypage/login.php' => 'マイページ - ログイン',
        ),

        'errorMes' => $e->getMessage(),
        "data"     => $data,
    ))->display("mypage/sign_up.tpl");
}
