<?php
/**
 * 新e-kikai被クロールページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.2
 * @since   2015/05/08
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('system');
    
    // タイムアウトを長く設定 
    set_time_limit(3000);
    
    //// パラメータ取得 ////
    $table     = Req::query('t');
    $companyId = Req::query('c');
    
    $res = null;
    if ($table == 'large_genres') {
        $xlGenreTable = new XlGenres();
        $res          = $xlGenreTable->getMachineList();
    } else if ($table == 'middle_genres') {
        $largeGenreTable = new LargeGenres();
        $res             = $largeGenreTable->getMachineList();
    } else if ($table == 'genres') {
        $genreTable = new Genres();
        $res        = $genreTable->getMachineList();
    } else if ($table == 'companies') {
        $companyTable = new Companies();
        $res          = $companyTable->get($companyId);
    } else if ($table == 'machines') {
        $machineTable = new Machine();
        $res          = $machineTable->getList(array('company_id' => $companyId, 'is_ospec' => true));
    }
    
    // 結果をJSONに変換して出力
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
