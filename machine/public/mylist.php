<?php
/**
 * マイリスト在庫機械一覧情報ページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('mylist');
    
    //// 在庫情報を検索 ////
    $myModel = new Mylist();
    $idList = $myModel->getArray($_user['id'], 'machine');
    
    $mModel = new Machine();
    $q = array(
        'id' => $idList,
        
        'large_genre_id' => Req::query('l'),
        'genre_id'       => Req::query('g'),
        'company_id'     => Req::query('c'),
        'keyword'        => Req::query('k'),
        
        'period'         => Req::query('pe'),
        'start_date'     => Req::query('start_date'),
        'end_date'       => Req::query('end_date'),
        
        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
    );
    $result = $mModel->search($q);
    $os     = $mModel->getOtherSpecs();
    
    //// 大ジャンル一覧を取得 ////
    $gModel = new Genre();
    $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);
    
    // カレントURL、ページタイトル生成
    $cUrl = array();
    $pageTitle = array();
    foreach ($result['queryDetail'] as $val) {
        $pageTitle[] = $val['label'];
        $cUrl[] = $val['key'] . '[]=' . $val['id'];
    }
    
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($result['count']));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);
    
    if (empty($result['machineList'])) {
        $_smarty->assign('message', 'この条件の機械は現在登録されていません');
    }
    
    // 現在既に登録されている機械IDを取得
    $bmModel = new BidMachine();
    $bidMachineIds = $bmModel->getMachineIds();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'マイリスト(在庫機械)',
        'cUri'        => 'mylist.php',
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        'companyList' => $result['companyList'],
        'queryDetail' => $result['queryDetail'],
        'largeGenreList' => $largeGenreList,
        'largeGenreId' => Req::query('l'),
        
        'pager'       => $pgn->getPages(),
        'os'          => $os,
        
        'k'           => B::f(Req::query('k')),
        
        'bidMachineIds' => $bidMachineIds,
    ))->display('search.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'マイリスト(在庫機械)',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
