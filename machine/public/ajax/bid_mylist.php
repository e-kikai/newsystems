<?php
/**
 * AJAXでマイリスト(入札会)へのセット
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2014/01/15
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    $target = Req::post('target');
    $action = Req::post('action');
    $d      = (array)Req::post('data');
    
    $_bid_mylist =& $_SESSION['bid_mylist'];
    
    if ($action == 'set') {
        if (empty($d['bid_machine_id'])) {
            throw new Exception('商品情報がありません');
        } else if (!empty($_bid_mylist[$d['bid_machine_id']])) {
            throw new Exception('既にマイリスト登録されています');
        }
        $_bid_mylist[$d['bid_machine_id']] = 1;
        
        // ロギング
        $lModel = new Actionlog();
        $lModel->set('machine', 'bid_mylist', $d['bid_machine_id']);
    } else if ($action == "delete") {
        if (empty($d['bid_machine_id'])) {
            throw new Exception('商品情報がありません');
        }
        unset($_bid_mylist[$d['bid_machine_id']]);
    } else if ($action == "setPreuser") {
        if (empty($d['mail'])) { throw new Exception('メールアドレスがありません'); }
        
        // 仮ユーザ情報の登録
        $puModel = new Preuser();
        $res = $puModel->set($d);
    } else {
        throw new Exception('マイリストが操作できませんでした');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
}
