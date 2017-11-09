<?php
/**
 * 全機連主催 Web入札会開催日程ページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2014/03/24
 */
require_once '../lib-machine.php';

try {
    //// 入札会情報を取得 ////
    $bidOpenTable = new BidOpen();
    $bidOpenList  = $bidOpenTable->getList(array('islast' => true, 'order' => 'bid_end_date'));

    //// 入札会バナー情報を取得 ////
    $bModel      = new Bidinfo();
    $bidinfoList = $bModel->getList();

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'Web入札会 開催日程',
        'bidOpenList' => $bidOpenList,
        'bidinfoList' => $bidinfoList,
    ))->display("bid_schedule.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会 開催日程',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
