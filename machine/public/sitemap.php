<?php

/**
 * サイトマップ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/11/08
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 特大ジャンル一覧を取得 ///
    $xlGenreTable = new XlGenres();
    $xlGenreList  = $xlGenreTable->getMachineList();

    /// 大ジャンル一覧を取得 ///
    $largeGenreTable = new LargeGenres();
    $largeGenreList  = $largeGenreTable->getMachineList();

    /// ジャンル一覧を取得 ///
    $GenreTable = new Genres();
    $genreList  = $GenreTable->getMachineList();

    /// 会社一覧を取得 ///
    $cModel      = new Company();
    $companyList = $cModel->getList(array('notnull' => true));

    /// メーカー情報を取得 ///
    $machineTable = new Machine();
    $makerList    = $machineTable->getMakerList(array('notnull' => true, 'sort' => 'maker'));

    /// 都道府県一覧 ///
    $stateTable  = new States();
    $addr1List   = $stateTable->getListByTop();

    /// 中ジャンル/メーカー一覧 ///
    $largeMakerList = $machineTable->getDoubleSearchList('', 5);

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'      => 'サイトマップ',
        'xlGenreList'    => $xlGenreList,
        'largeGenreList' => $largeGenreList,
        'genreList'      => $genreList,
        'companyList'    => $companyList,
        'makerList'      => $makerList,
        'addr1List'      => $addr1List,
        'largeMakerList' => $largeMakerList,
    ))->display('sitemap.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'サイトマップ',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
