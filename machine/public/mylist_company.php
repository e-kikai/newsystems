<?php
/**
 * マイリスト(会社)ページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/11/08
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    $companyList = array();
    
    //// 会社マイリストを検索 ////
    $myModel = new Mylist();
    $res = $myModel->getArray($_user['id'], 'company');

    if (!empty($res)) {
        $cModel = new Company();
        $companyList = $cModel->getList(array('id' => $res));
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'マイリスト(会社)',
        'cUri'        => 'mylist_company.php',
        'companyList'  => $companyList,
    ))->display('company_list.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'マイリスト(会社)',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
