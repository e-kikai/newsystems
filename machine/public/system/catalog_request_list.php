<?php
/**
 * カタログリクエストログ表示ページ表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2014/02/10
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
    );
    
    $mModel = new Mail();
    $requestList = $mModel->getCatalogRequestList($q);
    
    /*
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    
    $paginator = Zend_Paginator::factory(intval($count));
    $paginator->setCurrentPageNumber($page)
              ->setItemCountPerPage($limit);
    */
      
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'カタログリクエストログ',
        'pankuzu'     => array('/system/' => '管理者ページ'),
        'requestList' => $requestList,
        't'           => $q['target'],
        // 'pager'   => $paginator->getPages(),
    ))->display("system/catalog_request_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

