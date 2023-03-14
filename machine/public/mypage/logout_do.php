<?php

/**
 * 入札会マイページログアウト処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/11
 */
require_once '../../lib-machine.php';

/// ログアウト処理 ///
MyAuth::logout();

/// ログインページにリダイレクト ///
$_SESSION["flash_notice"] = "ログアウトしました。\nWeb入札会へのご参加、ありがとうございました。\nまたのご利用お待ちしております。";
header('Location:/mypage/login.php');
exit;
