<?php
/**
 * Web入札会 商品出品登録フォーム
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/06/18
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');
    
    if (Req::query('e') == 1) {
        $_smarty->assign('errorMes', 'Web入札会に商品を出品するためには、商品出品登録が必要です');
    }
  
    //// 会社情報を取得 ////
    $cModel  = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => 'Web入札会 商品出品登録',
        'pageDescription' => 'Web入札会に商品を出品するには、以下のフォームに情報を登録して下さい',
        'pankuzu'         => array('admin/' => '会員ページ'),
        'company'         => $company
    ))->display("admin/bid_entry_form.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会 商品出品登録',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
