<?php

/**
 * 機械詳細ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    $machineId = Req::query('m');

    /// 機械情報を取得 ///
    $mModel  = new Machine();
    // $machine = $mModel->get($machineId);
    $machine = $mModel->get_all($machineId); // 削除分も含む

    if (empty($machine)) {
        throw new Exception("この機械は売却されました\n
            お手数ですが、再度マシンライフでお探しの機械を検索して下さい#topppage");
    } else if (!empty($machine['view_option']) &&  $machine['view_option'] == 1) {
        throw new Exception("この機械は現在表示させることができません\n
            お手数ですが、再度マシンライフでお探しの機械を検索して下さい#topppage");
    }

    // $os      = $mModel->getOtherSpecs();
    $others  = $mModel->makerOthers($machine['spec_labels'], $machine['others']);

    // 同じ機械の取得
    $sameMachineList = $mModel->getSameList($machineId);
    // $sameMachineList   = [];

    // これを見た人の機械の取得
    // $logMachineList = $mModel->getLogList($machineId);
    $logMachineList   = [];

    /// 会社情報を取得 ///
    $cModel  = new Company();
    $company = $cModel->get($machine['company_id']);

    /// 入札会情報を取得 ///
    $boModel = new BidOpen();
    $bmModel = new BidMachine();

    $bidOpenList = $boModel->getList(array('isdisplay' => true));

    if (!empty($machine['large_genre_id'])) {
        foreach ($bidOpenList as $key => $bo) {
            $bidOpenList[$key]['machines'] = $bmModel->getList(array(
                'bid_open_id'    => $bo['id'],
                'large_genre_id' => $machine['large_genre_id']
            ));

            $bidOpenList[$key]['large_genre'] = $machine['large_genre'];
            $bidOpenList[$key]['large_genre_id'] = $machine['large_genre_id'];
        }
    }

    // 画像特徴ベクトル検索
    $nmrModel     = new MachineNitamono();
    $nitamonoList = $nmrModel->getNitamonoList($machineId);

    // ロギング
    $lModel = new Actionlog();
    $lModel->set('machine', 'machine_detail', $machineId);

    // ページタイトルの整形
    $title = $machine['name'];
    if (!empty($machine['maker'])) {
        $title .= ' ' . $machine['maker'];
    }
    if (!empty($machine['model'])) {
        $title .= ' ' . $machine['model'];
    }

    $pageTitle = $title;

    // 画像altの整形
    $alt = $machine['name'];

    // 現在既に登録されている機械IDを取得
    $bmModel       = new BidMachine();
    $bidMachineIds = $bmModel->getMachineIds(array('machine_id' => $machine['id']));

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'        => $pageTitle,
        'pankuzu'          => array(
            'search.php?l=' . $machine['large_genre_id'] => $machine['large_genre'],
            'search.php?g=' . $machine['genre_id']       => $machine['genre'],
        ),
        'machine'         => $machine,
        'others'          => $others,
        'company'         => $company,
        'alt'             => $alt,
        'bidMachineIds'   => $bidMachineIds,
        'sameMachineList' => $sameMachineList,
        'logMachineList'  => $logMachineList,
        'nitamonoList'    => $nitamonoList,
        'bidOpenList'     => $bidOpenList,
    ))->display('machine_detail.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '機械詳細',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
