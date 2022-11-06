<?php

/**
 * マイリスト(検索条件)ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 検索条件マイリストを検索 ///
    $myModel = new Mylist();
    $res = $myModel->getArray($_user['id'], 'genres');

    if ($res) {
        $gModel = new Genre();
        $genresList = array();
        foreach ($res as $val) {
            $res = $gModel->getLargeGenre(explode(',', $val));
            $res['genre_ids'] = $val;
            $genresList[] = $res;
        }
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'マイリスト(検索条件)',
        'cUrl'        => 'mylist_genres.php',
        'genresList'  => $genresList,
    ))->display('mylist_genres.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'マイリスト(検索条件)',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
