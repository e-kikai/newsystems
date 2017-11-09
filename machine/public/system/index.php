<?php
/**
 * 管理画面トップページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    //// パラメータ取得 ////
    
    // 入札会開催情報の取得
    $cModel = new BidOpen();
    $bidOpenList = $cModel->getList(array('isopen' => true));
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'マシンライフ 管理者ページ',
        'bidOpenList' => $bidOpenList,
    ))->display('system/index.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
