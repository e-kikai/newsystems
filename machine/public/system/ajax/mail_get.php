<?php
/**
 * AJAXでメール情報取得処理
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
    
    $action = Req::query('action');
    $target = Req::query('target');
    $data   = Req::query('data');
    
    $mModel = new Mail();
    if ($action == "count") {
        $res = $mModel->getSendList($data['target'], $data['val']);
        echo count($res);
    } else {
        throw new Exception('処理がありません');
    }
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
