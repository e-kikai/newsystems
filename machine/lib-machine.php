<?php

/**
 * 在庫機械設定ファイル
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/19
 */
require_once realpath(dirname(__FILE__)) . '/../lib-common.php';

/// 設定ファイル読み込み ///
$_siteConf = new Zend_Config_Ini(APP_PATH . '/config/machine.ini');
$_conf->merge($_siteConf);

// 認証設定
Auth::setRedirect($_conf->login_uri);
$_user = Auth::getUser();

// 入札ユーザ認証設定
$_my_user = MyAuth::get_user();

/// Smarty初期化 ///
$_smarty = new MySmarty($_conf);

// Smartyに共通な変数をアサイン
$_smarty->assign([
    '_user'    => $_user,
    '_my_user' => $_my_user,
]);

// flash
if (!empty($_SESSION["flash_notice"])) {
    $_smarty->assign('message', $_SESSION["flash_notice"]);
    $_SESSION["flash_notice"] = null;
}

if (!empty($_SESSION["flash_alert"])) {
    $_smarty->assign('errorMes', $_SESSION["flash_alert"]);
    $_SESSION["flash_alert"] = null;
}

/*
if (!Auth::check('system')) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => "マシンライフは現在メンテナンス中です (メンテナンス終了予定 : 〜2015/01/01 5:00)",
    ))->display('error.tpl');
    exit;
}
*/

// Zend_Registry::set('conf', $_conf);
Zend_Registry::set('smarty', $_smarty);

/// 例外処理デフォルト ///
set_exception_handler(function ($e) {
    $smarty = Zend_Registry::get('smarty');
    /// エラー画面表示 ///
    $smarty->assign(array(
        'pageTitle'       => 'マシンライフ システムエラー',
        'pageDescription' => 'エラーが発生しました。何度も同じエラーが発生する場合、お手数ですが事務局までご連絡お願いいたします。',
        'errorMes'        => $e->getMessage()
    ))->display('error.tpl');
});
