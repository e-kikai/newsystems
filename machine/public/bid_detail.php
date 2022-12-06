<?php

/**
 * 入札会商品詳細一般ユーザ用
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/05/22
 */
require_once '../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('machine');

    /// 変数を取得 ///
    $machineId = Req::query('m');
    if (empty($machineId)) {
        throw new Exception('入札会商品情報が取得出来ません');
    }

    /// 入札商品情報を取得 ///
    $bmModel = new BidMachine();
    $machine = $bmModel->get($machineId);

    // 同じ機械の取得
    $sameMachineList = $bmModel->getList(array(
        'bid_open_id' => $machine['bid_open_id'],
        'genre_id'    => $machine['genre_id']
    ));

    // 新 : ウォッチリスト情報取得
    $my_bid_watch_model = new MyBidWatch();
    $my_bid_watch = $my_bid_watch_model->get_by_user_machine($_my_user['id'], $machineId);

    // これを見た人の機械の取得
    $logMachineList   = $bmModel->getLogList($machineId);

    // 最近見た機械
    // $IPLogMachineList = $bmModel->getIPLogList($machine['bid_open_id']);

    $mModel  = new Machine();
    $others  = $mModel->makerOthers($machine['spec_labels'], $machine['others']);

    /// 入札会情報を取得 ///
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($machine['bid_open_id']);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('margin', 'bid', 'carryout', 'after'))) {
        $e = "この入札会は現在、入札会の期間ではありません\n";
        $e .= "下見期間 : " . date('Y/m/d', strtotime($bidOpen['preview_start_date'])) . " ～ " . date('m/d', strtotime($bidOpen['preview_end_date']));
    } else if (in_array($bidOpen['status'], array('after'))) {
        $e = $bidOpen['title'] . "は、終了しました";
    }
    if (!empty($e)) {
        throw new Exception($e);
    }

    /// 会社情報を取得 ///
    $cModel  = new Companies();
    $company = $cModel->get($machine['company_id']);

    /// メーカー情報取得 ///
    $maModel = new Maker();
    $makers  = $maModel->get($machine['maker']);

    // 画像altの整形
    $alt = $machine['name'];
    if (!empty($machine['hint']) && $machine['name'] != $machine['hint']) {
        $alt .= '(' . $machine['hint'] . ')';
    }
    if (!empty($machine['maker'])) {
        $alt .= ' ' . $machine['maker'];
    }
    if (!empty($makers) && $machine['maker'] != $makers['makers']) {
        $alt .= '(' . $makers['makers'] . ')';
    }
    if (!empty($machine['model'])) {
        $alt .= ' ' . $machine['model'];
    }
    $alt .= ' ' . $machine['company'];
    if (!empty($machine['addr1'])) {
        $alt .= '(' . $machine['addr1'] . ')';
    }

    // セッションから会場情報を取得
    $siteName = !empty($_SESSION['bid_siteName']) ? $_SESSION['bid_siteName'] : '商品リスト';
    $siteUrl  = !empty($_SESSION['bid_siteUrl'])  ? $_SESSION['bid_siteUrl']   : '';

    /// 次へ・前へリスト ///
    $prevMachine = null;
    $nextMachine = null;
    if (!empty($_SESSION['bid_siteQuery']) && !empty($_SESSION['bid_siteQuery']['bid_open_id'])) {
        $q = $_SESSION['bid_siteQuery'];
        unset($q['limit'], $q['list_no']);
    } else {
        $q = array('bid_open_id' => $machine['bid_open_id']);
    }

    $bidMachineList = $bmModel->getList($q);

    foreach ($bidMachineList as $key => $m) {
        if ($m['id'] == $machineId) {
            if (!empty($bidMachineList[$key - 1])) {
                $prevMachine = $bidMachineList[$key - 1];
            }

            if (!empty($bidMachineList[$key + 1])) {
                $nextMachine = $bidMachineList[$key + 1];
            }
            break;
        }
    }

    // ページタイトルの整形
    $title = $machine['name'];
    if (!empty($machine['maker'])) {
        $title .= ' ' . $machine['maker'];
    }
    if (!empty($machine['model'])) {
        $title .= ' ' . $machine['model'];
    }

    // $pageTitle = $bidOpen['title'] . ':' . $machineId . ' ' . $title;
    $pageTitle = $title . '｜' . $bidOpen['title'];

    $h1Title = $bidOpen['title'] . '｜' . $title;
    $pankuzuTitle = '商品詳細';

    // ロギング
    $lModel = new Actionlog();
    $lModel->set('machine', 'bid_detail', $machineId);

    // // トラッキングログ
    // $tlModel = new TrackingLog();
    // $tlModel->set(array(
    //     "bid_open_id"     => $bidOpen["id"],
    //     "bid_machine_ids" => $machine["id"],
    // ));

    // // ML結果
    // $tbuTable = new TrackingBidResult();
    // $recommends = $tbuTable->getRecommends($bidOpen["id"], 'machine', $machineId);

    /// 新 : 落札結果を取得 ///
    if (in_array($bidOpen['status'], array('carryout', 'after'))) {
        $my_bid_bid_model = new MyBidBid();

        $bids_count = $my_bid_bid_model->count_by_bid_machine_id($machineId);
        $bids_result = $my_bid_bid_model->results_by_bid_machine_id($machine['bid_open_id']);

        $_smarty->assign(array(
            "bids_count"  => !empty($bids_count[$machineId]) ? $bids_count[$machineId] : 0,
            "bids_result" => !empty($bids_result[$machineId]) ? $bids_result[$machineId] : [],
        ));
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        // 'pageTitle' => $bidOpen['title'] . ' : 商品詳細',
        'pageTitle'        => $pageTitle,
        'h1Title'          => $h1Title,
        'pankuzuTitle'     => $pankuzuTitle,

        'pankuzu'          => array(
            '/bid_door.php?o=' . $machine['bid_open_id'] => $bidOpen['title'],
            '/bid_list.php?o=' . $machine['bid_open_id'] . $siteUrl => $siteName,
        ),
        'machineId'        => $machineId,
        'bidOpenId'        => $machine['bid_open_id'],
        'bidOpen'          => $bidOpen,
        'machine'          => $machine,
        'others'           => $others,
        'company'          => $company,
        'alt'              => $alt,

        'sameMachineList'  => $sameMachineList,
        'logMachineList'   => $logMachineList,
        // 'IPLogMachineList' => $IPLogMachineList,

        'nextMachine'      => $nextMachine,
        'prevMachine'      => $prevMachine,

        // 'recommends'       => $recommends,

        "my_bid_watch"     => $my_bid_watch,
        // ))->display("bid_detail.tpl");
    ))->display("bid_detail_02.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '商品詳細',
        'pankuzu'   => array(
            '/bid_door.php?o=' . $machine['bid_open_id'] => $bidOpen['title'],
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
