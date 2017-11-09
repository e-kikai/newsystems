<?php
/**
 * 特大ジャンルフォーム表示
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/09/29
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数取得 ////
    $xlId = Req::query('id');

    if (!empty($xlId)) {
        //// 特大ジャンル情報を取得 ////
        $xlGenreTable = new XlGenres();
        $xlGenre      = $xlGenreTable->get($xlId);
        if (empty($xlGenre)) { new Exception('該当する大ジャンル情報が取得できませんでした'); }      
    } else {
        $xlGenre = array();
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '大ジャンルフォーム',
        'pankuzu'   => array('/system/' => '管理者ページ', '/system/xl_genre_list.php' => '大ジャンル一覧'),
        'xlGenre'   => $xlGenre,
    ))->display("system/xl_genre_form.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '大ジャンル一覧',
        'pankuzu'   => array('/system/' => '管理者ページ', '/system/xl_genre_list.php' => '大ジャンル一覧'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
