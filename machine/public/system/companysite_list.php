<?php
/**
 * 自社サイト一覧ページ表示
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/11/07
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    //// 自社サイト一覧を取得 ////
    $companysiteTable = new Companysites();
    $companysiteList  = $companysiteTable->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '自社サイト一覧',
        'pankuzu'         => array('/system/' => '管理者ページ'),
        'companysiteList' => $companysiteList,
    ))->display("system/companysite_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

