<?php
/**
 * 会社情報ページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    //// 変数を取得 ////
    $companyId = Req::query('c');
    
    //// 会社情報を取得 ////
    $companyTable = new Companies();
    $company      = $companyTable->get($companyId);
    
    //// リファラ処理 ////
    // デフォルト
    $backUri   = 'company_list.php';
    $backTitle = '会社一覧';

    $pankuzu   = array();
    
    if (!empty($_SERVER['HTTP_REFERER'])) {
        $ref = urldecode($_SERVER['HTTP_REFERER']);
        
        if (preg_match('/machine_detail.php\?m=([0-9]+)/', $ref, $res)) {
            //// 機械情報を取得 ////
            $mModel = new Machine();
            $m      = $mModel->get($res[1]);
            
            $pankuzu   = array('/search.php?l[]=' + $m['large_genre_id'] => $m['large_genre']);
            $backUri   = $ref;
            $backTitle = "{$m['name']} {$m['maker']} {$m['model']}";
        } else if (strstr($ref, 'search.php')) {
            $backUri   = $ref;
            $backTitle = '検索結果';
        } else if (strstr($ref, 'news.php')) {
            $backUri   = $ref;
            $backTitle = '新着情報'; 
        } else if (strstr($ref, 'mylist.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(在庫機械)'; 
        } else if (strstr($ref, 'mylist_company.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(会社)'; 
        }
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $company['company'] . ' 会社情報',
        'pankuzu'   => $pankuzu + array($backUri => $backTitle),
        'company'   => $company
    ))->display('company_detail.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '会社情報',
        'pankuzu'   => array('company_list.php' => '会社一覧'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
