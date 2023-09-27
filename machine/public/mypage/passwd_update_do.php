<?php

/**
 * パスワードを変更する処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/12/01
 */
require_once '../../lib-machine.php';

try {
    $my_user_id = Req::post('id');
    $token      = Req::post('token');
    $data       = Req::post('data');

    $my_user_model = new MyUser();
    $my_auth = new MyAuth();

    // 認証チェック
    if (!$my_auth->check_token($my_user_id, $token)) {
        throw new Exception("パスワードとパスワード(確認用)が異なっています。");
    }

    // パスワード重複チェック
    if ($data["passwd"] != $_POST['passwd_02']) throw new Exception("パスワードとパスワード(確認用)が異なっています。");

    // パスワード変更処理
    $res = $my_user_model->update_passwd($data["passwd"], $my_user_id);

    $_SESSION["flash_notice"] = "パスワードを変更しました。\nマイページのログインしてみてください。";

    header('Location: /mypage/login.php');
    exit;
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => "パスワード変更",
        'pageDescription' => '登録されているパスワードを変更します。',
        'pankuzu'         => array(),

        'errorMes' => $e->getMessage(),
        "my_user_id"      => $my_user_id,
        "token"           => $token,
    ))->display('mypage/passwd_remember_edit.tpl');
}
