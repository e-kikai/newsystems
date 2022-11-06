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

/// Smarty初期化 ///
$_smarty = new MySmarty($_conf);

// Smartyに共通な変数をアサイン
$_smarty->assign(array(
    '_user' => $_user
));

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
// Zend_Registry::set('smarty', $_smarty);
