<?php
/**
 * 入札会バナー情報登録フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/09/03
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    $id = Req::query('id');
    //// 入札会開催情報を取得 ////
    if (!empty($id)) {
        $bModel = new Bidinfo();
        $bidinfo = $bModel->get($id);
    } else {
        // 新規作成デフォルト
        $bidinfo = array();
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => !empty($id) ? '入札会バナー変更' : '入札会バナー新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/bidinfo_list.php' => '入札会バナー一覧',
        ),
        'bidinfo'   => $bidinfo,
        'id'        => $id,
    ))->display("system/bidinfo_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => !empty($id) ? '入札会バナー変更' : '入札会バナー新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/bidinfo_list.php' => '入札会バナー一覧',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
