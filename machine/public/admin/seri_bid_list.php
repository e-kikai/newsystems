<?php
/**
 * 企業間売り切り落札一覧
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

    ///// 企業間売り切り落札集計 ////
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'is_seri' => true));
    $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);
    $seriBidSum = 0;

    $seriBidList = array();

    foreach($bidMachineList as $key => $m) {
        $m["seri_result"] = false;
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];

            if ((($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) && $_user['company_id'] == $r['company_id']) {
                // 落札結果の格納
                $m['seri_count']      = $r['count'];
                $m['seri_company']    = $r['company'];
                $m['seri_company_id'] = $r['company_id'];
                $m['seri_amount']     = $r['amount'];
                $m['res']             = true;
                $seriBidList[] = $m;
                $seriBidSum += $r['amount'];
            }
        }
    }
    $seriTax      = floor($seriBidSum * $bidOpen['tax'] / 100);
    $seriFinalSum = $seriBidSum + $seriTax;

    //// CSVに出力する場合 ////
    if ($output == 'csv') {
        $filename = $bidOpenId . '_zaiko_bid_bid_list.csv';
        $header   = array(
            'id'          => '商品ID',
            'list_no'     => '出品番号',
            'name'        => '商品名',
            'maker'       => 'メーカー',
            'model'       => '型式',
            'year'        => '年式',
            'company'     => '出品会社',
            'seri_amount' => '落札金額',
        );
        B::downloadCsvFile($header, $seriBidList, $filename);
        exit;
    } else if ($output == 'pdf') {
        //// PDF出力準備 ////
        $filename = $bidOpenId . '_zaiko_hikitori.pdf';

        require_once('fpdf/MBfpdi.php'); //PDF
        $pdf = new Pdf();
        $res = $pdf->makeSashizu($bidOpen['title'], $company['company'], $seriBidList);

        //// ファイルのダウンロード処理 ////
        header("Content-type: application/pdf");
        header('Content-Disposition: inline; filename="' . $filename . '"');
        echo $res;
        exit;
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'    => $bidOpen['title'] . ' : 企業間売り切りシステム 落札商品 個別計算表',
        // 'pageDescription' => '入札会の出品支払・落札請求の集計表です。',

        'pankuzu'      => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'    => $bidOpenId,
        'bidOpen'      => $bidOpen,

        'seriBidList'  => $seriBidList,

        'seriBidSum'   => $seriBidSum,
        'seriTax'      => $seriTax,
        'seriFinalSum' => $seriFinalSum,
    ))->display("admin/seri_bid_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '落札商品 個別計算表',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
