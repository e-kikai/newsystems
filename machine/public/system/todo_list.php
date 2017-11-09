<?php
/**
 * TODO一覧表示ページ表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2012/10/29
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    $q = array(
        'target' => Req::query('t'),
        'action' => Req::query('a'),
        'page'   => Req::query('p'),
        'limit'  => Req::query('limit'),
    );
    
    $tModel = new Todo();
    $todoList = $tModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '開発TODO一覧',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'todoList'  => $todoList,
    ))->display("system/todo_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '開発TODO一覧',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

