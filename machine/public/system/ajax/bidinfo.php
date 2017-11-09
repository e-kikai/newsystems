<?php
/**
 * AJAXで入札会バナー情報登録処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/09/05
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    $bidinfoTable = new Bidinfo();

    if ($action == 'set') {
        $bidinfoTable->set($data['id'], $data, $_FILES['banner_file']);
    } else if ($action == 'delete') {
        $bidinfoTable->deleteById($data['id']);
    } else {
        throw new Exception('処理がありません');
    }
    
    echo 'success';
} catch (Exception $e) { echo $e->getMessage(); }
