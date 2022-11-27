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

if ($auth->login($_POST['mail'], $_POST['passwd'], isset($_POST['check']))) {
  // // ロギング
  // $lModel = new Actionlog();
  // $lModel->set('machine', 'login');

  $_SESSION["flash_notice"] = "マイページにログインしました。\nWeb入札会にご参加ありがとうございます。";
  header('Location: /mypage/');
} else {
  $_SESSION["flash_alert"] = "マイページにログイン出来ませんでした。\nお手数ですが、入力したメールアドレスとパスワードをご確認下さい。";
  header('Location: /mypage/login.php?e=1');
}
exit;
