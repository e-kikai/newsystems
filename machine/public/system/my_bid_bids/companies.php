<?php

/**
 * 会社ごとの集計ページ
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
$bm_select = $bid_machine_model->select()->setIntegrityCheck(false)
  ->from("bid_machines as bm", "bm.company_id as id")
  ->where("bm.bid_open_id = ?", $bid_open_id)
  ->where("bm.deleted_at IS NULL")
  ->group("bm.company_id")->order("bm.company_id");

/// 出品件数、金額 ///
$select = clone $bm_select;
$select->join(["co" => "companies"], "co.id = bm.company_id", ["co.company", "co.addr1"])
  ->group(["co.company", "co.addr1"])
  ->columns("count(bm.id) as c, sum(bm.min_price) as price, count(bm.auto_at) as auto");

$res = $_db->fetchAll($select);

// echo $select;
// var_export($res);
// exit;

$ids = array_column($res, "id");

$results["会社名"]      = array_column($res, "company", "id");
$results["都道府県"]    = array_column($res, "addr1", "id");
$results["出品数"]      = array_column($res, "c", "id");
$results["最低金額合計"] = array_column($res, "price", "id");
$results["自動入札"]    = array_column($res, "auto", "id");

/// 詳細アクセス ///
$watches_select = clone $bm_select;
$watches_select->join(["bdl" => "bid_detail_logs"], "bdl.bid_machine_id = bm.id", "count(*) as c");

$res = $_db->fetchAll($watches_select);

$results["詳細アクセス"] =   array_column($res, "c", "id");

/// ウォッチ数 ///
$watches_select = clone $bm_select;
$watches_select->join(["mbw" => "my_bid_watches"], "mbw.bid_machine_id = bm.id", "count(*) as c")
  ->columns("count(mbw.deleted_at) as del");

$res = $_db->fetchAll($watches_select);

$results["ウォッチ"]  =  array_column($res, "c", "id");
$results["うち、削除"] = array_column($res, "del", "id");

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

  $filename = "{$bid_open_id}_companies_total.csv";
  B::downloadCsvFile($header, $body, $filename);
} else {
  /// 表示変数アサイン ///
  $_smarty->assign(array(
    'pageTitle' => "{$bid_open["title"]} 出品会社ごとの集計",
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
