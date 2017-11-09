<?php
/**
 * 落札・出品集計
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/31
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
    } else if (!in_array($bidOpen['status'], array('carryout', 'after'))) {
        $e = $bidOpen['title'] . " は、現在「搬出期間」ではありません\n";
        $e.= "搬出期間 : " . date('Y/m/d H:i', strtotime($bidOpen['carryout_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['carryout_end_date']));
    }
    if (!empty($e)) { throw new Exception($e); }
    
    
    
    //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id']));
    
    //// 入札情報一覧を取得 ////
    $bbModel = new BidBid();
    $bidBidList = $bbModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id']));
    
    //// 落札結果を取得 ////
    $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

    $paymentSum = 0;
    $billingSum = 0;
    $resultList = array();
    
    // 出品集計
    $sum = array(
        'payment_list'  => [],
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
    
    foreach($bidMachineList as $key => $m) {
        if (!empty($resultListAsKey[$m['id']]['amount'])) {
            $r = $resultListAsKey[$m['id']];
            
            $m['status'] = 'shuppin';
            
            // 落札結果の格納
            $m['bid_machine_id'] = $m['id'];
            $m['res_company']    = $r['company'];
            $m['res_company_id'] = $r['company_id'];
            $m['res_amount']     = $r['amount'];
            // $m['same_count'] = $r['same_count'];
                            
            // デメ半
            $m['payment_demeh'] = ($r['amount'] - $m['min_price']) * $bidOpen['deme']/100;
            
            // 事務局手数料・落札者手数料
            $temp = $bmModel->makeFee($m['min_price']);
            $m['payment_jFee'] = $temp['jFee'];
            $m['payment_rFee'] = $temp['rFee'];
            $m['payment_jPer'] = $temp['jPer'];
            $m['payment_rPer'] = $temp['rPer'];
            
            // 支払額
            $m['payment'] = $m['min_price'] + $m['payment_demeh'] - $m['payment_jFee'] - $m['payment_rFee'];
            
            // 落札されたもののみリストに追加
            $sum['payment_amount'] += $r['amount'];
            $sum['payment_demeh']  += $m['payment_demeh'];
            $sum['payment_jFee']   += $m['payment_jFee'];
            $sum['payment_rFee']   += $m['payment_rFee'];
            $sum['payment']        += $m['payment'];
            
            $sum['payment_list'][] = $m;
        }
    }
    
    // 落札集計
    foreach($bidBidList as $key => $b) {
        if (!empty($resultListAsKey[$b['bid_machine_id']]['amount'])) {
            $r = $resultListAsKey[$b['bid_machine_id']];
            
            // 落札結果のチェック
            if ($r['bid_id'] == $b['id']) {
                $b['status'] = 'rakusatsu';
            
                // 落札結果の格納
                $b['res_amount'] = $r['amount'];
                // $b['same_count'] = $r['same_count'];

                // デメ半
                $b['billing_demeh'] = ($r['amount'] - $b['min_price']) * $bidOpen['deme']/100;
                
                // 落札者手数料
                $temp = $bmModel->makeFee($b['min_price']);
                $b['billing_rFee'] = $temp['rFee'];
                $b['billing_rPer'] = $temp['rPer'];
                
                // 請求額
                $b['billing'] = $r['amount'] - $b['billing_demeh'] - $b['billing_rFee'];
                
                // 落札されたもののみリストに追加
                $sum['billing_amount'] += $b['res_amount'];
                $sum['billing_demeh']  += $b['billing_demeh'];
                $sum['billing_rFee']   += $b['billing_rFee'];
                $sum['billing']        += $b['billing'];
                
                $sum['billing_list'][] = $b;
            }
        }
    }
    
    // 消費税計算
    $sum['payment_tax']   = floor($sum['payment'] * $bidOpen['tax'] / 100);
    $sum['final_payment'] = $sum['payment'] + $sum['payment_tax'];
    $sum['billing_tax']   = floor($sum['billing'] * $bidOpen['tax'] / 100);
    $sum['final_billing'] = $sum['billing'] + $sum['billing_tax'];
            
    
    //// CSVに出力する場合 ////
    /*
    if ($output == 'csv') {
        $filename = $company['company'] .'_'. $bidOpen['title'] . '落札・出品集計.csv';
        $header   = array(
            'id'   => '商品ID',
            'name' => '商品名',
            'maker' => 'メーカー',
            'model' => '型式',
            'year' => '年式',
            'company' => '出品会社',
            'min_price' => '最低入札金額',
            'amount' => '入札金額',
            'res_amount' => '落札金額',
            
            'res_company' => '落札会社',
            'payment_demeh' => 'デメ半(' . $bidOpen['deme'] . '%)',
            'payment_rFee' => '落札会社手数料',
            'payment_rPer' => '手数料率(%)',
            'payment_jFee' => '事務局手数料',
            'payment_jPer' => '手数料率(%)',
            'payment' => '支払金額',
            'payment_tax' => '消費税(' . $bidOpen['tax'] . '%)',
            
            'billing_demeh' => 'デメ半(' . $bidOpen['deme'] . '%)',
            'billing_rFee' => '落札会社手数料',
            'billing_rPer' => '手数料率(%)',
            'billing' => '請求金額',
            'billing_tax' => '消費税(' . $bidOpen['tax'] . '%)',
            
            'final_payment' => '差引支払金額',
            'final_billing' => '差引請求金額',
        );
        B::downloadCsvFile($header, $resultList, $filename);
        exit;
    }
    */
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => $bidOpen['title'] . ' : 落札・出品集計表',
        'pageDescription' => '入札会の出品支払・落札請求の集計表です。',
        
        'sum' => $sum,
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'resultList'     => $resultList,
    ))->display("admin/bid_result.tpl");
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
