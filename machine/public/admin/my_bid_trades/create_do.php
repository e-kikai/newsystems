<?php

/**
 * 会員取引登録処理
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/15
 */

require_once '../../../lib-machine.php';
/// 認証処理 ///
Auth::isAuth('member');

/// 変数を取得 ///
$bid_machine_id = Req::post('bid_machine_id');
$comment        = Req::post('comment');

$my_user_model = new MyUser();
$my_auth       = new MyAuth();

/// 会社情報を取得 ///
$company_model = new Company();
$company = $company_model->get($_user['company_id']);

/// 入札商品情報を取得 ///
$bid_machine_model = new BidMachine();
$bid_machine = $bid_machine_model->get($bid_machine_id);
if ($bid_machine["company_id"] != $_user['company_id']) throw new Exception("あなたは、この商品の出品会社ではありません。");

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

/// 落札ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($bid_result['my_user_id']);

// check : 所有者チェック
if (empty($bid_result)) throw new Exception("この商品の落札情報がありません。");

/// 取引情報の保存 ///
$my_bid_trade_model = new MyBidTrade();
$my_bid_trade_model->my_insert(
  [
    "bid_machine_id" => $bid_machine_id,
    "my_user_id"     => $bid_result['my_user_id'],
    "comment"        => $comment,
    "answer_flag"    => true,
  ]
);

$my_bid_trade_model->send_mail2user($my_user, $company, $bid_machine, $comment);

$_SESSION["flash_notice"] = "取引内容を投稿しました。";

header('Location: /admin/my_bid_trades/show.php?m=' . $bid_machine_id);
exit;
