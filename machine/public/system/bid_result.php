<?php
/**
 * 落札結果ページ表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/05/08
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
    }
    if (!empty($e)) { throw new Exception($e); }
    
    //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId,));
    
    //// 落札結果を取得 ////
    $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

    $resultList = array();
    
    $companyIdList = array();
    
    // 落札結果集計
    foreach($bidMachineList as $key => $m) {
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];
            
            // 落札結果の格納(出品・落札同時計算)
            $m['bid_machine_id'] = $m['id'];
            $m['res_company']    = $r['company'];
            $m['res_company_id'] = $r['company_id'];
            $m['res_amount']     = $r['amount'];
            $m['count']      = $r['count'];
            $m['same_count'] = $r['same_count'];
            
            $m['charge'] = $r['charge'];
            
            $companyIdList[] = $m['company_id'];
            $companyIdList[] = $m['res_company_id'];
                            
            // デメ半
            $m['demeh'] = ($r['amount'] - $m['min_price']) * $bidOpen['deme']/100;
            
            // 事務局手数料・落札者手数料
            $m += $bmModel->makeFee($m['min_price']);
            
            // 支払額
            $m['payment']       = $m['min_price'] + $m['demeh'] - $m['jFee'] - $m['rFee'];
            
            // 請求額
            $m['billing']       = $m['res_amount'] - $m['demeh'] - $m['rFee'];
            
            // 落札されたもののみリストに追加
            $resultList[] = $m;
            $bidMachineList[$key] = $m;
        }
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
            
            'payment_amount' => 0,
            'payment_demeh' => 0,
            'payment_jFee'  => 0,
            'payment_rFee'  => 0,
            'payment'       => 0,
            'payment_tax'   => 0,
            'final_payment' => 0,
            
            'billing_amount' => 0,
            'billing_demeh' => 0,
            'billing_rFee'  => 0,
            'billing'       => 0,
            'billing_tax'   => 0,
            'final_billing' => 0,
        );
        
        foreach($resultList as $r) {
            if ($r['company_id'] == $companyId) {
                $sum['payment_amount'] += $r['res_amount'];
                $sum['payment_demeh'] += $r['demeh'];
                $sum['payment_jFee']  += $r['jFee'];
                $sum['payment_rFee']  += $r['rFee'];
                $sum['payment']       += $r['payment'];
                
                $sum['payment_list'][] = $r;
            } 
            
            if ($r['res_company_id'] == $companyId) {
                $sum['billing_amount'] += $r['res_amount'];
                $sum['billing_demeh'] += $r['demeh'];
                $sum['billing_rFee']  += $r['rFee'];
                $sum['billing']       += $r['billing'];
                
                $sum['billing_list'][] = $r;
            }
        }
        
        // 消費税計算
        $sum['payment_tax']   = floor($sum['payment'] * $bidOpen['tax'] / 100);
        $sum['final_payment'] = $sum['payment'] + $sum['payment_tax'];
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
                
                'billing_amount' => '落札代金請求額',
                'billing_demeh'  => 'デメ半',
                'billing_rFee'   => '貴社受取手数料',
                'billing'        => '差引',
                'billing_tax'    => '消費税(' . $bidOpen['tax'] . '%)',
                'final_billing'  => '差引落札請求額',
                
                'payment_amount' => '出品支払額',
                'payment_demeh'  => 'デメ半',
                'payment_jFee'   => '事務局手数料',
                'payment_rFee'   => '販売手数料',
                'payment'        => '差引',
                'payment_tax'    => '消費税(' . $bidOpen['tax'] . '%)',
                'final_payment'  => '差引出品支払額',
                
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
        } else {
            $filename = $bidOpenId . '_result.csv';
            $header   = array(
                'id'          => '商品ID',
                'list_no'     => '出品番号',
                'name'        => '商品名',
                'xl_genre'    => '大ジャンル',
                'large_genre' => '中ジャンル',
                'genre'       => 'ジャンル',
                'maker'       => 'メーカー',
                'model'       => '型式',
                'year'        => '年式',
                'company'     => '出品会社',
                'min_price'   => '最低入札金額',
                'res_amount'  => '落札金額',
                'res_company' => '落札会社',
                'count'       => '入札数',
                'same_count'  => '同額札',
                
                'demeh'       => 'デメ半(' . $bidOpen['deme'] . '%)',
                'rFee'        => '落札会社手数料',
                'rPer'        => '手数料率(%)',
                'jFee'        => '事務局手数料',
                'jPer'        => '手数料率(%)',
                
                'payment'     => '支払金額',
                'billing'     => '請求金額',
            );
            B::downloadCsvFile($header, $bidMachineList, $filename);
        }
        exit;
    } else if ($output == 'pdf') {
        //// PDF出力準備 ////
        require_once('fpdf/MBfpdi.php'); //PDF
        $pdf = new Pdf();
        if ($type == 'receipt') {
            $filename = $bidOpenId . '_ryoshu.pdf';
            $res = $pdf->makeReceipt($bidOpen, $sumList);
        } else {
            $filename = $bidOpenId . '_shukei.pdf';
            $res = $pdf->makeSum($bidOpen, $sumList);
        }
        
        //// ファイルのダウンロード処理 ////
        header("Content-type: application/pdf");
        header('Content-Disposition: inline; filename="' . $filename . '"');
        echo $res;
        exit;
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '落札・出品集計一覧',
        'pankuzu'    => array('/system/' => '管理者ページ'),
        'bidOpenId'  => $bidOpenId,
        'bidOpen'    => $bidOpen,
        'resultList' => $resultList,
        'sumList'    => $sumList,
        'bidMachineList' => $bidMachineList,
    ))->display("system/bid_result.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '落札結果',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

