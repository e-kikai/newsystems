<?php
/**
 * 企業間売り切り集計一覧ページ表示
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2017/03/13
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');
    $type      = Req::query('type');

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
    } else if (strtotime($bidOpen["seri_end_date"]) > time()) {
        $e = '企業間売り切りが終了していません';
    }
    if (!empty($e)) { throw new Exception($e); }

    //// 企業間売り切り出品集計 ////
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'is_seri' => true));

    $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);

    $resultList = array();

    $companyIdList = array();

    $seriSum = 0;
    foreach($bidMachineList as $key => $m) {
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];

            if (($m['seri_price'] <=  $r['amount']) || !empty($m['prompt'])) {

                // 落札結果の格納
                $m['seri_count']      = $r['count'];
                $m['seri_company']    = $r['company'];
                $m['seri_company_id'] = $r['company_id'];
                $m['seri_amount']     = $r['amount'];
                $m["seri_result"] = true;
                $seriSum += $m['seri_amount'];

                $companyIdList[] = $m['company_id'];
                $companyIdList[] = $m['seri_company_id'];

                $resultList[] = $m;
                $bidMachineList[$key] = $m;
            }
        }
        $bidMachineList[$key] = $m;
    }

    $companyIdList = array_unique($companyIdList);

    //// 会社ごとに集計 ////
    $sumList = array();
    $cModel = new Company();
    foreach($companyIdList as $companyId) {
        $sum = array(
            'company' => $cModel->get($companyId),

            'payment_list' => [],
            'billling_list' => [],

            'final_payment' => 0,

            'billing'       => 0,
            'billing_tax'   => 0,
            'final_billing' => 0,
        );

        foreach($resultList as $r) {
            if ($r['company_id'] == $companyId) {
                $sum['final_payment'] += $r['seri_amount'];

                $sum['payment_list'][] = $r;
            }

            if ($r['seri_company_id'] == $companyId) {
                $sum['billing'] += $r['seri_amount'];

                $sum['billing_list'][] = $r;
            }
        }

        // 消費税計算
        $sum['billing_tax']   = floor($sum['billing'] * $bidOpen['tax'] / 100);
        $sum['final_billing'] = $sum['billing'] + $sum['billing_tax'];

        $sum['company_id'] = $sum['company']['id'];
        $sum['be_company'] = $sum['company']['company'];

        // 小計・最終計算
        $sum['result_type'] = ($sum['final_billing'] > $sum['final_payment']) ? '請求' : '支払';
        if ($sum['final_billing'] > $sum['final_payment']) {
            $sum['result_type'] = '請求';
            $sum['result']      = $sum['final_billing'] - $sum['final_payment'];
        } else {
            $sum['result_type'] = '支払';
            $sum['result']      = $sum['final_payment'] - $sum['final_billing'];

            // 会社情報・出品登録(CSV用)
            if (!empty($sum['company']['bid_entries'])) {
                $sum['be_officer'] = $sum['company']['bid_entries']['officer'];
                $sum['be_bank']    = $sum['company']['bid_entries']['bank'];
                $sum['be_branch']  = $sum['company']['bid_entries']['branch'];

                if (!empty($sum['company']['bid_entries']['type'])) {
                    if      ($sum['company']['bid_entries']['type'] == 1) { $sum['be_type'] = '普通'; }
                    else if ($sum['company']['bid_entries']['type'] == 2) { $sum['be_type'] = '当座'; }
                    else    { $sum['be_type'] = ''; }
                } else {
                    $sum['be_type'] = '';
                }

                $sum['be_number']  = $sum['company']['bid_entries']['number'];
                $sum['be_name']    = $sum['company']['bid_entries']['name'];
                $sum['be_abbr']    = $sum['company']['bid_entries']['abbr'];
            }
        }

        $sumList[] = $sum;
    }

    if ($output == 'csv') {
        //// CSVに出力する場合 ////
        if ($type == 'sum') {
            $filename = $bidOpenId . '_sum.csv';
            $header   = array(
                'company_id' => '会社ID',
                'be_company' => '会社名',

                'billing' => '落札代金請求額',
                'billing_tax'    => '消費税(' . $bidOpen['tax'] . '%)',
                'final_billing'  => '差引落札請求額',

                'final_payment' => '出品支払額',

                'result_type' => '結果',
                'result'      => '金額',

                'be_officer' => '出品担当者',
                'be_bank'    => '銀行名',
                'be_branch'  => '支店名',
                'be_type'    => '種類',
                'be_number'  => '口座番号',
                'be_name'    => '口座名義',
                'be_abbr'    => '銀行振込略称',
            );
            B::downloadCsvFile($header, $sumList, $filename);
        // } else {
        //     $filename = $bidOpenId . '_result.csv';
        //     $header   = array(
        //         'id'          => '商品ID',
        //         'list_no'     => '出品番号',
        //         'name'        => '商品名',
        //         'xl_genre'    => '大ジャンル',
        //         'large_genre' => '中ジャンル',
        //         'genre'       => 'ジャンル',
        //         'maker'       => 'メーカー',
        //         'model'       => '型式',
        //         'year'        => '年式',
        //         'company'     => '出品会社',
        //         'seri_price'   => '最低入札金額',
        //         'seri_amount'  => '落札金額',
        //         'seri_company' => '落札会社',
        //         'seri_count'   => '入札数',
        //
        //         'payment'     => '支払金額',
        //         'billing'     => '請求金額',
        //     );
        //     B::downloadCsvFile($header, $bidMachineList, $filename);
        }
        exit;
    } else if ($output == 'pdf') {
        //// PDF出力準備 ////
        require_once('fpdf/MBfpdi.php'); //PDF
        $pdf = new Pdf();
        if ($type == 'receipt') {
            $filename = $bidOpenId . '_ryoshu.pdf';
            $res = $pdf->makeReceipt($bidOpen, $sumList, true);
        } else {
            $filename = $bidOpenId . '_shukei.pdf';
            $res = $pdf->makeSeriSum($bidOpen, $sumList);
        }

        //// ファイルのダウンロード処理 ////
        header("Content-type: application/pdf");
        header('Content-Disposition: inline; filename="' . $filename . '"');
        echo $res;
        exit;
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '企業間売り切り 落札・出品集計一覧',
        'pankuzu'    => array('/system/' => '管理者ページ'),
        'bidOpenId'  => $bidOpenId,
        'bidOpen'    => $bidOpen,
        // 'resultList' => $resultList,
        'sumList'    => $sumList,
        // 'bidMachineList' => $bidMachineList,
    ))->display("system/seri_result.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '企業間売り切り 落札・出品集計一覧',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
