<?php
/**
 * AJAXでお知らせ情報変更処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/17
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');
    
    $iModel = new Info();
    if ($action == 'set') {
        // 会社情報変更処理
        $id = !empty($data['id']) ? $data['id'] : NULL;
        $q = array(
            'info_date' => $data['info_date'],
            'target' => $data['target'],
            'group_id' => $data['group_id'],
            'contents' => $data['contents'],
        );
        $iModel->set($id, $q);
    } else if ($action == "delete") {
        $iModel->deleteById($data);
    } else {
        throw new Exception('処理がありません');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
