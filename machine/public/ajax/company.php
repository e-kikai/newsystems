<?php
/**
 * AJAXで問い合わせ処理ほか
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
    // Auth::isAuth('machine');
    
    $action = Req::query('action');
    $target = Req::query('target');
    $data   = Req::query('data');
    
    if ($action == 'getCompanyList') {
        // 問い合わせ処理
        $cModel = new Company();
        $res = $cModel->getList(array('root_id' => $data['root_id']));
    } else {
        throw new Exception('問い合わせができませんでした');
    }
    
    echo json_encode($res);
} catch (Exception $e) {
    echo $e->getMessage();
}
