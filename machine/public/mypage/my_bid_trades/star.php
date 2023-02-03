<?php

/**
 * ユーザ受取確認・評価ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2023/2/2
 */

require_once '../../../lib-machine.php';
/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_machine_id = Req::query('m');

// check :  変数チェック
if (empty($bid_machine_id)) throw new Exception('入札会商品情報が取得出来ません');

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);

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
// $bids_count  = $my_bid_bid_model->count_by_bid_machine_id($bid_machine['id']);
$bids_result = $my_bid_bid_model->results_by_bid_machine_id($bid_machine['id']);

// $bid_count  = $bids_count[$bid_machine_id];
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

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => "受取確認・評価",
    // 'pageDescription' => 'ここで、出品会社との取引を行います。ご質問、入金確認、到着の報告などを行ってください。',

    'pankuzu'         => array(
        '/mypage/'            => 'マイページ',
        "/mypage/my_bid_bids/?o={$bid_machine['bid_open_id']}" => '入札一覧(落札一覧)',
        "/mypage/my_bid_trades/show.php?m={$bid_machine_id}" => "落札後の取引 管理番号 :  {$bid_machine["list_no"]} {$bid_machine["name"]}  {$bid_machine["maker"]}  {$bid_machine["model"]}",
    ),

    'my_user'       => $my_user,
    'bid_machine'   => $bid_machine,
    'company'       => $company,
    // 'bid_count'     => $bid_count,
    'bid_result'    => $bid_result,
))->display('mypage/my_bid_trades/star.tpl');
