<?php

/**
 * 入札会ごとの集計ページ
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
$output      = Req::query('output');

$results = [];

$bid_machine_model = new BidMachine();
$bm_select = $bid_machine_model->select()->setIntegrityCheck(false)
    ->from("bid_machines as bm", "bm.bid_open_id as id")
    ->where("bm.deleted_at IS NULL")
    ->group("bm.bid_open_id");

/// 入札会情報、出品件数、金額 ///
$select = clone $bm_select;
$select->join(["bo" => "bid_opens"], "bo.id = bm.bid_open_id", ["bo.title"])
    ->columns("count(bm.id) as c, sum(bm.min_price) as price, count(bm.auto_at) as auto")
    ->columns("count(DISTINCT bm.company_id) as company")
    ->columns(["bo.bid_start_date", "bo.bid_end_date"])
    ->group(["bo.title", "bo.bid_start_date", "bo.bid_end_date"])
    ->order("bm.bid_open_id DESC");

$res = $_db->fetchAll($select);

// echo $select;
// var_export($res);
// exit;

$ids = array_column($res, "id");

$results["入札会"]      = array_column($res, "title", "id");
$results["入札開始日時"]    = array_column($res, "bid_start_date", "id");
$results["入札終了日時"]    = array_column($res, "bid_end_date", "id");
$results["出品数"]      = array_column($res, "c", "id");
$results["最低金額合計"] = array_column($res, "price", "id");
$results["自動入札"]    = array_column($res, "auto", "id");
$results["出品会社"]    = array_column($res, "company", "id");

/// 詳細アクセス ///
$watches_select = clone $bm_select;
$watches_select->join(["bdl" => "bid_detail_logs"], "bdl.bid_machine_id = bm.id", "count(*) as c")
    ->columns("count(DISTINCT bdl.utag) as utag")
    ->columns("count(DISTINCT bdl.my_user_id) as my_user");

$res = $_db->fetchAll($watches_select);

$results["詳細 アクセス"] = array_column($res, "c", "id");
$results["詳細 utag"]    = array_column($res, "utag", "id");
$results["詳細 ユーザ数"] = array_column($res, "my_user", "id");

/// ウォッチ数 ///
$watches_select = clone $bm_select;
$watches_select->join(["mbw" => "my_bid_watches"], "mbw.bid_machine_id = bm.id", "count(*) as c")
    ->columns("count(mbw.deleted_at) as del")
    ->columns("count(DISTINCT mbw.my_user_id) as my_user");

$res = $_db->fetchAll($watches_select);

$results["ウォッチ"]         = array_column($res, "c", "id");
$results["うち、削除"]       = array_column($res, "del", "id");
$results["ウォッチ ユーザ数"] = array_column($res, "my_user", "id");

/// 入札数 ///
$bids_select_1 = clone $bm_select;
$bids_select_1->join(["mbb" => "my_bid_bids"], "mbb.bid_machine_id = bm.id", [
    "c"        => "count(CASE WHEN mbb.deleted_at IS NULL THEN true END)",
    "user"     => "count(DISTINCT CASE WHEN mbb.deleted_at IS NULL THEN mbb.my_user_id END)",
    "success"  => "count(DISTINCT CASE WHEN mbb.deleted_at IS NULL THEN mbb.bid_machine_id END)",
    "del"      => "count(CASE WHEN mbb.deleted_at IS NOT NULL THEN true END)",
    "del_user" => "count(DISTINCT CASE WHEN mbb.deleted_at IS NOT NULL THEN mbb.my_user_id END)",
])->__toString();

$bids_select_2 = clone $bm_select;
$bids_select_2->join(["bb" => "bid_bids"], "bb.bid_machine_id = bm.id", [
    "c"        => "count(CASE WHEN bb.deleted_at IS NULL THEN true END)",
    "user"     => "count(DISTINCT CASE WHEN bb.deleted_at IS NULL THEN bb.company_id END)",
    "success"  => "count(DISTINCT CASE WHEN bb.deleted_at IS NULL THEN bb.bid_machine_id END)",
    "del"      => "count(CASE WHEN bb.deleted_at IS NOT NULL THEN true END)",
    "del_user" => "count(DISTINCT CASE WHEN bb.deleted_at IS NOT NULL THEN bb.company_id END)",
])->__toString();

$bids_select = $bid_machine_model->select()->union(array($bids_select_1, $bids_select_2));

// echo $bids_select_2;
// var_export($res);
// exit;

$res = $_db->fetchAll($bids_select);

$results["入札数"]   = array_column($res, "c", "id");
$results["入札人数"]  = array_column($res, "user", "id");
$results["落札数"]   = array_column($res, "success", "id");
$results["入札取消"]  = array_column($res, "del", "id");
$results["入札取消 人数"]  = array_column($res, "del_user", "id");

/// 落札金額 ///
$sub_1 = $bid_machine_model->select()->setIntegrityCheck(false)
    ->from(["mbb2" => "my_bid_bids"], ["mbb2.bid_machine_id", "max" => "max(mbb2.amount)",])
    ->where("mbb2.deleted_at IS NULL")
    ->group("mbb2.bid_machine_id")
    ->__toString();

$sub_2 = $bid_machine_model->select()->setIntegrityCheck(false)
    ->from(["bb2" => "bid_bids"], ["bb2.bid_machine_id", "max" => "max(CASE WHEN bb2.deleted_at IS NULL THEN bb2.amount END)",])
    ->where("bb2.deleted_at IS NULL")
    ->group("bb2.bid_machine_id")
    ->__toString();

$sub = $bid_machine_model->select()->union(array($sub_1, $sub_2));

$result_select = clone $bm_select;
$result_select->join(["sub" => $sub], "sub.bid_machine_id = bm.id", ["max" => "sum(sub.max)",]);

$res = $_db->fetchAll($result_select);

$results["落札金額"]   = array_column($res, "max", "id");

/// 入札取消数 ///
// $bids_delete_select = clone $bm_select;
// $bids_delete_select->join(["mbb" => "my_bid_bids"], "mbb.bid_machine_id = bm.id", "count(*) as c")
//     ->where("mbb.deleted_at IS NOT NULL")
//     ->columns("count(DISTINCT mbb.my_user_id) as user");

// $res = $_db->fetchAll($bids_delete_select);

// $results["入札取消"] = array_column($res, "c", "id");

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

    $filename = date('YmdHis') . "_companies_total.csv";
    B::downloadCsvFile($header, $body, $filename);
} else {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => "結果集計",
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        "ids"       => $ids,
        "results"   => $results,
    ))->display('system/bid_total/index.tpl');
}
exit;
