<?php
/**
 * 企業間売り切りシステム特設ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2017/2/20
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');
    $result    = Req::query('result');

    if (empty($bidOpenId)) { throw new Exception('入札会情報が取得出来ません'); }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (strtotime($bidOpen["seri_start_date"]) > time()) {
        $e = '企業間売り切り開始前です';
    } else if (empty($company)) {
        $e = '会社情報が取得出来ませんでした';
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

        // 'limit'          => Req::query('limit', 50),
        // 'page'           => Req::query('page', 1),
        // 'order'          => Req::query('order'),
    );
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList($q);
    $count          = $bmModel->getCount($q);

    $sq = array('bid_open_id' => $bidOpenId, 'is_seri' => true);
    $xlGenreList    = $bmModel->getXlGenreList(array_merge($sq, array('region' => Req::query('r'))));
    $largeGenreList = $bmModel->getLargeGenreList(array_merge($sq, array('region' => Req::query('r'))));
    // $stateList      = $bmModel->getStateList($sq);
    $regionList     = $bmModel->getRegionList(array_merge($sq, array('large_genre_id' => Req::query('l'))));
    $countAll       = $bmModel->getCount($sq);

    //// 企業間売り切り入札取得 ////
    if (strtotime($bidOpen["seri_start_date"]) <= time()) {
        $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);

        foreach($bidMachineList as $key => $m) {
            $m["seri_result"] = false;
            if (!empty($resultListAsKey[$m['id']]['amount'])) {
                $r = $resultListAsKey[$m['id']];

                // 落札結果の格納
                $m['seri_count']      = $r['count'];
                $m['seri_company']    = $r['company'];
                $m['seri_company_id'] = $r['company_id'];
                $m['seri_amount']     = $r['amount'];

                if (($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) {
                    $m["seri_result"] = true;
                    $m['my_bidoff'] = $_user['company_id'] == $r['company_id'] ? true : false;
                }
            }
            $bidMachineList[$key] = $m;
        }
    }

    //// 落札済・未落札のフィルタリング ////
    if ($result == "mybid") {
        $sbModel = new SeriBid;
        $seriBidList = $sbModel->getList(array("bid_open_id" => $bidOpenId, "company_id" => $_user["company_id"]));
        $isBidListAsId = array();
        foreach ($seriBidList as $b) { $isBidListAsId[] = $b["bid_machine_id"]; }
    }

    if ($result != null) {
        $res = array();
        foreach($bidMachineList as $key => $m) {
            if ($result == "notbidoff" && $m["seri_result"] == false)     { $res[] = $m; }
            if ($result == "bidoff"    && $m["seri_result"] == true)      { $res[] = $m; }
            if ($result == "mybid" && in_array($m["id"], $isBidListAsId)) { $res[] = $m; }
        }
        $bidMachineList = $res;
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => $bidOpen['title'] . ' : 企業間売り切りシステム 特設ページ',
        // 'pageDescription' => '企業間売り切りシステム 特設ページ',

        'pankuzu'        => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'bidMachineList' => $bidMachineList,
        'rank'           => $company['rank'],
        'largeGenreList' => $largeGenreList,
        'xlGenreList'    => $xlGenreList,
        'regionList'     => $regionList,
        'count'          => $count,
        'countAll'       => $countAll,

        'result'         => $result,
        'q' => $q,

    ))->display("admin/seri_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '企業間売り切りシステム 特設ページ',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
