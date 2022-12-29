<?php

/**
 * ウォッチ登録処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/09
 */
require_once '../../../lib-machine.php';

/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_machine_id = Req::post('id');

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);
if (empty($my_user)) throw new Exception("ユーザ情報が取得できませんでした。");

// 凍結チェック
if (!empty($my_user["freezed_at"])) throw new Exception("現在、ウォッチ登録を行えません。");

$my_bid_watch_model = new MyBidWatch();
$my_bid_watch_model->my_insert(
  [
    "my_user_id"     => $_my_user['id'],
    "bid_machine_id" => $bid_machine_id,
  ]
);

header('Location: /bid_detail.php?m=' . $bid_machine_id);
exit;
