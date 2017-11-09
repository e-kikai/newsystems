<?php
/**
 * 自社サイトトップページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/04/11
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// パラメータ取得 ////

    //// URLから自社サイト情報の取得 ////
    $companysiteTable = new Companysites();
    $site             = $companysiteTable->getByUrl($_SERVER['REQUEST_URI']);
        
    // 会社情報の取得
    $companyTable = new Companies();
    $company      = $companyTable->get($site['company_id']);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pankuzu'   => false,
        'pageTitle' => $site['company'],
        'site'      => $site,
        'company'   => $company,
    ))->display('companysite/index.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
