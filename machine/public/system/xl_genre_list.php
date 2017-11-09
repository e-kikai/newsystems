<?php
/**
 * 特大ジャンル一覧ページ表示
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/09/19
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数取得 ////
    
    //// 入札会バナー情報を取得 ////
    $xlGenreTable = new XlGenres();
    $xlList       = $xlGenreTable->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '大ジャンル一覧',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'xlList'    => $xlList,
    ))->display("system/xl_genre_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '大ジャンル一覧',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
