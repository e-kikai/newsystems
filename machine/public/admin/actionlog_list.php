<?php

/**
 * 電子カタログアクションログ表示ページ表示
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
        'logList'   => $logList,
        // 'pager'   => $paginator->getPages(),
    ))->display("admin/actionlog_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
