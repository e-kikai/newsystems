<?php
/**
 * 自社サイト登録フォーム
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/11/07
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    //// 変数の取得 ////
    $companysiteId = Req::query('id');

    //// 入札会開催情報を取得 ////
    $companysite = array();
    if ($companysiteId) {
        $companysitTeable = new Companysites();
        $companysite      = $companysitTeable->get($companysiteId);
    }
    
    //// 新規登録用の会社一覧(ランクB以上) ////
    $companyTable = new Companies();
    $companyList  = $companyTable->getList(array('rank' => $companyTable::RANK_B));
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'     => $companysiteId ? '自社サイト情報変更' : '新規登録',
        'pankuzu'       => array(
            '/system/'                     => '管理者ページ',
            '/system/companysite_list.php' => '自社サイト一覧',
        ),
        'companysiteId' => $companysiteId,
        'companysite'   => $companysite,
        'companyList'   => $companyList,
    ))->display("system/companysite_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $companysiteId ? '自社サイト情報変更' : '新規登録',
        'pankuzu'   => array(
            '/system/'                     => '管理者ページ',
            '/system/companysite_list.php' => '自社サイト一覧',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
