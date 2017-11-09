<?php
/**
 * 大ジャンル一覧ページ表示
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
    $xlGenreId = Req::query('x');
    
    if (empty($xlId)) { new Exception('大ジャンルIDがありません'); }

    //// 大ジャンル一覧を取得 ////
    $xlGenreTable  = new XlGenres();
    $xlGenre       = $xlGenreTable->get($xlGenreId);
    if (empty($xlGenre)) { new Exception('該当する大ジャンル情報が取得できませんでした'); }

    $largeGenreTable  = new LargeGenres();
    $largeList        = $largeGenreTable->getList(array('xl_genre_id' => $xlGenreId));

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $xlGenre['xl_genre'] . ' 中ジャンル一覧',
        'pankuzu'   => array('/system/' => '管理者ページ', '/system/xl_genre_list.php' => '大ジャンル一覧'),
        'xlGenreId' => $xlGenreId,
        'largeList' => $largeList,
    ))->display("system/large_genre_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '中ジャンル一覧',
        'pankuzu'   => array('/system/' => '管理者ページ', '/system/xl_genre_list.php' => '大ジャンル一覧'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
