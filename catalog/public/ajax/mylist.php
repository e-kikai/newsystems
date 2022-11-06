<?php

/**
 * AJAXでマイページのセット・削除
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/17
 */
/// 設定ファイル読み込み ///
require_once '../../lib-catalog.php';
try {
    /// 認証 ///
    Auth::isAuth('catalog');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = (array)Req::post('data');

    $mModel = new Mylist();
    if ($action == 'set') {
        $mModel->set($_user['id'], $target, $data);
    } elseif ($action == 'delete') {
        $mModel->delete($_user['id'], $target, $data);
    } else {
        throw new Exception('マイリストが操作できませんでした');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
