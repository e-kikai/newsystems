<?php
/**
 * メンバー在庫一覧ページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    $user = Auth::isAuth('member');
    
    //// 機械情報一覧を取得 ////
    $cModel = new Contact();
    $contactList = $cModel->getList($_user['company_id']);
    
    // エラーメッセージ
    if (empty($contactList)) {
       throw new Exception('お問い合わせはありません');
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせ一覧',
        'contactList'   => $contactList,
    ))->display("admin/contact_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせ一覧',
        'pankuzu'   => array('admin/' => 'お問い合わせ一覧'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

