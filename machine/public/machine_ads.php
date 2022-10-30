<?php
/**
 * 相互広告ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2019/09/03
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    $orkeyword = Req::query('keywords');
    $res       = Req::query('res');
    $count     = 5;

    $bidOpen   = null;

    /// 入札会開催情報の取得 ///
    $boModel     = new BidOpen();
    $bidOpenList = $boModel->getList(array('isdisplay' => true));

    if (!empty($bidOpenList)) {
        $bidOpen = $bidOpenList[0];

        /// 入札会出品商品を取得 ///
        $bmModel = new BidMachine();
        $q = array(
            'bid_open_id' => $bidOpen["id"],
            'limit'       => Req::query('limit', $count),
            'order'       => 'random',
        );
        $machineList = $bmModel->getList($q);
    } else {
        /// 新着情報を取得 ///
        $mModel = new Machine();
        $q = array(
            'orkeyword' => $orkeyword,
            'limit'     => Req::query('limit', $count),
            'sort'      => 'img_random',
            'onlyList'  => 1,
        );
        $result = $mModel->search($q);
        $machineList = $result['machineList'];
        if ($count > count($machineList)) {
          $q = array(
              'limit'     => Req::query('limit', $count - count($machineList)),
              'is_img'    => 1,
              'sort'      => 'random',
              'onlyList'  => 1,
          );
          $result = $mModel->search($q);
          $machineList = array_merge($machineList, $result['machineList']);
        }
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'bidOpen'     => $bidOpen,
        'machineList' => $machineList,
        'res'         => $res,
    ))->display('machine_ads.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '新着中古機械一覧',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
