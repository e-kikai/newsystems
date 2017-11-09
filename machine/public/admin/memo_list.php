<?php
/**
 * メモ(ヘリテージ)一覧
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');
    
    //// 機械情報を取得 ////
    /*
    $mModel = new Memo();
    if ($id) {
        // 会社情報のチェック
        if (!$mModel->checkUser($id, $_user['id'])) {
            throw new Exception("このヘリテージはあなたのヘリテージではありません id:{$id}");
        }
        
        $machine = $mModel->get($id);
    } else {
        $memo = array('category' => '');
    }
    */
    
    /*
    // 選択用ジャンル一覧
    $categoryList = $mModel->getCategoryList();
    */
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'ヘリテージ一覧',
        // 'pageDescription'  => 'ヘリテージの' . ($id ? '変更' : '新規登録') . 'を行うフォームです',
        'pankuzu'   => array(
            '/admin/'                 => '在庫管理',
        ),
        // 'categoryList'   => $categoryList,
    ))->display("admin/memo_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'ヘリテージ一覧',
        'pankuzu'   => array(
            '/admin/'                 => '在庫管理',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
