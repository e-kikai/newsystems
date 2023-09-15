<?php

/**
 * ユーザごとの集計一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/12
 */

require_once '../../../lib-machine.php';
/// 認証 ///
Auth::isAuth('system');

/// 変数を取得 ///
$bid_open_id = Req::query('o');
$output      = Req::query('output');

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

// 出品期間の終了チェック
$my_bid_bid_model = new MyBidBid();
$e = $my_bid_bid_model->check_end_errors($bid_open);
if (!empty($e)) throw new Exception($e);

$results = [];

$bid_machine_model = new BidMachine();
// $bm_select = $bid_machine_model->select()->setIntegrityCheck(false)
$bm_select = $_db->select()
    ->from("bid_machines as bm", null)
    ->where("bm.bid_open_id = ?", $bid_open_id)
    ->where("bm.deleted_at IS NULL");

/// 詳細アクセス ///
$watches_select = clone $bm_select;
$watches_select
    ->join(["bdl" => "bid_detail_logs"], "bdl.bid_machine_id = bm.id", "count(*) as c")
    ->joinRight(["mu" => "my_users"], "bdl.my_user_id = mu.id", ["mu.id", "company", "mu.name", "addr_1"])
    ->group(["mu.id", "company", "mu.name", "addr_1"]);

$res = $_db->fetchAll($watches_select);

$ids = array_column($res, "id");

$results["会社名"]      = array_column($res, "company", "id");
$results["氏名"]        = array_column($res, "name", "id");
$results["都道府県"]    = array_column($res, "addr_1", "id");
$results["詳細アクセス"] = array_column($res, "c", "id");

// echo $select;
// var_export($res);
// exit;

/// ウォッチ数 ///
$watches_select = clone $bm_select;
$watches_select->join(["mbw" => "my_bid_watches"], "mbw.bid_machine_id = bm.id", ["id" => "mbw.my_user_id", "c" => "count(*)"])
    ->columns("count(mbw.deleted_at) as del")
    ->group("mbw.my_user_id");

$res = $_db->fetchAll($watches_select);

$results["ウォッチ"]  =  array_column($res, "c", "id");
$results["うち、削除"] = array_column($res, "del", "id");

// echo $watches_select;
// var_export($res);
// exit;

/// 入札数 ///
$bids_select = clone $bm_select;
$bids_select->join(["mbb" => "my_bid_bids"], "mbb.bid_machine_id = bm.id", ["id" => "mbb.my_user_id", "c" => "count(*)"])
    ->where("mbb.deleted_at IS NULL")
    ->columns("count(DISTINCT mbb.bid_machine_id) as success")
    ->group("mbb.my_user_id");

$res = $_db->fetchAll($bids_select);

$results["入札数"] = array_column($res, "c", "id");
$results["落札数"] = array_column($res, "success", "id");

/// 落札金額 ///
// $sub = $bid_machine_model->select()->setIntegrityCheck(false)
$sub = $_db->select()
    ->from(["mbb2" => "my_bid_bids"], ["mbb2.bid_machine_id", "id" => "mbb2.my_user_id", "result_price" => "max(mbb2.amount)"])
    ->where("mbb2.deleted_at IS NULL")
    ->group(["mbb2.bid_machine_id", "mbb2.my_user_id"]);

$result_select = clone $bm_select;
$result_select->join(["sub" => $sub], "sub.bid_machine_id = bm.id", ["sub.id", "sum(sub.result_price) as sum"])
    ->group("sub.id");

$res = $_db->fetchAll($result_select);

$results["落札金額"] = array_column($res, "sum", "id");

/// 入札取消数 ///
$bids_delete_select = clone $bm_select;
$bids_delete_select->join(["mbb" => "my_bid_bids"], "mbb.bid_machine_id = bm.id", ["id" => "mbb.my_user_id", "c" => "count(*)"])
    ->where("mbb.deleted_at IS NOT NULL")
    ->group("mbb.my_user_id");

$res = $_db->fetchAll($bids_delete_select);

$results["入札取消"] = array_column($res, "c", "id");

// var_export($results);
// exit;

if ($output == 'csv') { // CSV
    $body = [];
    $keys = array_keys($results);

    foreach ($ids as $id) {
        $row = ["id" => $id];

        foreach ($keys as $key) {
            $row[$key] = isset($results[$key][$id]) ? $results[$key][$id] : null;
        }

        $body[] = $row;
    }

    $header = ["id" => "id"];
    foreach ($keys as $key) $header[$key] = $key;

    $filename = "{$bid_open_id}_my_users_total.csv";
    B::downloadCsvFile($header, $body, $filename);
} else {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => "{$bid_open["title"]} ユーザごとの集計",
        'pankuzu'          => array(
            '/system/' => '管理者ページ',
            '/system/bid_open_list.php' => '入札会開催一覧',
        ),
        'bid_open'  => $bid_open,
        "ids"       => $ids,
        "results"   => $results,
    ))->display('system/bid_total/index.tpl');
}
exit;
