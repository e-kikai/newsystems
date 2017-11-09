<?php
/**
 * 広告バナー掲載のご案内・お申込みフォームページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/02/07
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// 都道府県一覧 ////
    $sModel = new State();
    $addr1List = $sModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '広告バナー掲載のご案内・お申込みフォーム',
        'pankuzu'     => array('/help_banner.php' => '広告バナー掲載のご案内'),
        'addr1List'   => $addr1List,
    ))->display('help_banner_form.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '広告バナー掲載のご案内・お申込みフォーム',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
