<?php
/**
 * サムネイル一括作成 test
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    $imgCmd = '/usr/bin/convert -resize 120x90 ';
    //// パラメータ取得 ////
    $res = $_db->fetchAll("SELECT m.top_img FROM machines m WHERE m.deleted_at IS NULL AND m.top_img != '';");
    
    foreach ($res as $m) {
        // サムネイ画像作成
        $fPath = $_conf->htdocs_path . '/media/machine/' .$m['top_img'];
        $tPath = $_conf->htdocs_path . '/media/machine/' .'thumb_' . $m['top_img'];
        
        // すでにサムネイ画像がある場合は、処理をスキップ
        if (file_exists($tPath)) {
            echo '  already create ' . $tPath . '<br />';
            continue;
        } else if (!file_exists($fPath)) {
            // 画像ファイルが存在していない場合もスキップ
            echo '  no img file ' . $fPath . '<br />';
            continue;
        }
        
        // サムネイル生成
        $cmd = $imgCmd . ' ' . escapeshellcmd($fPath). ' ' . escapeshellcmd($tPath);
        echo $cmd .  '<br />';
        exec($cmd);

    }
} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
