<?php

/**
 * AJAXで会社情報変更処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/17
 */
/// 設定ファイル読み込み ///
require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('system');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    $cAuth = new Company();
    if ($action == 'systemSet') {
        // 会社情報(代表者)登録・変更処理
        $cModel = new Company();
        $cModel->systemSet($data, $data['id']);
    } else if ($action == 'login') {
        // 代理ログイン
        $auth = new Auth();
        $auth->systemLogin($data['id']);
    } else if ($action == 'delete') {
        // 削除
        $cModel = new Company();
        $cModel->deleteById($data['id']);
    } else {
        throw new Exception('処理がありません');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
