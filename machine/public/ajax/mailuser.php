<?php
/**
 * AJAXで配信開始・停止処理ほか
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2012/08/10
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');
    
    //// セキュリティコードのチェック ////
    if(!isset($_SESSION['captcha_keystring'])) {
        throw new Exception('セキュリティコードのチェックに失敗しました');
    } else if($_SESSION['captcha_keystring'] !=  $data['keystring']) {
        throw new Exception('セキュリティコードが間違っています');
    }
    
    $mModel = new Mailuser();
    if ($action == 'send') {
        // 配信開始処理
        $mModel->send($data['mail']);
    } else if ($action == 'unsend') {
        // 配信追加処理
        $mModel->unsend($data['mail']);
    } else {
        throw new Exception('処理がありません');
    }
    
    // セキュリティコードのunset
    unset($_SESSION['captcha_keystring']);
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
}
