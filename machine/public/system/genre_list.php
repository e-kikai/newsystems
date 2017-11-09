<?php
/**
 * ジャンル一覧ページ表示
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
    $largeId = Req::query('l');
    
    if (empty($largeId)) { new Exception('中ジャンルIDがありません'); }

    //// 大ジャンル一覧を取得 ////
    $largeGenreTable = new LargeGenres();
    $largeGenre      = $largeGenreTable->get($largeId);
    if (empty($largeGenre)) { new Exception('該当する中ジャンル情報が取得できませんでした'); }

    $genreTable = new Genres();
    $genreList  = $genreTable->getList(array('large_genre_id' => $largeId));

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $largeGenre['large_genre'] . ' ジャンル一覧',
        'pankuzu'   => array(
            '/system/'                                                    => '管理者ページ',
            '/system/xl_genre_list.php'                                   => '大ジャンル一覧',
            "/system/large_genre_list.php?x={$largeGenre['xl_genre_id']}" => $largeGenre['large_genre'],
        ),
        'genreList'    => $genreList,
        'largeId'      => $largeId,
    ))->display("system/genre_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'ジャンル一覧',
        'pankuzu'   => array(
            '/system/'                                                    => '管理者ページ',
            '/system/xl_genre_list.php'                                   => '大ジャンル一覧',
            "/system/large_genre_list.php?x={$largeGenre['xl_genre_id']}" => $largeGenre['large_genre'],
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
