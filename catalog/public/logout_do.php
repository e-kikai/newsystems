<?php
/**
 * メンバーページログアウト処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-catalog.php';

//// ログアウト処理 ////
Auth::logout();

//// ログインページにリダイレクト ////
header('Location:' . $_conf->login_uri . '?e=3');
exit;
