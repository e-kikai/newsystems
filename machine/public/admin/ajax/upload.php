<?php

/**
 * ファイルアップロード処理(新版)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/05/21
 */
/// 設定ファイル読み込み ///
require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    $uModel = new User();
    if ($action == 'set') {
        // ファイルアップロード処理
        $f = new File();
        $f->setPath($_conf->tmp_path);
        $fList = $f->uploadFiles($_FILES['f'], 'f_' . date('YmdHis'), $data['type']);

        echo json_encode($fList);
        exit;
    } else {
        throw new Exception('処理がありません');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
