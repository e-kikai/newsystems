<?php

/**
 * ジャンルごとの集計ページ
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
$target      = Req::query('target');
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
$bm_select = $bid_machine_model->select()->setIntegrityCheck(false)
    ->from("bid_machines as bm", null)
    ->join(["ge" => "genres"], "ge.id = bm.genre_id", null)
    ->join(["la" => "large_genres"], "la.id = ge.large_genre_id", null)
    ->join(["xl" => "xl_genres"], "xl.id = la.xl_genre_id", null)
    ->where("bm.bid_open_id = ?", $bid_open_id)
    ->where("bm.deleted_at IS NULL");

if ($target == "xl_genre") { // 特大ジャンル
    $bm_select->columns(["xl.id", "xl.xl_genre"])
        ->group(["xl.id", "xl.order_no"])->order("xl.order_no");
    $gt = "特大ジャンル";
} else if ($target == "large_genre") { // 大ジャンル
    $bm_select->columns(["la.id", "xl.xl_genre", "la.large_genre"])
        ->group(["xl.id", "xl.order_no", "la.id", "la.order_no"])
        ->order(["xl.order_no", "la.order_no"]);
    $gt = "大ジャンル";
} else { // ジャンル
    $bm_select->columns(["ge.id", "xl.xl_genre", "la.large_genre", "ge.genre"])
        ->group(["xl.id", "xl.order_no", "la.id", "la.order_no", "ge.id", "ge.order_no"])
        ->order(["xl.order_no", "la.order_no",  "ge.order_no"]);
    $gt = "ジャンル";
}

/// 出品件数、金額 ///
$select = clone $bm_select;
$select
    ->columns("count(bm.id) as c, sum(bm.min_price) as price, count(bm.auto_at) as auto")
    ->columns("count(DISTINCT bm.company_id) as co");

$res = $_db->fetchAll($select);

// echo $select;
// var_export($res);
// exit;

$ids = array_column($res, "id");

if (!empty($res[0]["xl_genre"]))    $results["特大ジャンル"] = array_column($res, "xl_genre", "id");
if (!empty($res[0]["large_genre"])) $results["大ジャンル"]   = array_column($res, "large_genre", "id");
if (!empty($res[0]["genre"]))       $results["ジャンル"]    = array_column($res, "genre", "id");
$results["出品数"]      = array_column($res, "c", "id");
$results["最低金額合計"] = array_column($res, "price", "id");
$results["自動入札"]    = array_column($res, "auto", "id");
$results["出品社数"]    = array_column($res, "co", "id");

/// 詳細アクセス ///
$watches_select = clone $bm_select;
$watches_select->join(["bdl" => "bid_detail_logs"], "bdl.bid_machine_id = bm.id", "count(*) as c")
    ->columns("count(DISTINCT bdl.utag) as utag")
    ->columns("count(DISTINCT bdl.my_user_id) as my_user");

$res = $_db->fetchAll($watches_select);

$results["詳細 アクセス"]  = array_column($res, "c", "id");
$results["詳細 utag"]    = array_column($res, "utag", "id");
$results["詳細 ユーザ数"] = array_column($res, "my_user", "id");

/// ウォッチ数 ///
$watches_select = clone $bm_select;
$watches_select->join(["mbw" => "my_bid_watches"], "mbw.bid_machine_id = bm.id", "count(*) as c")
    ->columns("count(mbw.deleted_at) as del")
    ->columns("count(DISTINCT mbw.my_user_id) as my_user");

$res = $_db->fetchAll($watches_select);

$results["ウォッチ"]  =  array_column($res, "c", "id");
$results["うち、削除"] = array_column($res, "del", "id");
$results["ウォッチ ユーザ数"] = array_column($res, "my_user", "id");

/// 入札数 ///
$bids_select = clone $bm_select;
$bids_select->join(["mbb" => "my_bid_bids"], "mbb.bid_machine_id = bm.id", "count(*) as c")
    ->where("mbb.deleted_at IS NULL")
    ->columns("count(DISTINCT mbb.bid_machine_id) as success, count(DISTINCT mbb.my_user_id) as user");

$res = $_db->fetchAll($bids_select);

$results["入札数"]   = array_column($res, "c", "id");
$results["入札人数"] = array_column($res, "user", "id");
$results["落札数"]   = array_column($res, "success", "id");

/// 落札金額 ///
$sub = $bid_machine_model->select()->setIntegrityCheck(false)
    ->from(["mbb2" => "my_bid_bids"], "mbb2.bid_machine_id, max(mbb2.amount) as result_price")
    ->where("mbb2.deleted_at IS NULL")
    ->group("mbb2.bid_machine_id");

$result_select = clone $bm_select;
$result_select->join(["sub" => $sub], "sub.bid_machine_id = bm.id", "sum(sub.result_price) as sum");

$res = $_db->fetchAll($result_select);

$results["落札金額"] = array_column($res, "sum", "id");

/// 入札取消数 ///
$bids_delete_select = clone $bm_select;
$bids_delete_select->join(["mbb" => "my_bid_bids"], "mbb.bid_machine_id = bm.id", "count(*) as c")
    ->where("mbb.deleted_at IS NOT NULL")
    ->columns("count(DISTINCT mbb.my_user_id) as user");

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

    $filename = "{$bid_open_id}_genres_total.csv";
    B::downloadCsvFile($header, $body, $filename);
} else {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => "{$bid_open["title"]} {$gt}ごとの集計",
        'pankuzu'          => array(
            '/system/' => '管理者ページ',
            '/system/bid_open_list.php' => '入札会開催一覧',
        ),
        'bid_open'  => $bid_open,
        "ids"       => $ids,
        "results"   => $results,
    ))->display('system/my_bid_bids/companies.tpl');
}
exit;
