<?php
/**
 * AJAXでお知らせ情報変更処理
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
    
    $cModel = new Catalog();
    $uploadPath    = $_conf->upload_path;
    $catalogPath   = $_conf->catalog_path;
    $thumbnailPath = $_conf->catalog_thumbnail_path;
    
    if ($action == 'setCsv') {
        if (empty($_SESSION['system_catalog_csv_data'])) {
            throw new Exception("カタログデータが取得できませんでした。\nCSVファイルを再アップロードしてください");
        }
        
        $_db->beginTransaction(); // トランザクション
        try {
            //// 機械登録部分 ////
            foreach ($_SESSION['system_catalog_csv_data'] as $c) {
                $id = !empty($c['id']) ? $c['id'] : null;
                
                //// PDFのコピー、サムネイル生成 ////
                // 新規登録で、PDFがなければ、処理を飛ばす
                if ($id == null && $c['exsist'] == false) { continue; }
                
                if (!empty($c['file']) && file_exists($uploadPath . $c['file'])) {
                    // PDFファイルの移動(上書き)
                    if( copy($uploadPath . $c['file'], $catalogPath . $c['file']) ) {
                        // unlink($uploadPath . $c['file']);
                    }
                    
                    // サムネイル生成
                    $cmd = '/usr/bin/convert -resize 320x320 ';
                    $cmd.= escapeshellcmd($catalogPath . $c['file'] . '[0] ');
                    $cmd.= escapeshellcmd($thumbnailPath . $c['thumbnail']);
                    exec($cmd);
                }
                
                // ジャンルの整形
                $genres = array();
                foreach($c['genres_temp'] as $g) {
                    $genres[] = $g['id'];
                }
                
                // 不要部分を削除
                unset($c['id'], $c['genres_temp'], $c['exsist']);
                
                // データの格納
                $c['deleted_at'] = null;
                $cModel->set($c, $genres, $id);
            }
            $_db->commit(); // コミット
        } catch (Exception $e) {
            $_db->rollBack();
            throw new Exception($e->getMessage());
        }
    } else {
        throw new Exception('処理がありません');
    }
    
    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
