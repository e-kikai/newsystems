<?php
/**
 * 在庫機械一覧(研削)ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/01/07
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    //// 在庫情報を検索 ////
    $q = array(
        'xl_genre_id'    => Req::query('x'),
        'large_genre_id' => Req::query('l'),
        'genre_id'       => Req::query('g'),
        'company_id'     => Req::query('c'),
        'keyword'        => Req::query('k'),
        'maker'          => Req::query('ma'),

        'period'         => Req::query('pe'),
        'start_date'     => Req::query('start_date'),
        'end_date'       => Req::query('end_date'),
        'is_youtube'     => Req::query('youtube'),

        'limit'          => Req::query('limit', 30),
        'page'           => Req::query('page', 1),
    );
    $mModel = new Machine();
    $result = $mModel->search($q);
    // $os     = $mModel->getOtherSpecs();
    // foreach($result['machineList'] as $key => $m) {
    //     $oSpec = $mModel->makerOthers($m['spec_labels'], $m['others']);
    //     if (!empty($oSpec)) {
    //         $result['machineList'][$key]['spec'] = $oSpec . ' | ' . $m['spec'];
    //     }
    // }

    //// 大ジャンル一覧を取得 ////
    // $gModel         = new Genre();
    // $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);

    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($result['count']));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);

    // カレントURL、ページタイトル生成
    $cUri = array();
    $pageTitle = array();
    foreach ($result['queryDetail'] as $val) {
        $pageTitle[] = $val['label'];
        $cUri[] = $val['key'] . '[]=' . $val['id'];
    }

    if ((B::f(Req::query('k')))) {
        $pageTitle[] = B::f(Req::query('k'));
        $cUri[] = 'k=' . B::f(Req::query('k'));
    }

    if (empty($result['machineList'])) {
        $_smarty->assign('message', 'この条件の機械は現在登録されていません');
    }

    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) { $cUri.= '?'; }

    //// リファラ処理 ////
    // デフォルト
    $backUri   = '';
    $backTitle = '';
    $pankuzu = array();

    // ジャンルと会社で検索した時のみ
    if (!empty($q['large_genre_id']) && !empty($q['company_id']) && !empty($_SERVER['HTTP_REFERER'])) {
        $ref = urldecode($_SERVER['HTTP_REFERER']);

        if (strstr($ref, 'search.php')) {
            $backUri   = $ref;
            $backTitle = '検索結果';
            $pankuzu = array($ref => '検索結果');
        } elseif (strstr($ref, 'news.php')) {
            $backUri   = $ref;
            $backTitle = '新着情報';
            $pankuzu = array($ref => '新着情報');
        } elseif (strstr($ref, 'mylist.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(在庫機械)';
            $pankuzu = array($ref => 'マイリスト(在庫機械)');
        } elseif (strstr($ref, 'company_list.php')) {
            $backUri   = $ref;
            $backTitle = '会社一覧';
            $pankuzu = array($ref => '会社一覧');
        } elseif (strstr($ref, 'mylist_company.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(会社)';
            $pankuzu = array($ref => 'マイリスト(会社)');
        }
    }

    // 大ジャンルのときのNC装置表示
    $isNc = false;
    $isNcArray = array(1,2,3,4,5,6,7,8);

    if (!empty($q['large_genre_id'])) {
        $isNc = array_intersect($isNcArray, (array)$q['large_genre_id']) ? true : false;
    }

    // 小ジャンルのときのパンくず表示取得
    if (!empty($q['genre_id'])) {
        $gModel = new Genre();
        $res = $gModel->get($q['genre_id']);
        if (!empty($res[0])) {
            $pankuzu = array('search.php?l=' . $res[0]['large_genre_id'] =>  $res[0]['large_genre']);
            $isNc    = in_array($res[0]['large_genre_id'], $isNcArray) ? true : false;
        }
    }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bmModel = new BidMachine();
    $lModel  = new LargeGenres();

    $bidOpenList = $boModel->getList(array('isdisplay' => true));

    if (!empty($q['large_genre_id'])) {
        foreach ($bidOpenList as $key => $bo) {
            $bidOpenList[$key]['machines'] = $bmModel->getList(array(
                'bid_open_id'    => $bo['id'],
                'large_genre_id' => $q['large_genre_id']
            ));

            $bidOpenList[$key]['large_genre'] = $lModel->get($q['large_genre_id']);
        }
    }

    // 現在既に登録されている入札会商品情報を取得
    $bidMachineIds = $bmModel->getMachineIds();

    //// 表示変数アサイン ////
    $template = 'search.tpl';
    // $title    = implode(' /', $pageTitle) . ' :: 検索結果';
    $title     = implode('/', $pageTitle) . 'の中古機械';
    $keywords  = implode(',', $pageTitle);

    if (!empty($q['is_youtube'])) {
        $title    = '動画一覧';
        $keywords = '動画';
        $template = 'system/test/youtube_test_01.tpl';
    }
    $_smarty->assign(array(
        'pageTitle'    => $title,
        'keywords'     => $keywords,
        'pankuzu'      => $pankuzu,
        'cUri'         => $cUri,
        'genreList'    => $result['genreList'],
        'makerList'    => $result['makerList'],
        'machineList'  => $result['machineList'],
        'companyList'  => $result['companyList'],
        'addr1List'    => $result['addr1List'],
        'capacityList' => $result['capacityList'],
        'queryDetail'  => $result['queryDetail'],
        // 'largeGenreList' => $largeGenreList,
        'largeGenreId' => Req::query('l', array()),
        'genreId'      => Req::query('g', array()),
        'isNc'         => $isNc,
        'k'            => B::f(Req::query('k')),
        'pager'        => $pgn->getPages(),
        // 'os'          => $os,

        'bidOpenList'   => $bidOpenList,
        'bidMachineIds' => $bidMachineIds,
    ))->display($template);
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '検索結果',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
