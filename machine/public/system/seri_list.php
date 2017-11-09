<?php
/**
 * 企業間売り切りシステム特設ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2017/3/23
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');
    // $result    = Req::query('result');
    $type      = Req::query('type');

    if (empty($bidOpenId)) { throw new Exception('入札会情報が取得出来ません'); }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    }
    if (!empty($e)) { throw new Exception($e); }

    //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    // $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id']));

    //// 出品商品情報一覧を取得 ////
    $q = array(
        'bid_open_id'    => $bidOpenId,
        'xl_genre_id'    => Req::query('x'),
        'large_genre_id' => Req::query('l'),
        // 'genre_id'      => Req::query('g'),
        'region'         => Req::query('r'),
        'state'          => Req::query('s'),
        'keyword'        => Req::query('k'),
        'list_no'        => Req::query('no'),

        'is_seri'        => true,

        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
        'order'          => Req::query('order'),
    );
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList($q);
    $count          = $bmModel->getCount($q);

    $sq = array('bid_open_id' => $bidOpenId, 'is_seri' => true);
    // $xlGenreList    = $bmModel->getXlGenreList($sq);
    // $largeGenreList = $bmModel->getLargeGenreList($sq);
    // $stateList      = $bmModel->getStateList($sq);
    // $regionList     = $bmModel->getRegionList($sq);
    // $countAll       = $bmModel->getCount($sq);

    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);
    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) { $cUri.= '?'; }

    //// 企業間売り切り入札取得 ////
    $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);

    foreach($bidMachineList as $key => $m) {
        $m["seri_result"] = false;
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];

            // 落札結果の格納
            $m['seri_count']      = $r['count'];
            $m['seri_company']    = preg_replace('/(株式|有限|合.)会社/', '', $r['company']);
            $m['seri_company_id'] = $r['company_id'];
            $m['seri_amount']     = $r['amount'];

            if (($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) {
                $m["seri_result"] = true;
            }
        }
        $bidMachineList[$key] = $m;
    }


    // 集計取得
    $AllbidMachineList = $bmModel->getList($sq);
    $sums = array(
        'count'        => count($AllbidMachineList),
        'min_price'    => 0,
        'result_count' => 0,
        'result_price' => 0,

        'company_num'  => 0,
    );
    $cTemp = array();

    foreach($AllbidMachineList as $key => $m) {
        $m["seri_result"] = false;
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];

            // 落札集計結果の格納
            if (($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) {
                $sums['result_count'] ++;
                $sums['result_price'] += $r['amount'];
            }
        }

        $sums['min_price'] += $m['seri_price'];
        $cTemp[] = $m['company_id'];
    }
    $sums['company_num'] = count(array_unique($cTemp));


    //// 落札済・未落札のフィルタリング ////
    // if ($result != null) {
    //     $res = array();
    //     foreach($bidMachineList as $key => $m) {
    //         if ($result == "notbidoff" && $m["seri_result"] == false)     { $res[] = $m; }
    //         if ($result == "bidoff"    && $m["seri_result"] == true)      { $res[] = $m; }
    //         if ($result == "mybid" && in_array($m["id"], $isBidListAsId)) { $res[] = $m; }
    //     }
    //     $bidMachineList = $res;
    // }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '企業間売り切り 出品商品一覧',
        'pankuzu'    => array('/system/' => '管理者ページ'),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'bidMachineList' => $bidMachineList,
        // 'largeGenreList' => $largeGenreList,
        // 'xlGenreList'    => $xlGenreList,
        'count'          => $count,
        // 'countAll'       => $countAll,
        'pager'          => $pgn->getPages(),
        'cUri'           => $cUri,

        // 'result'         => $result,
        'q' => $q,

        'sums'  => $sums,
    ))->display("system/seri_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'  => '企業間売り切り 出品商品一覧',
        'pankuzu'    => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
