<?php

/**
 * 入札会登録確認処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/18
 */
require_once '../../lib-machine.php';

/// ログイン処理 ///
$auth = new MyAuth();

try {
    $id    = Req::query('id');
    $token = Req::query('t');

    $my_auth       = new MyAuth();

    // チェック処理
    $res = $my_auth->confirmation($id, $token);

    if ($res) {
        $_SESSION["flash_notice"] = "ユーザ認証が完了しました。\n早速、以下のフォームからマイページにログインしてみてください。";
        header('Location: /mypage/login.php');
    } else {
        $_SESSION["flash_alert"] = "ユーザ認証に失敗しました。お手数ですが、もう一度メールのリンクにアクセスしてみてください。";
        header('Location: /mypage/login.php');
    }
} catch (Exception $e) {
    header('Location: /mypage/login.php?e=7');
}
exit;
