<?php

/**
 * ユーザ入札一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/28
 */

require_once '../../../lib-machine.php';

/// 認証処理 ///
Auth::isAuth('system');

/// 変数を取得 ///
$bid_open_id = Req::query('o');
$output      = Req::query('output');

if (empty($bid_open_id)) throw new Exception('入札会情報が取得出来ません');

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

$my_bid_bid_model = new MyBidBid();

// 入札一覧の取得
$select = $my_bid_bid_model->my_select()->reset('where')
    ->join("bid_machines", "bid_machines.id = my_bid_bids.bid_machine_id",  ["list_no", "name", "maker", "model", "min_price", "top_img", "company_id"])
    ->join("my_users", "my_users.id = my_bid_bids.my_user_id", ["uniq_account", "user_name" => "name", "user_company" => "company"])
    ->join("companies", "companies.id = bid_machines.company_id", ["company"])
    ->where("bid_machines.bid_open_id = ?", $bid_open_id);

$my_bid_bids = $bid_open_model->fetchAll($select)->toArray();

/// 落札結果を取得 ///
if (in_array($bid_open['status'], array('carryout', 'after'))) {
    $ids = $my_bid_bid_model->bid_machines2ids($my_bid_bids, "bid_machine_id");
    $bids_count  = $my_bid_bid_model->count_by_bid_machine_id($ids);
    $bids_result = $my_bid_bid_model->results_by_bid_machine_id($ids);

    $_smarty->assign(array(
        "bids_count"  => $bids_count,
        "bids_result" => $bids_result,
    ));
}

if ($output == 'csv') { // CSV
    $body = [];
    foreach ($my_bid_bids as $bb) {
        if (!empty($bids_count[$bb["bid_machine_id"]])) {
            $bb["bid_count"] = $bids_count[$bb["bid_machine_id"]];
        }
        if (!empty($bids_result[$bb["bid_machine_id"]])) {
            $bb["res_amount"]     = $bids_result[$bb["bid_machine_id"]]["amount"];
            $bb["same_count"]     = $bids_result[$bb["bid_machine_id"]]["same_count"];
            $bb["s_user_id"]      = $bids_result[$bb["bid_machine_id"]]["my_user_id"];
            $bb["s_user_name"]    = $bids_result[$bb["bid_machine_id"]]["name"];
            $bb["s_user_company"] = $bids_result[$bb["bid_machine_id"]]["company"];
        }

        $body[] = $bb;
    }

    $header   = array(
        'id'           => 'ID',
        'my_user_id'   => 'ユーザID',
        'user_company' => 'ユーザ会社名',
        'user_name'    => 'ユーザ氏名',
        'amount'       => '入札金額',
        'created_at'   => '入札日時',
        'deleted_at'   => '取消日時',
        'list_no'      => '出品番号',
        'name'         => '商品名',
        'maker'        => 'メーカー',
        'model'        => '型式',
        'company'      => '出品会社',
        'min_price'    => '最低入札金額',
        'bid_count'    => '入札数',
        's_user_id'      => '落札ユーザID',
        's_user_company' => '落札ユーザ会社名',
        's_user_name'    => '落札ユーザ氏名',
        'res_amount'     => '落札金額',
        'same_count'     => '同額札',
    );
    $filename = "{$bid_open_id}_my_bid_bids.csv";
    B::downloadCsvFile($header, $body, $filename);
} else {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => "{$bid_open["title"]} 入札履歴一覧",
        'pankuzu'          => array(
            '/system/' => '管理者ページ',
            '/system/bid_open_list.php' => '入札会開催一覧',
        ),

        'bid_open'    => $bid_open,
        'my_bid_bids' => $my_bid_bids,
    ))->display('system/my_bid_bids/index.tpl');
}
