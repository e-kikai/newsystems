<?php
/**
 * TODO情報フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    $id = Req::query('id');
    
    //// 機械情報を取得 ////
    $tModel = new Todo();
    if ($id) {
        $todo = $tModel->get($id);
    } else {
        // 新規作成デフォルトを設定
        $todo = array(
            'target' => 'member',
        );
    }
    
    $targetList = array(
        'member'  => '会員ページ',
        'machine' => '中古機械情報',
        'catalog' => '電子カタログ',
        'other'   => 'その他', 
    );
    
    // 団体一覧
    $gModel = new Group();
    $groupList = $gModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $id ? '開発TODO変更' : '開発TODO新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/todo_list.php' => '開発TODO一覧'
        ),
        'id'   => $id,
        'todo' => $todo,
        'targetList' => $targetList
    ))->display("system/todo_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $id ? '開発TODO変更' : '開発TODO新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/todo_list.php' => '開発TODO一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
