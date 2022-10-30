<?php
/**
 * トップページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    //// パラメータ取得 ////
    // 新着情報取得日数
    $news = $_conf->news;

    //// 特大ジャンル・大ジャンル一覧を取得 ////
    $gModel         = new Genre();
    // $xlGenreList    = $gModel->getXlList(Genre::HIDE_CATALOG);
    // $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);

    $xlGenreTable   = new XlGenres();
    $xlGenreList    = $xlGenreTable->getMachineList();

    $largeGenreTable   = new LargeGenres();
    $largeGenreList = $largeGenreTable->getMachineList();

    //// 新着情報を取得 ////
    $mModel         = new Machine();
    // $newMachineList = $mModel->getList(array('period' => $news, 'sort' => 'created_at', 'limit' => 50));
    $newMachineList = $mModel->getList(array('xl_genre_id' => array(1,2,3,4,5), 'period' => $news, 'sort' => 'created_at', 'limit' => 6));
    //$newToolList    = $mModel->getList(array('xl_genre_id' => array(6,7,8,9,10,11), 'period' => $news, 'sort' => 'created_at', 'limit' => 5));

    // 最近見た機械
    // $IPLogMachineList = $mModel->getIPLogList();

    //// 在庫総数 ////
    $mModel        = new Machine();
    $mCountAll     = $mModel->getCountAll();
    $cCountByEntry = $mModel->getCountCompany();

    //// 事務局お知らせ ////
    // $iModel   = new Info();
    // $infoList = $iModel->getList('machine', null, 20);

    //// SELECT用都道府県一覧 ////
    $stateTable  = new States();
    $addr1List   = $stateTable->getListByTop();

    //// 入札会開催情報の取得 ////
    $cModel      = new BidOpen();
    $bidOpenList = $cModel->getList(array('isopen' => true));

    // 年度情報を取得
    $bidYear  = date('n') <= 3 ? date('Y') - 1 : date('Y');
    $tempList = $cModel->getList();

    $bidOpenYearList = array();
    foreach ($tempList as $bo) {
        $tempDate = strtotime($bo['bid_end_date']);
        $tempYear = date('n', $tempDate) <= 3 ? date('Y', $tempDate) - 1 : date('Y', $tempDate);
        if ($bidYear == $tempYear) { $bidOpenYearList[] = $bo; }
    }
    $bidOpenYearList = array_reverse($bidOpenYearList);

    //// 入札会バナー情報を取得 ////
    $bModel      = new Bidinfo();
    $bidinfoList = $bModel->getList(array('sort' => "bid_date"));

    // $temp        = $bModel->getList();
    // $bidinfoList = array($temp[3], $temp[0], $temp[2], $temp[1],);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pankuzu'          => false,
        'largeGenreList'   => $largeGenreList,
        'xlGenreList'      => $xlGenreList,
        'largeGenreId'     => array(),
        'newMachineList'   => $newMachineList,
        // 'newToolList'      => $newToolList,

        'mCountAll'        => $mCountAll,
        'cCountByEntry'    => $cCountByEntry,
        // 'infoList'         => $infoList,

        'addr1List'        => $addr1List,

        // 'IPLogMachineList' => $IPLogMachineList,
        'bidOpenList'      => $bidOpenList,
        'bidinfoList'      => $bidinfoList,
        'bidYear'          => $bidYear,
        'bidOpenYearList'  => $bidOpenYearList,

    ))->display('index.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
