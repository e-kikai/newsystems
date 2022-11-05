<?php

/**
 * 入札出品キャンセル用をAJAX処理
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

        $bmModel = new BidMachine();

        if ($action == "set") {
            // キャンセル処理
            $bmModel->set_cancel($d['cancels'], $d['id'], $_user['company_id']);
        } else if ($action == "delete") {
            // キャンセルを解除(再出品)
            $bmModel->delete_cancel($d['id'], $_user['company_id']);
        } else {
            throw new Exception('処理がありません');
        }
        echo 'success';
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
