<?php
/**
 * 入札会商品リスト(会員用)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/13
 */
require_once dirname(__FILE__) . '/../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');

    //// 変数を取得 ////
    $num = Req::query('num');

    //// 入札会開催情報の取得 ////
    $cModel      = new BidOpen();
    $bidOpenList = $cModel->getList(array('isopen' => true));

    $tbuTable = new TrackingBidResult();
    foreach ($bidOpenList as $bo) {
        if ($bo['status'] == 'bid') {
            $result = $tbuTable->setMLResults($_conf->machine_uri, $bo['id'], $num);
        }
    }
} catch (Exception $e) {
    //// エラー画面表示 ////
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '商品リスト',
        'pankuzu'   => array(
            '/bid_door.php?o=' . $bidOpenId => $bidOpen['title'],
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
