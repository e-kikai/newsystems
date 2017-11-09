<?php
/**
 * 自社サイト機械詳細ページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/04/11
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// パラメータ取得 ////
    $machineId = Req::query('m');
    
    //// URLから自社サイト情報の取得 ////
    $companysiteTable = new Companysites();
    $site             = $companysiteTable->getByUrl($_SERVER['REQUEST_URI']);
    
    //// このページは在庫機械のページなので、A会員のみ表示 ////
    if ($site['rank'] < Companies::RANK_A) { throw new Exception('在庫機械のページはありません'); }
    
    //// 機械情報を取得 ////
    $mModel = new Machine();
    $machine = $mModel->get($machineId);
    
    //// リファラ処理 ////
    // デフォルト
    $backUri = 'search.php?l=' . $machine['large_genre_id'];
    $backTitle = $machine['large_genre'];
    
    // ロギング
    $lModel = new Actionlog();
    $lModel->set('companysite', 'machine_detail', $machineId);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pankuzu'   => false,
        'pageTitle' => "{$machine['name']} {$machine['maker']} {$machine['model']} 機械詳細 - " . $site['company'],
        'site'      => $site,
        
        'machine'   => $machine,
        'backUri'   => $backUri,
    ))->display('companysite/machine_detail.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
