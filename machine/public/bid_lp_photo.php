<?php
/**
 * 入札会LPページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2014/06/18
 */
require_once '../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    
    // if (empty($bidOpenId)) { throw new Exception('入札会情報が取得出来ません'); }
    
    //// 入札会情報を取得 ////
    $bidOpenTable = new BidOpen();
    $bidOpenList  = $bidOpenTable->getList(array('islast' => true, 'order' => 'bid_end_date'));
    if (!empty($bidOpenId)) {
        $bidOpen = $bidOpenTable->get($bidOpenId);    
    } else {
        $bidOpen = $bidOpenList[0];
    }

    //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    $q = array(
        // 'bid_open_id' => $bidOpenId,
        'bid_open_id' => 'all',
        'limit'       => Req::query('limit', 40),
        'page'        => Req::query('page', 1),
        'order'       => 'random',
    );
    $bidMachineList = $bmModel->getList($q);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'Web入札会Webアルバム',
        // 'pageTitle'   => $bidOpen['title'] . 'LP',        
        'pankuzu'     => array(),
        'bidOpenId'   => $bidOpenId,
        'bidOpen'     => $bidOpen,
        'bidMachineList'     => $bidMachineList,
    ))->display("bid_lp_photo.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会Webアルバム',
        'pankuzu'   => array(),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
