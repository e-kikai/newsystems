<?php
/**
 * メンバー会社情報フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');
  
    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);

    // 所属団体の情報を取得
    $gModel = new Group();
    $company['group'] = $gModel->get($company['group_id']);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '会社情報の変更',
        'pageDescription' => '会社情報の変更を行うフォームです',
        'pankuzu'         => array('admin/' => '在庫管理'),
        'company'         => $company
    ))->display("admin/company_form.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '会社情報の変更',
        'pankuzu'   => array('admin/' => '在庫管理'),
        'errorMes'  => $e->getMessage()
    ))->display('admin/index.tpl');
}
