<?php

/**
 * ユーザ入札削除処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/23
 */
require_once '../../lib-machine.php';

/// 認証 ///
MyAuth::is_auth();

$my_bid_bid_id = Req::post('id');

// 削除する入札情報
$my_bid_bid_model = new MyBidBid();
$my_bid_bids->my_delete($_my_user['id']);

/// ログインページにリダイレクト ///
header('Location:' . $_conf->login_uri . '?e=3');
exit;
