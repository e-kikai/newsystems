<?php
/**
 * アクションログ表示ページ表示
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
        'month'  => Req::query('monthYear') ? Req::query('monthYear') . '/' . Req::query('monthMonth') .'/01' : null,
    );
    
    $lModel = new Actionlog();
    $logList = $lModel->getList($q);
    $logCount = $lModel->getListCount($q);
    
    /*
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    
    $paginator = Zend_Paginator::factory(intval($count));
    $paginator->setCurrentPageNumber($page)
              ->setItemCountPerPage($limit);
    */
      
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'アクションログ',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'logList'   => $logList,
        't'         => $q['target'],
        'month'     => $q['month'],
        // 'pager'   => $paginator->getPages(),
    ))->display("system/actionlog_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

