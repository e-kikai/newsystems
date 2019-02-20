<?php
/**
 * ファイルアップロード処理(新版)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/05/21
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    $uModel = new Urikai();
    if ($action == 'set') {
        // 会社情報変更処理
        $id = !empty($data['id']) ? $data['id'] : NULL;
        $q = array(
            'company_id' => $_user['company_id'],
            'goal'       => $data['goal'],
            'contents'   => $data['contents'],
        );
        $uModel->set($id, $q);
    } else if ($action == "set_end_date") {
        if (empty($data['id'])) { throw new Exception('売り買い情報がありません'); }
        $uModel->set_end_date($data['id']);
    } else if ($action == "unset_end_date") {
        if (empty($data['id'])) { throw new Exception('売り買い情報がありません'); }
        $uModel->unset_end_date($data['id']);

    } else if ($action == "delete") {
        $uModel->deleteById($data);
    } else {
        throw new Exception('処理がありません');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
