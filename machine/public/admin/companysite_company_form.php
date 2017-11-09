<?php
/**
 * 自社サイト追加情報フォーム
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2014/11/10
 */
require_once '../../lib-machine.php';
//// ログイン処理 ////
try {
    //// 認証 ////
    Auth::isAuth('member');
    
    //// 自社サイト情報の取得 ////
    $companysiteTable = new Companysites();
    $site             = $companysiteTable->getByCompanyId($_user['company_id']);
    if (empty($site)) { throw new Exception('サイト情報が取得できませんでした'); }
    
    //// 会社情報取得 ////
    $compnayTable = new Company();
    $company      = $compnayTable->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '自社サイト 追加会社情報変更',
        'pageDescription' => '自社サイトの内容を編集します',
        'pankuzu'         => array('admin/' => '会員ページ'),
        'company'         => $company,
        'site'            => $site,
    ))->display("admin/companysite_company_form.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
