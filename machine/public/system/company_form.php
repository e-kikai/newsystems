<?php
/**
 * 会社情報登録フォーム
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/05/17
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    //// 変数の取得 ////
    $id = Req::query('id');

    //// 入札会開催情報を取得 ////
    $companyTable = new Companies();
    $company      = array();
    if ($id) {
        $company = $companyTable->get($id);
    }
    
    //// SELECT用の団体一覧 ////
    $groupTable = new Groups();
    $groupList  = $groupTable->getList();

    //// SELECT用の会員ランク一覧 ////
    $rankRatio = Companies::getRankRatio();

    //// select選択肢会社(Aランク)一覧 ////
    $companyList  = $companyTable->getList(array('rank' => 'A会員', 'is_parent' => true));
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => $id ? '会社情報変更' : '会社情報新規登録',
        'pankuzu'     => array(
            '/system/'                 => '管理者ページ',
            '/system/company_list.php' => '会社一覧',
        ),
        'id'          => $id,
        'company'     => $company,
        'groupList'   => $groupList,
        'rankRatio'   => $rankRatio,
        'companyList' => $companyList,
    ))->display("system/company_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $id ? '会社情報変更' : '会社情報新規登録',
        'pankuzu'   => array(
            '/system/'                 => '管理者ページ',
            '/system/company_list.php' => '会社一覧',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
