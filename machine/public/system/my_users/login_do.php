<?php

/**
 * 凍結処理
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/28
 */

require_once '../../../lib-machine.php';

/// 認証処理 ///
Auth::isAuth('system');

/// 変数を取得 ///
$my_user_id = Req::post('id');

/// 代理ログイン ///
$auth = new MyAuth();
$auth->systemLogin($my_user_id);

$_SESSION["flash_notice"] = "マイページに代理ログインしました。";

header('Location: /mypage/');
exit;
