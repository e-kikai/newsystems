<?php

/**
 * 新着情報ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 会社情報を取得 ///
    $companyTable = new Companies();
    $companyList  = $companyTable->getList(array('notnull' => true, 'sort' => "company"));

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => '会社一覧',
        'companyList' => $companyList
    ))->display('company_list.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '会社一覧',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
