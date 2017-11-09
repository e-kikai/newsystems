<?php
/**
 * 自社サイトお問い合せページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/04/11
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// パラメータ取得 ////
    $machineId = Req::query('m');

    //// URLから自社サイト情報の取得 ////
    $companysiteTable = new Companysites();
    $site             = $companysiteTable->getByUrl($_SERVER['REQUEST_URI']);
        
    //// 機械情報一覧を取得 ////
    $machineList = array();
    if (!empty($machineId)) {
        $mModel      = new Machine();
        $machineList = $mModel->getList(array('id' => $machineId));
    }
    
    //// 都道府県一覧 ////
    $sModel    = new State();
    $addr1List = $sModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pankuzu'     => false,
        'pageTitle'   => 'お問い合せ - ' . $site['company'],
        'site'        => $site,
        
        'addr1List'   => $addr1List,
        'machineList' => $machineList,
    ))->display('companysite/contact.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
