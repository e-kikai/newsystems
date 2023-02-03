<?php

/**
 * ユーザ取引登録処理
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/14
 */

require_once '../../../lib-machine.php';
/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_machine_id = Req::post('bid_machine_id');
$star           = Req::post('star');

$my_user_model = new MyUser();
$my_auth       = new MyAuth();

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);
if (empty($my_user)) throw new Exception("ユーザ情報が取得できませんでした。");

// 凍結チェック
if (!empty($my_user["freezed_at"])) throw new Exception("現在、取引を行えません。");

/// 入札商品情報を取得 ///
$bid_machine_model = new BidMachine();
$bid_machine = $bid_machine_model->get($bid_machine_id);

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_machine['bid_open_id']);

// check : 出品期間の終了チェック
$my_bid_bid_model = new MyBidBid();
$e = $my_bid_bid_model->check_end_errors($bid_open);
if (!empty($e)) throw new Exception($e);

/// 会社情報を取得 ///
$company_model  = new Companies();
$company = $company_model->get($bid_machine['company_id']);

/// 落札結果を取得 ///
$bids_result = $my_bid_bid_model->results_by_bid_machine_id($bid_machine['id']);
$bid_result = $bids_result[$bid_machine_id];

// check : 所有者チェック
if (empty($bid_result)) throw new Exception("この商品の落札情報がありません。");
if ($bid_result["my_user_id"] != $_my_user['id']) throw new Exception("あなたは、この商品の落札者ではありません。");

/// 受取確認・評価情報の保存 ///
if (!empty($bid_machine["star"])) {
  $_SESSION["flash_alert"] = "この商品は、すでに受取確認・評価を行っています。";

  header('Location: /mypage/my_bid_trades/show.php?m=' . $bid_machine_id);
  exit;
}

try {
  $bid_machine_model->set_star($bid_machine_id, $star);
} catch (Exception $e) {
  echo $e->getMessage();
  exit;
}

$_SESSION["flash_notice"] = "受取確認・評価を行いました。";

header('Location: /mypage/my_bid_trades/show.php?m=' . $bid_machine_id);
exit;
