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

$id    = Req::query('id');
$token = Req::query('t');

// チェック処理
$my_auth = new MyAuth();
$res = $my_auth->check_token($id, $token);

if ($my_auth->check_token($id, $token)) {
  /// 表示変数アサイン ///
  $_smarty->assign(array(
    'pageTitle'       => "パスワード変更",
    'pageDescription' => '登録されているパスワードを変更します。',
    'pankuzu'         => array(),

    "my_user_id"      => $id,
    "token"           => $token,
  ))->display('mypage/passwd_remember_edit.tpl');
} else {
  $_SESSION["flash_alert"] = "メールアドレスのチェックに失敗しました。\nお手数ですが、もう一度メールのリンクにアクセスしてみてください。";
  header('Location: /mypage/passwd_remember.php');
}

exit;
