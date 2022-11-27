<?php

/**
 * 入札処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/26
 */
require_once '../../../lib-machine.php';

/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_machine_id = Req::post('id');
$amount         = intval(Req::post('amount'));
$comment        = Req::post('comment');

try {
  /// ユーザ情報 ///
  $my_user_model = new MyUser();
  $my_user       = $my_user_model->get($_my_user['id']);

  // TODO: ブラックリスト、凍結チェック

  /// 入札商品情報を取得 ///
  $bid_machines_model = new BidMachine();
  $bid_machine = $bid_machines_model->get($bid_machine_id);

  if (empty($bid_machine)) throw new Exception("入札商品情報がありませんでした。");

  /// 入札会情報を取得 ///
  $bid_open_model = new BidOpen();
  $bid_open = $bid_open_model->get($bid_machine["bid_open_id"]);

  if (empty($bid_open)) throw new Exception("入札会情報がありませんでした。");

  // 出品期間のチェック
  $my_bid_bid_model = new MyBidBid();
  $e = $my_bid_bid_model->check_date_errors($bid_open);

  if (!empty($e)) throw new Exception($e);

  // 入札内容のチェック
  $e = "";
  if (empty($amount))   $e .= "金額エラー : 入札金額が入力されていません。\n";
  if (!is_int($amount)) $e .= "金額エラー : 入札金額が整数の値ではありません。\n";
  if ($amount < $bid_machine["min_price"])  $e .= "金額エラー : 入札金額が、最低入札金額より小さく入力されています。\n";
  if ($amount % $bid_open["rate"] |= 0)  $e .= "金額エラー : 入札金額が、{$bid_open['rate']}円単位ではありません。\n";

  if (!empty($e)) throw new Exception($e);

  // 入札の保存処理
  $my_bid_bid_model->my_insert(
    [
      "my_user_id"     => $_my_user['id'],
      "bid_machine_id" => $bid_machine_id,
      "amount"         => $amount,
      "comment"        => $comment,
      "sameno"         => mt_rand(),
    ]
  );

  header('Location: /mypage/my_bid_bids/create_fin.php?m=' . $bid_machine_id);
  exit;

  $return_url = "/mypage/my_bid_bids/create_fin.php?id={$bid_open_id}";
  header('Location: ' . $return_url);
  exit;
} catch (Exception $e) {
  /// エラー画面表示 ///
  $_smarty->assign(array(
    'pageTitle' => '入札エラー',
    'pageDescription' => '入札処理でエラーが発生しました。以下の内容をご確認ください。',
    'pankuzu'         => array(
      '/mypage/' => 'マイページ',
      '/mypage/bid_opens/' => '入札会一覧'
    ),
    'errorMes'  => $e->getMessage()
  ))->display('error.tpl');
}
