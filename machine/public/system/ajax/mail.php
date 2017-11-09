<?php
/**
 * AJAXでメール送信処理
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
    

    if ($action == 'send') {
        $file  = $_FILES['file'];
    
        $mModel = new Mail();
        $mModel->sendGroup($data, $file);
    } else if ($action == 'setMailIgnore') {
        $mailIgnore = mb_convert_encoding($data['mail_ignore'], 'sjis-win', 'utf-8');
        if (file_put_contents(APP_PATH . Mail::MAIL_IGNORE_FILE, $mailIgnore) === FALSE) {
            throw new Exception('ファイルが保存できませんでした');
        }
    } else {
        throw new Exception('処理がありません');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
