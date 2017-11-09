<?php
/**
 * 買いカードフォーム
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
    
    $id = Req::query('id');
    $type = Req::query('type');
    
    $name = $type == 1 ? '売り引合情報' : '仕入れ引合情報';
    
    //// 機械情報を取得 ////
    $mModel = new Memo();
    if ($id) {
        // 会社情報のチェック
        if (!$mModel->checkUser($id, $_user['id'])) {
            throw new Exception("この買いカードはあなたのカードではありません id:{$id}");
        }
        
        $machine = $mModel->get($id);
    } else {
        $memo = array('category' => '', 'datetime' => date('Y/m/d m:i:00'));
    }
    
    // 選択用ジャンル一覧
    $categoryList = $mModel->getCategoryList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'        => $id ? $name . 'の変更' : $name . ' 新規登録',
        'pageDescription'  => $name . 'の' . ($id ? '変更' : '新規登録') . 'を行うフォームです',
        'pankuzu'          => array(
            '/admin/'                 => '在庫管理',
        ),
        'id'             => $id,
        'memo'           => $memo,
        'categoryList'   => $categoryList,
    ))->display("admin/memo_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'        => $id ? $name . '変更' : $name . ' 新規登録',
        'pankuzu'   => array(
            '/admin/'                 => '在庫管理',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
