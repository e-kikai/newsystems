<?php

/**
 * 入札完了ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/27
 */
require_once '../../../lib-machine.php';

/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_machine_id = Req::query('m');

/// 入札商品情報を取得 ///
$bid_machines_model = new BidMachine();
$bid_machine = $bid_machines_model->get($bid_machine_id);

if (empty($bid_machine)) throw new Exception("入札商品情報がありませんでした。");

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_machine["bid_open_id"]);

if (empty($bid_open)) throw new Exception("入札会情報がありませんでした。");

$_smarty->assign(array(
  'pageTitle' => '入札完了',
  // 'pageDescription' => '入札を受け付けました。',
  'pankuzu'         => array(
    '/mypage/' => 'マイページ',
    '/mypage/my_bid_bids/?o=' . $bid_machine["bid_open_id"] => '入札一覧',
  ),

  "bid_machine" => $bid_machine,
  "bid_open"    => $bid_open,
))->display("mypage/my_bid_bids/create_fin.tpl");
