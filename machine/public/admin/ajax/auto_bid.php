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

        $bid_machine_model = new BidMachine();
        $bid_machine = $bid_machine_model->get($d['id']);

        // 情報のチェック
        if (empty($bid_machine)) throw new Exception("商品情報が取得できませんでした。");
        if ($bid_machine["company_id"] != $_user['company_id']) throw new Exception("自社の出品商品ではありません。");

        if ($action == "set") { // 自動入札設定処理
            $bid_machine_model->set_auto($d['id']);

            // 既に入札が行われている場合は、自動入札を行う
            $my_bid_bid_model = new MyBidBid();
            $bids_result = $my_bid_bid_model->results_by_bid_machine_id($d['id']);

            if (!empty($bids_result[$d['id']]) && $bids_result[$d['id']]["my_user_id"] != MyUser::SYSTEM_MY_USER_ID) {
                $my_bid_bid_model->my_insert(
                    [
                        "my_user_id"     => MyUser::SYSTEM_MY_USER_ID,
                        "bid_machine_id" => $d['id'],
                        "amount"         => MyBidBid::auto_amount($bids_result[$d['id']]["amount"]),
                        "comment"        => "自動入札",
                        "sameno"         => mt_rand(),
                    ]
                );
            }
        } else if ($action == "delete") {  // 自動入札解除
            $bid_machine_model->delete_auto($d['id']);
        } else {
            throw new Exception('処理がありません');
        }
        echo 'success';
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
