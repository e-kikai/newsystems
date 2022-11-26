<?php

/**
 * ウォッチ削除処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/25
 */
require_once '../../../lib-machine.php';

/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_machine_id = Req::post('id');
$bid_open_id    = Req::post('o');
$return         = Req::post('return');

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);

// ウォッチ情報取得、削除
$my_bid_watch_model = new MyBidWatch();
$my_bid_watch = $my_bid_watch_model->get_by_user_machine($_my_user['id'], $bid_machine_id);

$my_bid_watch_model->my_delete($my_bid_watch["id"]);

if ($return == "detail") {
  $return_url = "/bid_detail.php?m={$bid_machine_id}";
} else {
  $return_url = "/mypage/my_bid_watches/?o={$bid_open_id}";
}

header('Location: ' . $return_url);
exit;
