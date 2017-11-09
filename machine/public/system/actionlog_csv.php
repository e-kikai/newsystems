<?php
/**
 * 電子カタログアクションログCSV出力
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/05/06
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    $q = array(
        'target' => Req::query('t'),
        'action' => Req::query('a'),
        'page'   => Req::query('p'),
        'limit'  => Req::query('limit'),
        // 'month'  => Req::query('monthYear') ? Req::query('monthYear') . '/' . Req::query('monthMonth') .'/01' : null,
        'month'  => Req::query('m'),
    );
    
    $lModel = new Actionlog();
    $logList = $lModel->getList($q);
    
    $filename = date('Ymd') . '_アクションログ.csv';
    
    // 文字コード変換
    mb_convert_variables("SJIS-WIN", "UTF-8,EUCJP-WIN,SJIS-WIN", $filename,  $logList);
    
    // 標準出力のバッファリング
    ob_start();
    
    // 標準出力オープン
    $fp = fopen('php://output', 'w');
    fputcsv($fp, array_keys($logList[0]));
    foreach($logList as &$line) {
        fputcsv($fp, $line);
    }

    fclose($fp);
    $csv = ob_get_contents();
    
    // バッファリングここまで
    ob_end_clean();
    
    // ファイルサイズ取得
    $fileLength = strlen($csv);

    // ダウンロード用のヘッダ出力
    header("Content-Disposition: attachment; filename=$filename");
    header("Content-Length:$fileLength");
    header("Content-Type: application/octet-stream");

    // CSVデータ出力
    echo $csv;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

