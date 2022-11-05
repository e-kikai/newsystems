<?php

/**
 * 共通設定ファイル
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */

/// 例外処理デフォルト ///
set_exception_handler(function ($e) {
    echo " Machinelife System Error: ", $e->getMessage(), "\n";
});

/// Zend_Loaderでクラスファイルのオートロード設定 ///
require_once 'Zend/Loader/Autoloader.php';
$autoloader = Zend_Loader_Autoloader::getInstance()
    ->pushAutoloader(NULL, array('Smarty_', 'FPDF'))
    ->unregisterNamespace(array('Zend_', 'ZendX_'))
    ->setFallbackAutoloader(true);

// 定数設定
define('APP_PATH', realpath(dirname(__FILE__)));

/// 設定ファイル読み込み ///
$opt     = array("allowModifications" => true);
$_conf   = new Zend_Config_Ini(APP_PATH . '/config/common.ini', 'common', $opt);
$_dbConf = new Zend_Config_Ini(APP_PATH . '/config/common.ini', 'database');

/// @ba-ta 20140910 設定ファイルをRegistry登録 ///
Zend_Registry::set('_conf', $_conf);

// include_pathを追加
set_include_path(implode(PATH_SEPARATOR, array(
    $_conf->libs_path,
    $_conf->model_path,
    get_include_path()
)));

/// セッションの設定 ///
$lifetime = 60 * 60 * 24 * 7; // 1週
// $lifetime = 0;
session_save_path($_conf->session_path);
ini_set('session.gc_maxlifetime', $lifetime);
ini_set('session.gc_probability', 1);
ini_set('session.gc_divisor', 1000);
ini_set('session.cookie_lifetime', $lifetime);
ini_set('session.cookie_domain', $_conf->cookie_domain);

if (!empty($_SERVER['HTTP_USER_AGENT']) && !preg_match("/(ELB|Ruby|bot|yahoo|google|spider|dummy|crawl)/i", $_SERVER['HTTP_USER_AGENT'])) {
    session_start();

    // セッションの有効期限をcookieを再送信することで、無理やり延長
    if (!empty($_SESSION['session_persistence'])) {
        setcookie(session_name(), session_id(), time() + $lifetime, '/', $_conf->cookie_domain);
    }
}

/// リファラ処理 ///
if (isset($_SERVER['HTTP_REFERER'])) {
    $refTemp = urldecode($_SERVER['HTTP_REFERER']);
    $uriTemp = urldecode('http://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI']);
    if ($refTemp != $uriTemp) {
        $_SESSION['system']['referer'] = $refTemp;
    }
} else {
    $_SESSION['system']['referer'] = '/';
}

/// データベースアクセス ///
$_db = Zend_Db::factory($_dbConf);
$_db->setFetchMode(Zend_Db::FETCH_ASSOC);
Zend_Db_Table::setDefaultAdapter($_db);
// $_db->query("SET client_encoding = 'UNICODE';");

/// 言語ファイルのロード///
$translator = new Zend_Translate(
    'array',
    realpath(APP_PATH . '/library/lang/Zend_Validate.php'),
    'ja',
    array('scan' => Zend_Translate::LOCALE_FILENAME)
);
// デフォルトのトランスレータを設定
Zend_Validate_Abstract::setDefaultTranslator($translator);

/// controller dispatch ///
/*
Zend_Controller_Front::getInstance()
    ->setControllerDirectory($_conf->controllers_path)
    ->setParam('noViewRenderer', TRUE)
    ->dispatch();
*/

// 定数設定
define('BID_USER_START_DATE', "2022-11-01 00:00:00");
