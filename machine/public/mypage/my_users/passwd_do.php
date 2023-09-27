<?php

/**
 * パスワードを変更する処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/27
 */
require_once '../../../lib-machine.php';

try {
    $data = Req::post('data');

    $my_user_model = new MyUser();

    // パスワード重複チェック
    if ($data["passwd"] != $_POST['passwd_02']) throw new Exception("パスワードとパスワード(確認用)が異なっています。");

    // パスワード変更処理
    $res = $my_user_model->update_passwd($data["passwd"], $_my_user['id']);

    $_SESSION["flash_notice"] = "パスワードを変更しました。";

    header('Location: /mypage/');
    exit;
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => "パスワード変更",
        'pageDescription' => '登録されているパスワードを変更します。',
        'pankuzu'         => array(
            '/mypage/' => 'マイページ',
        ),

        'errorMes' => $e->getMessage(),
        "data"     => $data,
    ))->display('mypage/my_users/passwd.tpl');
}
