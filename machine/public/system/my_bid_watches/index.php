<?php

/**
 * ウォッチ履歴一覧ページ
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

if (empty($bid_open_id)) throw new Exception('入札会情報が取得出来ません');

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

$my_bid_watch_model = new MyBidWatch();

// 入札一覧の取得
$select = $my_bid_watch_model->my_select()
  ->join("bid_machines", "bid_machines.id = my_bid_watches.bid_machine_id",  ["list_no", "name", "maker", "model", "min_price", "top_img", "company_id"])
  ->join("my_users", "my_users.id = my_bid_watches.my_user_id", ["uniq_account", "user_name" => "name", "user_company" => "company"])
  ->join("companies", "companies.id = bid_machines.company_id", ["company"])
  ->where("bid_machines.bid_open_id = ?", $bid_open_id);

$my_bid_watches = $bid_open_model->fetchAll($select);

/// 落札結果を取得 ///
if (in_array($bid_open['status'], array('carryout', 'after'))) {
  $ids = $my_bid_bid_model->bid_machines2ids($my_bid_watches, "bid_machine_id");
  $bids_count  = $my_bid_bid_model->count_by_bid_machine_id($ids);
  $bids_result = $my_bid_bid_model->results_by_bid_machine_id($ids);

  $_smarty->assign(array(
    "bids_count"  => $bids_count,
    "bids_result" => $bids_result,
  ));
}

/// 表示変数アサイン ///
$_smarty->assign(array(
  'pageTitle'       => "{$bid_open["title"]} ウォッチリスト履歴一覧",
  'pankuzu'          => array(
    '/system/' => '管理者ページ',
    '/system/bid_open_list.php' => '入札会開催一覧',
  ),

  'bid_open'       => $bid_open,
  'my_bid_watches' => $my_bid_watches,
))->display('system/my_bid_watches/index.tpl');
