<?php
/**
 * 入札会ヘルプ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/09/20
 */
require_once '../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    
    //// 入札会情報を取得 ////  
    $boModel = new BidOpen();
    if (!empty($bidOpenId)) {
        $bidOpen = $boModel->get($bidOpenId);
    }

    if (empty($bidOpen)) {
        $bidOpenList = $boModel->getList(array('isopen' => true));
        if (!empty($bidOpenList)) {
            $bidOpen   = $bidOpenList[0];
            $bidOpenId = $bidOpen['id'];
        }
    }
    
    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'Web入札会 よくある質問',
        'pankuzu'     => array(
            '/bid_door.php?o=' . $bidOpenId => $bidOpen['title'],
        ),
        'bidOpenId'   => $bidOpenId,
        'bidOpen'     => $bidOpen,
    ))->display('bid_help.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'Web入札会 FAQ',
        'errorMes' => $e->getMessage()
    ))->display('error.tpl');
}
