<?php
/**
 * 入札会会社一覧
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/27
 */
require_once '../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');

    //// 変数を取得 ////
    $machineId = Req::query('m');
    $bidOpenId = Req::query('o');

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    //// 会社情報を取得 ////
    $cModel = new Company();
    $companyList = $cModel->getList(array('is_region' => 1));

    $addr1List = array();
    foreach($companyList as $c) {
        $addr1List[] = $c['addr1'];
    }
    $addr1List = array_unique($addr1List);

    //// 都道府県一覧を取得 ////
    $sModel = new State();
    $stateList = $sModel->getList();

    // パンくずリスト生成
    $pankuzu = array();
    if (!empty($bidOpenId)) {
        $pankuzu['/bid_door.php?o=' . $bidOpenId] = $bidOpen['title'];

        // セッションから会場情報を取得
        $siteName = !empty($_SESSION['bid_siteName']) ? $_SESSION['bid_siteName'] : '商品リスト';
        $siteUrl  = !empty($_SESSION['bid_siteUrl']) ? $_SESSION['bid_siteUrl'] : '';
        $pankuzu['/bid_list.php?o=' . $bidOpenId . $siteUrl] = $siteName;
    }

    if (!empty($machineId)) { $pankuzu['/bid_detail.php?m=' . $machineId] = '商品詳細'; }

    // トラッキングログ
    $tlModel = new TrackingLog();
    $tlModel->set(array("bid_open_id" => $bidOpen["id"]));
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '全機連会員一覧',
        // 'pageDescription' => '最寄りの全機連会員会社を地図、一覧よりお探しください',
        'pankuzu'     => $pankuzu,
        'companyList' => $companyList,

        'addr1List' => $addr1List,
        'stateList' => $stateList,

        'machineId'   => $machineId,
        'bidOpenId'   => $bidOpenId,
        'bidOpen'     => $bidOpen,
    ))->display('bid_company_list.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'Web入札会 全機連会員一覧',
        'errorMes' => $e->getMessage()
    ))->display('error.tpl');
}
