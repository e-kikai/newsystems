<?php
/**
 * AJAXでパスワード変更処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/17
 */
//// 設定ファイル読み込み ////
require_once '../../lib-catalog.php';
try {
    //// 認証 ////
    Auth::isAuth('catalog');
    
    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');
    
    $mAuth = new Auth();
    if ($action == 'changePasswd') {
        // パスワード変更処理
        $mAuth->changePasswd($data['account'], $data['nowPasswd'], $data['passwd'], $data['passwdChk']);
    } else {
        throw new Exception('処理がありません');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
