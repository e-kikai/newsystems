<?php

/**
 * 入札会出品商品一覧
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/05/13
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
    if (empty($company)) {
        throw new Exception('会社情報が取得できませんでした');
    }

    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('entry', 'margin', 'bid', 'carryout', 'after'))) {
        $e = $bidOpen['title'] . " は、現在「出品期間」ではありません\n";
        $e .= "出品期間 : " . date('Y/m/d H:i', strtotime($bidOpen['entry_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['entry_end_date']));
    } else if (empty($company)) {
        $e = '会社情報が取得出来ませんでした';
    }
    if (!empty($e)) {
        throw new Exception($e);
    }

    /// 商品出品登録チェック ///
    if (empty($company['bid_entries'])) {
        header('Location: /admin/bid_entry_form.php?e=1');
        exit;
    }

    /// 出品商品情報一覧を取得 ///
    $bmModel = new BidMachine();
    $bidMachineList = $bmModel->getList(array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id']));

    // 新 : 入札件数集計
    $my_bid_bid_model = new MyBidBid();
    $ids = $my_bid_bid_model->bid_machines2ids($bidMachineList);
    $bids_count = $my_bid_bid_model->count_by_bid_machine_id($ids);

    // 新 : ウォッチ数取得
    $my_bid_watch_model = new MyBidWatch();
    $watches_count = $my_bid_watch_model->count_by_bid_machine_id($ids);

    /// 落札結果を取得 ///
    if (in_array($bidOpen['status'], array('carryout', 'after'))) {

        // 新 : ユーザ入札対応
        if ($bidOpen["user_bid_date"] < BID_USER_START_DATE) {
            $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

            $sum = 0;
            foreach ($bidMachineList as $key => $m) {
                if (!empty($resultListAsKey[$m['id']]['amount'])) {
                    $r = $resultListAsKey[$m['id']];

                    // 落札結果の格納
                    $m['res_company']    = $r['company'];
                    $m['res_company_id'] = $r['company_id'];
                    $m['res_amount']     = $r['amount'];

                    // デメ半
                    $m['demeh'] = ($m['res_amount'] - $m['min_price']) * $bidOpen['deme'] / 100;

                    // 事務局手数料・落札者手数料
                    $m += $bmModel->makeFee($m['min_price']);

                    // 支払額
                    $m['payment'] = $m['min_price'] + $m['demeh'] - $m['jFee'] - $m['rFee'];
                    $sum += $m['payment'];
                }
                $bidMachineList[$key] = $m;
            }

            /// 消費税の計算 ///
            $tax      = floor($sum * $bidOpen['tax'] / 100);
            $finalSum = $sum + $tax;


            $_smarty->assign(array(
                'pageTitle'       => $bidOpen['title'] . ' : 出品商品 個別計算表',
                'pageDescription' => "入札会出品商品の落札結果個別計算表です。落札されなかった商品は、「在庫に登録」から中古機械在庫に再利用できます。",

                'sum'      => $sum,
                'tax'      => $tax,
                'finalSum' => $finalSum,
            ));
        } else {
            $ids = $my_bid_bid_model->bid_machines2ids($bidMachineList);
            $bids_count  = $my_bid_bid_model->count_by_bid_machine_id($ids);
            $bids_result = $my_bid_bid_model->results_by_bid_machine_id($ids);

            $_smarty->assign(array(
                'pageTitle'       => $bidOpen['title'] . ' : 出品商品 個別計算表',
                'pageDescription' => "入札会出品商品の落札結果個別計算表です。落札されなかった商品は、「在庫に登録」から中古機械在庫に再利用できます。",

                "bids_count"      => $bids_count,
                "bids_result"     => $bids_result,
            ));
        }
    } else {
        $_smarty->assign(array(
            'pageTitle'       => $bidOpen['title'] . ' : 出品商品一覧',
            'pageDescription' => '自社の出品商品一覧',
        ));
    }

    if ($output == 'csv') {
        /// CSVに出力する ///
        if (in_array($bidOpen['status'], array('carryout', 'after'))) {
            $filename = $bidOpenId . '_bid_machine_list_02.csv';
            $header   = array(
                'id'          => '商品ID',
                'list_no'     => '出品番号',
                'name'        => '商品名',
                'maker'       => 'メーカー',
                'model'       => '型式',
                'year'        => '年式',
                'min_price'   => '最低入札金額',
                'res_company' => '落札会社',
                'res_amount'  => '落札金額',
                'demeh'       => 'デメ半(' . $bidOpen['deme'] . '%)',
                'rFee'        => '落札会社手数料',
                'rPer'        => '手数料率(%)',
                'jFee'        => '事務局手数料',
                'jPer'        => '手数料率(%)',
                'payment'     => '支払金額',
            );
            B::downloadCsvFile($header, $bidMachineList, $filename);
            exit;
        } else {
            $filename = $bidOpenId . '_bid_machine_list.csv';
            $header   = array(
                'id'        => '商品ID',
                'list_no'   => '出品番号',
                'name'      => '商品名',
                'maker'     => 'メーカー',
                'model'     => '型式',
                'year'      => '年式',
                'addr1'     => '都道府県',
                'location'  => '在庫場所',
                'min_price' => '最低入札金額',
            );
        }
        B::downloadCsvFile($header, $bidMachineList, $filename);
        exit;
    } else if ($output == 'pdf') {
        /// PDF出力準備 ///
        $filename = $bidOpenId . '_sagefuda.pdf';

        require_once('fpdf/MBfpdi.php'); //PDF
        $pdf = new Pdf();
        $res = $pdf->makeSagefuda($bidOpen['title'], $bidMachineList);

        /// ファイルのダウンロード処理 ///
        header("Content-type: application/pdf");
        header('Content-Disposition: inline; filename="' . $filename . '"');
        echo $res;
        exit;
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pankuzu'        => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'bidMachineList' => $bidMachineList,
        'rank'           => $company['rank'],

        "watches_count"  => $watches_count,
        "bids_count"     => $bids_count,
    ))->display("admin/bid_machine_list.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => '出品商品一覧',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
