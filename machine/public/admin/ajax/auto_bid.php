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
