<?php
/**
 * 入札会商品リスト(会員用)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/13
 */
require_once '../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');

    //// 変数を取得 ////
    $bidOpenId     = Req::query('o');
    // $site         = Req::query('site');
    $yamaFlag      = Req::query('yama');

    $mylist        = Req::query('mylist');
    $bidMachineIds = array();

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('margin', 'bid', 'carryout', 'after'))) {
        $e = "この入札会は現在、入札会の期間ではありません\n";
        $e.= "下見期間 : " . date('Y/m/d', strtotime($bidOpen['preview_start_date'])) . " ～ " . date('m/d', strtotime($bidOpen['preview_end_date']));
    } else if (in_array($bidOpen['status'], array('after'))) {
        $e = $bidOpen['title'] . "は、終了しました";
    } else if (!empty($mylist)) {
        // マイリスト
        $_bid_mylist =& $_SESSION['bid_mylist'];
        if (empty($_bid_mylist)) { $e = "マイリストに、商品が登録されていません"; }

        foreach((array)$_bid_mylist as $key => $v) {
            if (is_int($key)) { $bidMachineIds[] = $key; }
        }

        if (empty($bidMachineIds)) { $e = "マイリストに、商品が登録されていません2"; }
    } else if (!empty($yamaFlag)) {
        // 一山(第7回テスト)
        $bidMachineIds = array(3117,3116,3110,3105,3104,3093,3090,3088,3085,3080,3079,3078,3077,3063,3061,3060,3055,3048,3040,3039,3038,3036,3035,3032,3030,3029,3027,3026,3025,3023,3020,3018,3014,3013,3012,3010,3009,3008,3006,3005,3004,3003,3002,3000,2999,2997,2996,2995,2994,2993,2992,2990,2989,2987,2986,2974,2972,2971,2946,2945,2944,2943,2942,2941,2940,2933,2923,2921,2920,2914,2884,2759,2746,2714,2674,2711,2710,2644,2643,2640,2639,2638,2635,2631,2629,2561,2601,2600,2599,2598,2597,2596,2595,2594,2593,2592,2591,2590,2589,2588,2587,2586,2585,2584,2583,2582,2581,2579,2578,2577,2576,2575,2574,2573,2571,2570,2569,2567,2565,2564,2563,2562,2508,2492,2491,2490,2489,2488,2709,2708,2707,2706,2705,2704,2703,2702,2642,2636,2699,2698,2697,2696,2694,2692,2691,2690,2689,2687,2685,2684,2682,2673,2672,2670,2667,2666,2665,2664,2663,2662,2661,2660,2659,2658,2657,2656,2655,2654,2653,2652,2651,2650,2649,2648,2645,2471);
    }

    if (!empty($e)) { throw new Exception($e); }

   //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    // $list_no = Req::query('no');
    $list_no = !empty($list_no) ? Req::query('no') : null;

    $q = array(
        'bid_open_id'    => $bidOpenId,
        'xl_genre_id'    => Req::query('x'),
        'large_genre_id' => Req::query('l'),
        // 'genre_id'    => Req::query('g'),
        'region'         => Req::query('r'),
        'state'          => Req::query('s'),

        'keyword'        => Req::query('k'),

        'id'             => $bidMachineIds,
        'list_no'        => Req::query('no', null),

        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
        'order'          => Req::query('order', 'reccomend'),
    );

    //// ジャンル・地域一覧を取得 ////
    $sq = array('bid_open_id' => $bidOpenId);
    $xlGenreList    = $bmModel->getXlGenreList($sq);
    $largeGenreList = $bmModel->getLargeGenreList($sq);
    $stateList      = $bmModel->getStateList($sq);
    $regionList     = $bmModel->getRegionList($sq);
    $countAll       = $bmModel->getCount($sq);

    //// 会場選択 ////
    $siteUrl  = '';
    $siteName = '';

    // マイリスト
    if (!empty($mylist)) {
        $siteName .= 'マイリスト';
        $siteUrl  .= '&mylist=1';
    } else {
        // 地域・都道府県
        if (!empty($q['region'])) {
            foreach ($regionList as $r) {
                if ($r['region'] == $q['region']) {
                    $siteName .= $r['region'] . '会場';
                    $siteUrl  .= '&r=' . $q['xl_genre_id'];
                    break;
                }
            }
        } else if (!empty($q['state'])) {
            foreach ($stateList as $s) {
                if ($s['state'] == $q['state']) {
                    $siteName .= $s['state'] . '会場';
                    $siteUrl  .= '&s=' . $q['state'];
                    break;
                }
            }
        } else {
            $siteName .= '全国';
        }
        $siteName .= '/';

        // ジャンル
        if (!empty($q['xl_genre_id'])) {
            foreach ($xlGenreList as $x) {
                if ($x['id'] == $q['xl_genre_id']) {
                    $siteName .= $x['xl_genre'];
                    $siteUrl  .= '&x=' . $q['xl_genre_id'];
                    break;
                }
            }
        } else if (!empty($q['large_genre_id'])) {
            foreach ($largeGenreList as $l) {
                if ($l['id'] == $q['large_genre_id']) {
                    $siteName .= $l['large_genre'];
                    $siteUrl  .= '&l=' . $q['large_genre_id'];
                    break;
                }
            }
        } else if (!empty($yamaFlag)) {
            $siteName .= '一山商品';
            $siteUrl  .= '&yama=1';
        } else {
            $siteName .= 'すべての商品';
        }
    }

    // 会場情報をセッションに格納
    $_SESSION['bid_siteName']  = $siteName;
    $_SESSION['bid_siteUrl']   = $siteUrl;
    $_SESSION['bid_siteQuery'] = $q; // 次へ・前へ用検索条件

    $bidMachineList = $bmModel->getList($q);
    $count          = $bmModel->getCount($q);

    // その他能力
    $mModel = new Machine();
    foreach($bidMachineList as $key => $m) {
        $oSpec = $mModel->makerOthers($m['spec_labels'], $m['others']);
        if (!empty($oSpec)) {
            $bidMachineList[$key]['spec'] = $oSpec . ' | ' . $m['spec'];
        }
    }

    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);

    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) { $cUri.= '?'; }

    // ロギング
    $lModel = new Actionlog();
    $lModel->set('machine', 'bid_list', $bidOpenId, $siteName);

    // トラッキングログ
    $machine_ids = [];
    foreach($bidMachineList as $key => $m) {
        $machine_ids[$key] = $m['id'];
    }
    $tlModel = new TrackingLog();
    $tlModel->set(array(
        "bid_open_id"     => $bidOpen["id"],
        "bid_machine_ids" => implode(",", $machine_ids)
    ));

    // ML結果
    $trackingUserTable = new TrackingUser();
    $trackingUser = $trackingUserTable->checkTrackingTag();

    if (!empty($trackingUser)) {
        $tbuTable     = new TrackingBidResult();
        $recommendIds = $tbuTable->getBidMachineIds($bidOpenId, 'user', $trackingUser['id']);
    } else {
        $recommendIds = array();
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'      => $siteName. 'の出品商品｜' . $bidOpen['title'],
        'pankuzuTitle'   => $siteName,
        'pankuzu'        => array('bid_door.php?o=' . $bidOpenId => $bidOpen['title']),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'bidMachineList' => $bidMachineList,
        'largeGenreList' => $largeGenreList,
        'regionList'     => $regionList,
        'stateList'      => $stateList,
        'xlGenreList'    => $xlGenreList,
        'count'          => $count,
        'countAll'       => $countAll,
        'pager'          => $pgn->getPages(),
        'cUri'           => $cUri,

        'siteName'       => $siteName,
        'siteUrl'        => $siteUrl,

        'recommendIds'   => $recommendIds,

        'q' => $q,
    ))->display("bid_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '商品リスト',
        'pankuzu'   => array(
            '/bid_door.php?o=' . $bidOpenId => $bidOpen['title'],
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
