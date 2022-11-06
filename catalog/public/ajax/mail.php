<?php

/**
 * AJAXでメール送信(カタログリクエスト)処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2014/02/05
 */
/// 設定ファイル読み込み ///
require_once '../../lib-catalog.php';
try {
    /// 認証 ///
    Auth::isAuth('catalog');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    if ($action == 'sendCatalogReq') {
        $mModel = new Mail();
        $data['target']  = 'catalog';
        $data['user_id'] = $_user['id'];
        $mModel->sendCatalogReq($data);
    } else {
        throw new Exception('処理がありません');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
