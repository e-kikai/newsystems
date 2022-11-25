<?php

/**
 * ユーザウォッチリスト一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/07
 */

require_once '../../lib-machine.php';
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
$e = '';
if (empty($bid_open)) {
  $e = '入札会情報が取得出来ませんでした';
} else if (!in_array($bid_open['status'], array('bid', 'carryout', 'after'))) {
  $e = "{$bidOpen['title']}は現在、入札会の期間ではありません\n";
  $e .= "入札期間 : " . date('Y/m/d H:i', strtotime($bid_open['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bid_open['bid_end_date']));
}
if (!empty($e)) throw new Exception($e);

// 入札一覧の取得
$my_bid_watch_model = new MyBidWatch();
$select = $my_bid_watch_model->my_select()
  ->where("my_user_id = ?", $_my_user['id'])
  ->where("bid_open_id = ?", $bid_open_id);
$my_bid_watches = $my_bid_watch_model->fetchAll($select);

/// 表示変数アサイン ///
$_smarty->assign(array(
  'pageTitle'       => "{$bid_open["title"]} ウォッチリスト",
  'pageDescription' => 'ウォッチリストです。ここから入札を行うこともできます。',

  'errorMes'        => $e,
  'pankuzu'         => array(
    '/mypage/' => 'マイページ',
    '/mypage/bid_opens/' => '入札会一覧'
  ),

  'my_user'        => $my_user,
  'bid_open'       => $bid_open,
  'my_bid_watches' => $my_bid_watches,
))->display('mypage/my_bid_bids/index.tpl');
