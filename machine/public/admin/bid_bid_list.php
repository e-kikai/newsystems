<?php

/**
 * 入札履歴
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/13
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('member');

    /// 変数を取得 ///
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    /// 入札会情報を取得 ///
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    /// 会社情報を取得 ///
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('bid', 'carryout', 'after'))) {
        $e = $bidOpen['title'] . "は現在、入札会の期間ではありません\n";
        $e .= "入札期間 : " . date('Y/m/d H:i', strtotime($bidOpen['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['bid_end_date']));
    }
    if (!empty($e)) {
        throw new Exception($e);
    }

    $bbModel = new BidBid();

    if (in_array($bidOpen['status'], array('carryout', 'after'))) {
        /// 落札結果を取得 ///
        /// 入札情報一覧を取得 ///
        $bidBidList = $bbModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id']));

        $bmModel = new BidMachine();
        $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

        $sum = 0;
        foreach ($bidBidList as $key => $b) {
            if (!empty($resultListAsKey[$b['bid_machine_id']]['amount'])) {
                $r = $resultListAsKey[$b['bid_machine_id']];

                // 落札結果の格納
                // $b['res_company']    = $r['company'];
                // $b['res_company_id'] = $r['company_id'];
                $b['res_amount'] = $r['amount'];
                $b['same_count'] = $r['same_count'];
                $b['res']        = ($r['bid_id'] == $b['id']) ? true : false;

                if ($b['res']) {
                    // デメ半
                    $b['demeh'] = ($r['amount'] - $b['min_price']) * $bidOpen['deme'] / 100;

                    // 落札者手数料
                    $b += $bmModel->makeFee($b['min_price']);

                    // 請求額
                    $b['billing'] = $r['amount'] - $b['demeh'] - $b['rFee'];
                    $sum += $b['billing'];
                }

                // 落札結果・同額札(CSV用)
                $b['csv_res']  = $b['res'] == true ? '◯' : '×';
                $b['csv_same'] = $b['same_count'] > 1 ? '有' : '';

                $bidBidList[$key] = $b;
            }
        }

        /// 消費税の計算 ///
        $tax      = floor($sum * $bidOpen['tax'] / 100);
        $finalSum = $sum + $tax;

        $_smarty->assign(array(
            'pageTitle'       => $bidOpen['title'] . ' : 落札商品 個別計算表',
            'pageDescription' => '入札会の落札結果個別計算表です。',

            'sum'      => $sum,
            'tax'      => $tax,
            'finalSum' => $finalSum,
        ));
    } else {
        /// 入札履歴を表示 ///
        /// 入札情報一覧を取得(取消済みのものを含) ///
        $bidBidList = $bbModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id'], 'delete' => true));

        $_smarty->assign(array(
            'pageTitle'        => $bidOpen['title'] . ' : 入札履歴',
            'pageDescription'  => '入札会の入札履歴です。入札の取り消しを行えます',
        ));
    }

    /// CSVに出力する場合 ///
    if ($output == 'csv') {
        if (!in_array($bidOpen['status'], array('carryout', 'after'))) {
            throw new Exception($bidOpen['title'] . 'は現在、落札商品個別計算表の出力は行えません');
        }

        $filename = $bidOpenId . '_bid_bid_list.csv';
        $header   = array(
            'id'         => '商品ID',
            'list_no'    => '出品番号',
            'name'       => '商品名',
            'maker'      => 'メーカー',
            'model'      => '型式',
            'year'       => '年式',
            'company'    => '出品会社',
            'min_price'  => '最低入札金額',
            'amount'     => '入札金額',
            'comment'    => '備考欄',
            'charge'     => '担当者',
            'res_amount' => '落札金額',
            'csv_same'   => '同額札',
            'csv_res'    => '落札結果',
            'demeh'      => 'デメ半(' . $bidOpen['deme'] . '%)',
            'rFee'       => '落札会社手数料',
            'rPer'       => '手数料率(%)',
            'billing'    => '請求金額',
        );
        B::downloadCsvFile($header, $bidBidList, $filename);
        exit;
    } else if ($output == 'pdf') {
        // 引取指図書フラグがfalseのときには出力しない

        if (!in_array($bidOpen['status'], array('carryout', 'after'))) {
            throw new Exception($bidOpen['title'] . 'は現在、引取指図書の出力は行えません');
        } else if (empty($bidOpen['sashizu_flag'])) {
            throw new Exception($bidOpen['title'] . 'は現在、まだ引取指図書の出力は行えません');
        }

        /// PDF出力準備 ///
        $filename = $bidOpenId . '_hikitori.pdf';

        require_once('fpdf/MBfpdi.php'); //PDF
        $pdf = new Pdf();
        $res = $pdf->makeSashizu($bidOpen['title'], $company['company'], $bidBidList);

        /// ファイルのダウンロード処理 ///
        header("Content-type: application/pdf");
        header('Content-Disposition: inline; filename="' . $filename . '"');
        echo $res;
        exit;
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'  => $bidOpenId,
        'bidOpen'    => $bidOpen,
        'bidBidList' => $bidBidList,
    ))->display("admin/bid_bid_list.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => '入札履歴',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
