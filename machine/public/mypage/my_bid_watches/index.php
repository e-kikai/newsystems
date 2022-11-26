<?php

/**
 * ユーザウォッチリスト一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/07
 */

require_once '../../../lib-machine.php';
/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_open_id = Req::query('o');

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

// 出品期間のチェック
$my_bid_bid_model = new MyBidBid();
$e = $my_bid_bid_model->check_date_errors($bid_open);

if (!empty($e)) throw new Exception($e);

// ウォッチ一覧の取得
$my_bid_watch_model = new MyBidWatch();
$select = $my_bid_watch_model->my_select()
  ->join("bid_machines", "bid_machines.id = my_bid_watches.bid_machine_id",  ["list_no", "name", "maker", "model", "min_price", "top_img", "company_id"])
  ->join("companies", "companies.id = bid_machines.company_id", ["company"])
  ->where("my_bid_watches.my_user_id = ?", $_my_user['id'])
  ->where("bid_machines.bid_open_id = ?", $bid_open_id);;

// ->where("bid_machine_id IN (SELECT id FROM bid_machines WHERE bid_open_id = ?)", $bid_open_id);
$my_bid_watches = $my_bid_watch_model->fetchAll($select);

/// 表示変数アサイン ///
$_smarty->assign(array(
  'pageTitle'       => "{$bid_open["title"]} ウォッチリスト",
  'pageDescription' => 'ウォッチリストです。入札を行うには、商品名をクリックして、詳細ページがら行えます。',

  'errorMes'        => $e,
  'pankuzu'         => array(
    '/mypage/' => 'マイページ',
    '/mypage/bid_opens/' => '入札会一覧'
  ),

  'my_user'        => $my_user,
  'bid_open'       => $bid_open,
  'my_bid_watches' => $my_bid_watches,
))->display('mypage/my_bid_watches/index.tpl');
