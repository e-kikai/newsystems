<?php
/**
 * AJAXで開発TODO情報変更処理
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
    
    $tModel = new Todo();
    if ($action == 'set') {
        // 会社情報変更処理
        $id = !empty($data['id']) ? $data['id'] : NULL;
        $q = array(
            'title'    => $data['title'],
            'target'   => $data['target'],
            'contents' => $data['contents'],
        );
        $tModel->set($id, $q);
    } else if ($action == "delete") {
        $tModel->deleteById($data);
    } else {
        throw new Exception('処理がありません');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
