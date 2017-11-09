<?php
/**
 * 企業間売り切り落札・出品集計
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2017/03/06
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (empty($company)) {
        $e = '会社情報が取得出来ませんでした';
    } else if (strtotime($bidOpen["seri_end_date"]) > time()) {
        $e = '企業間売り切りが終了していません';
    }
    if (!empty($e)) { throw new Exception($e); }

    //// 企業間売り切り出品集計 ////
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id'], 'is_seri' => true));

    $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);
    $seriSum = 0;
    foreach($bidMachineList as $key => $m) {
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];

            // 落札結果の格納
            if (($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) {
                $seriSum += $r['amount'];
            }
        }
        $bidMachineList[$key] = $m;
    }

    ///// 企業間売り切り落札集計 ////
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'is_seri' => true));
    $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);
    $seriBidSum = 0;

    foreach($bidMachineList as $key => $m) {
        $m["seri_result"] = false;
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];

            if ((($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) && $_user['company_id'] == $r['company_id']) {
                $seriBidSum += $r['amount'];
            }
        }
    }
    $seriTax      = floor($seriBidSum * $bidOpen['tax'] / 100);
    $seriFinalSum = $seriBidSum + $seriTax;

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => $bidOpen['title'] . ' : 企業間売り切りシステム 集計一覧',
        // 'pageDescription' => '入札会の出品支払・落札請求の集計表です。',

        'pankuzu'     => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'  => $bidOpenId,
        'bidOpen'    => $bidOpen,

        'seriSum'    => $seriSum,
        'seriBidSum' => $seriBidSum,
        'seriTax'    => $seriTax,
        'seriFinalSum' => $seriFinalSum,
        'seriResult' => $seriSum - $seriFinalSum,
    ))->display("admin/seri_result.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '出品商品一覧',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
