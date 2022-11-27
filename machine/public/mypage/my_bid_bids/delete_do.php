<?php

/**
 * ユーザ入札削除処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/23
 */
require_once '../../../lib-machine.php';

/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$my_bid_bid_id = Req::post('id');

try {
  /// ユーザ情報 ///
  $my_user_model = new MyUser();
  $my_user       = $my_user_model->get($_my_user['id']);

  /// 削除する入札情報を取得 ///
  $my_bid_bid_model = new MyBidBid();
  $my_bid_bid       = $my_bid_bid_model->get($my_bid_bid_id);

  if (empty($my_bid_bid)) throw new Exception("削除する入札情報がありませんでした。");

  /// 入札商品情報を取得 ///
  $bid_machines_model = new BidMachine();
  $bid_machine = $bid_machines_model->get($my_bid_bid["bid_machine_id"]);

  /// 入札会情報を取得 ///
  $bid_open_model = new BidOpen();
  $bid_open = $bid_open_model->get($bid_machine["bid_open_id"]);

  // 出品期間のチェック
  $my_bid_bid_model = new MyBidBid();
  $e = $my_bid_bid_model->check_date_errors($bid_open);

  if (!empty($e)) throw new Exception($e);

  // 削除処理
  $my_bid_bid_model->my_delete($my_bid_bid_id);

  $return_url = "/mypage/my_bid_bids/?o={$bid_machine['bid_open_id']}";
  header('Location: ' . $return_url);
  exit;
} catch (Exception $e) {
  /// エラー画面表示 ///
  $_smarty->assign(array(
    'pageTitle' => '入札削除エラー',
    'pageDescription' => '入札の削除でエラーが発生しました。以下の内容をご確認ください。',
    'pankuzu'         => array(
      '/mypage/' => 'マイページ',
      '/mypage/bid_opens/' => '入札会一覧'
    ),
    'errorMes'  => $e->getMessage()
  ))->display('error.tpl');
}