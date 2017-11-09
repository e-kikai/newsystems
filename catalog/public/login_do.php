<?php
/**
 * メンバーログイン処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-catalog.php';
//// ログイン処理 ////
$auth = new Auth();
if ($auth->login($_POST['mail'], $_POST['passwd'])) {
    // ロギング
    $lModel = new Actionlog();
    $lModel->set('catalog', 'login');
    header('Location: /');
} else {
    header('Location: ' . $_conf->login_uri . '?e=1');
}
