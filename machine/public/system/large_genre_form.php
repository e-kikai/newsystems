<?php
/**
 * 大ジャンルフォーム表示
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/12/01
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数取得 ////
    $largeId = Req::query('id');
    $xlId    = Req::query('x');

    if (!empty($largeId)) {
        //// 大ジャンル情報を取得 ////
        $largeGenreTable = new LargeGenres();
        $largeGenre      = $largeGenreTable->get($largeId);
        if (empty($largeGenre)) { new Exception('該当する中ジャンル情報が取得できませんでした'); }
    } else {
        $xlGenreTable = new XlGenres();
        $xlgenre      = $xlGenreTable->get($xlId);

        $largeGenre = array(
            'xl_genre_id' => $xlId,
            'xl_genre'    => $xlgenre['xl_genre'],
        );
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '中ジャンルフォーム',
        'pankuzu'    => array(
            '/system/'                  => '管理者ページ',
            '/system/xl_genre_list.php' => '大ジャンル一覧',
            '/system/large_genre_list.php?x=' . $largeGenre['xl_genre_id']
                => $largeGenre['xl_genre'] . ' 中ジャンル一覧',
        ),
        'largeGenre' => $largeGenre,
    ))->display("system/large_genre_form.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '中ジャンルフォーム',
        'pankuzu'   => array(
            '/system/'                  => '管理者ページ',
            '/system/xl_genre_list.php' => '大ジャンル一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
