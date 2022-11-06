<?php

/**
 * 電子カタログ設定ファイル
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/04/19
 */
try {
    require_once realpath(dirname(__FILE__)) . '/../lib-common.php';

    /// 設定ファイル読み込み ///
    $_siteConf = new Zend_Config_Ini(APP_PATH . '/config/catalog.ini');
    $_conf->merge($_siteConf);

    // 認証設定
    Auth::setRedirect($_conf->login_uri);
    $_user = Auth::getUser();

    /// Smarty初期化 ///
    $_smarty = new MySmarty($_conf);
    // Zend_Registry::set('smarty', $_smarty);

    // Smartyに共通な変数をアサイン
    $_smarty->assign(array(
        '_user' => $_user
    ));
} catch (Exception $exp) {
    echo 'catalog : System Error<br />';
    echo $exp->getMessage();
}
