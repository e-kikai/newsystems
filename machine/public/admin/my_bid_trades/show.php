<?php

/**
 * 会員取引ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/15x
 */

require_once '../../../lib-machine.php';
/// 認証処理 ///
Auth::isAuth('member');

/// 変数を取得 ///
$bid_machine_id = Req::query('m');

// check :  変数チェック
if (empty($bid_machine_id)) throw new Exception('入札会商品情報が取得出来ません');

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

/// 落札結果を取得 ///
$bids_count  = $my_bid_bid_model->count_by_bid_machine_id($bid_machine['id']);
$bids_result = $my_bid_bid_model->results_by_bid_machine_id($bid_machine['id']);

$bid_count  = $bids_count[$bid_machine_id];
$bid_result = $bids_result[$bid_machine_id];

/// 落札ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($bid_result['my_user_id']);

// check : 所有者チェック
if (empty($bid_result)) throw new Exception("この商品の落札情報がありません。");

/// 取引情報取得 ///
$my_bid_trade_model = new MyBidTrade();
$select = $my_bid_trade_model->my_select()
    ->where("my_user_id = ?", $bid_result['my_user_id'])
    ->where("bid_machine_id = ?", $bid_machine['id']);
$my_bid_trades = $my_bid_trade_model->fetchAll($select);

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => "落札後の取引 - 管理番号 :  {$bid_machine["list_no"]} {$bid_machine["name"]}  {$bid_machine["maker"]}  {$bid_machine["model"]}",
    'pageDescription' => 'ここで、落札者との取引を行います。ご質問、入金確認、到着の報告などを行ってください。',

    'pankuzu'         => array(
        '/admin/'            => 'マイページ',
        "/admin/bid_machine_list.php?o={$bid_open['id']}" => '入札一覧(落札一覧)',
    ),

    'my_user'       => $my_user,
    'bid_machine'   => $bid_machine,
    'company'       => $company,
    'bid_count'     => $bid_count,
    'bid_result'    => $bid_result,
    "my_bid_trades" => $my_bid_trades,
))->display('admin/my_bid_trades/show.tpl');
