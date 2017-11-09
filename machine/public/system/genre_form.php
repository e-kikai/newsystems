<?php
/**
 * ジャンルフォーム表示
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
    $genreId = Req::query('id');
    $largeId = Req::query('l');

    if (!empty($genreId)) {
        //// ジャンル情報を取得 ////
        $genreTable = new Genres();
        $genre      = $genreTable->get($genreId);
        if (empty($genre)) { new Exception('該当するジャンル情報が取得できませんでした'); }      
    } else {
        $largeGenreTable = new LargeGenres();
        $largeGenre      = $largeGenreTable->get($largeId);

        $genre = array(
            'xl_genre_id'    => $largeGenre['xl_genre_id'],
            'large_genre_id' => $largeId,
            'xl_genre'       => $largeGenre['xl_genre'],
            'large_genre'    => $largeGenre['large_genre'],
        );
    }

    //// その他能力の選択肢 ////
    $machineTable = new Machine();
    $otherSpecs   = $machineTable->getOtherSpecs();
    $others = array(
        'number' => '数値',
        'string' => '文字列',
        'select' => '選択肢',
    );

    foreach ($otherSpecs as $key => $o) {
        $temp = implode($o[1], $o[0]);
        $others[$key] = "{$key} ({$temp})";
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => 'ジャンルフォーム',
        'pankuzu'    => array(
            '/system/'                  => '管理者ページ',
            '/system/xl_genre_list.php' => '大ジャンル一覧',
            '/system/large_genre_list.php?x=' . $genre['xl_genre_id']
                => $genre['xl_genre'],
            '/system/genre_list.php?l=' . $genre['large_genre_id']
                => $genre['large_genre'] . ' ジャンル一覧',
        ),
        'genre'      => $genre,
        // 'others'     => $others,
    ))->display("system/genre_form.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'ジャンルフォーム',
        'pankuzu'   => array(
            '/system/'                  => '管理者ページ',
            '/system/xl_genre_list.php' => '大ジャンル一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
