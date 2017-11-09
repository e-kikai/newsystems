<?php
/**
 * CSV一括登録確認画面
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    // データをクリア
    unset($_SESSION['system_catalog_csv_data']);
    $nowCount    = 0;
    $createCount = 0;
    $updateCount = 0;
    
    $cModel = new Catalog();
    $uploadPath = $_conf->upload_path;
    
    /// CSVファイルを処理する ///
    if (empty($_FILES['csv'])) {
        throw new Exception('ファイルがアップロードされていません');
    } else if (!is_uploaded_file($_FILES['csv']['tmp_name'])) {
        throw new Exception('ファイルがありません');
    } else if (($f = B::file2utf($_FILES['csv']['tmp_name'])) === FALSE) {
        throw new Exception('ファイルが開けませんでした');
    }
    
    //// ジャンル情報 ////
    // ジャル一覧を取得とジャンル名をキーにするように整形
    $gModel = new Genre();
    $glTemp = $gModel->getList();
    $genreList = array();
    foreach ($glTemp as $g) { $genreList[mb_convert_kana($g['genre'], 'KVa')] = $g; }
    
    //// CSVファイル解析 ////
    $output = array();
    while (($data = fgetcsv($f, 10000, ',')) !== FALSE) {
        // インデックス行（1行目）はとばす
        if (!$data[0])         { continue; }
        if (B::f($data[0]) == 'uid') { continue; }
        
        // データの整形
        $temp      = array();
        $modelTemp = array();
        
        foreach ($data as $key => $v) {
            if ($key == 0) {
                if (!$v) { continue; }
                $temp['uid']       = $v;
                $temp['file']      = $temp['uid'] . '.pdf';
                $temp['thumbnail'] = $temp['uid'] . '.jpeg';
            } else if ($key == 1) {
                $temp['maker'] = $v;
            } else if ($key == 2) {
                $temp['maker_kana'] = $v;
            } else if ($key == 3) {
                $temp['genres_temp'] = array();
                $genreTemp = explode("\n", $v);
                foreach($genreTemp as $g) {
                    $gTemp = mb_convert_kana($g, 'KVa');
                    if (!empty($genreList[$gTemp])) { $temp['genres_temp'][] = $genreList[$gTemp]; }
                }
            } else if ($key == 4) {
                $temp['year'] = $v;
            } else if ($key == 5) {
                $temp['catalog_no'] = $v;
            } else {
                // それ以降は型式
                if(trim($v)) { $modelTemp[] = trim($v); }
            }
        }
        
        // 型式
        $temp['models']   = implode(', ', $modelTemp);
        $temp['keywords'] = preg_replace("/[^A-Z0-9\s]/", '', strtoupper(mb_convert_kana($temp['models'], 'KVa')));
        
        // PDFファイルがあるかどうか確認
        $temp['exsist'] = file_exists($uploadPath . $temp['file']) ? true : false;
        
        //// 新規・変更 ////
        // 現在登録されているか？
        $update = $cModel->getByUid($temp['uid']);
        
        if (!empty($update)) {
            // 更新
            $temp['id'] = $update['id'];
            $updateCount++;
        } else {
            // 新規
            $temp['id'] = null;
            $createCount++;
        }
        
        $output[] = $temp;
    }
    
    if (empty($output)) {
        throw new Exception('登録するカタログが取得できませんでした');
    }
    // データをSESSIONに格納
    $_SESSION['system_catalog_csv_data'] = $output;
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '電子カタログCSV一括登録・変更確認',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/catalog_csv_form.php' => '電子カタログCSV一括登録・変更',
        ),
        'catalogList' => $output,
        
        'createCount' => $createCount,
        'updateCount' => $updateCount,
    ))->display("system/catalog_csv_conf.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '電子カタログCSV一括登録・変更',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'companyList' => $companyList,
        'errorMes'  => $e->getMessage()
    ))->display("system/catalog_csv_form.tpl");
}
