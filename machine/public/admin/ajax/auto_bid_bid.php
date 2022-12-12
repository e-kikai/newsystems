<?php

/**
 * 自動入札用をAJAX処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2021/11/04
 */
/// 設定ファイル読み込み ///
require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('member');

    if ($_SERVER["REQUEST_METHOD"] == "POST") {

        $action = Req::post('action');
        $target = Req::post('target');
        $d      = Req::post('data');

        $res = '';

        /// 自動入札情報を取得 ///
        $my_bid_bid_model = new MyBidBid();
        $my_bid_bid = $my_bid_bid_model->get($d['id']);

        if (empty($my_bid_bid)) throw new Exception("削除する入札情報がありませんでした。");
        if ($my_bid_bid["my_user_id"] != MyUser::SYSTEM_MY_USER_ID) throw new Exception("この入札は自動入札ではありません。");

        /// 入札商品情報を取得 ///
        $bid_machines_model = new BidMachine();
        $bid_machine = $bid_machines_model->get($my_bid_bid["bid_machine_id"]);

        // 情報のチェック(自動入札のため、自社の商品かどうかをチェック)
        if ($bid_machine["company_id"] != $_user['company_id']) throw new Exception("自社の入札ではありません。");

        /// 入札会情報を取得 ///
        $bid_open_model = new BidOpen();
        $bid_open = $bid_open_model->get($bid_machine["bid_open_id"]);

        // 出品期間のチェック
        $my_bid_bid_model = new MyBidBid();
        $e = $my_bid_bid_model->check_date_errors($bid_open);

        if (!empty($e)) throw new Exception($e);

        if ($action == "delete") {  // 自動入札での入札取り消し
            $my_bid_bid_model->my_delete($d['id']);
        } else {
            throw new Exception('処理がありません');
        }
        echo 'success';
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
