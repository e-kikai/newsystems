<?php
/**
 * AJAXで入札会一括登録へのセット
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2014/01/15
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    $target = Req::post('target');
    $action = Req::post('action');
    $d      = (array)Req::post('data');
    
    $_bidBatch =& $_SESSION['bid_batch'];
    
    if ($action == 'set') {
        if (empty($d['bid_machine_id'])) {
            throw new Exception('商品情報がありません');
        } else if (!empty($_bidBatch[$d['bid_machine_id']])) {
            throw new Exception('既に一括問い合わせに登録されています');
        }
        $_bidBatch[$d['bid_machine_id']] = 1;
        
        // ロギング
        $lModel = new Actionlog();
        $lModel->set('machine', 'bid_batch', $d['bid_machine_id']);
    } else if ($action == "delete") {
        if (empty($d['bid_machine_id'])) {
            throw new Exception('商品情報がありません');
        }
        unset($_bidBatch[$d['bid_machine_id']]);
    } else {
        throw new Exception('一括問い合わせが操作できませんでした');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
}
