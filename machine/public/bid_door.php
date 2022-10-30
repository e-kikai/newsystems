<?php

/**
 * 入札会ドアページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/08/13
 */
require_once '../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('machine');

    /// 変数を取得 ///
    $bidOpenId = Req::query('o');
    $mail      = Req::query('mail');

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    /// 入札会情報を取得 ///
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

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

    /// 出品商品情報一覧を取得 ///
    $q = array('bid_open_id' => $bidOpenId,);
    $bmModel = new BidMachine();

    // 会場情報を取得
    $sq = array('bid_open_id' => $bidOpenId);
    $xlGenreList    = $bmModel->getXlGenreList($sq);
    $largeGenreList = $bmModel->getLargeGenreList($sq);
    // $stateList      = $bmModel->getStateList($sq);
    $regionList     = $bmModel->getRegionList($sq);
    $count          = $bmModel->getCount($sq);

    // 地域ごとにジャンル情報を取得
    foreach ($regionList as $key => $r) {
        $rq = array('bid_open_id' => $bidOpenId, 'region' => $r['region']);

        $regionList[$key]['xl_genre_list']    = $bmModel->getXlGenreList($rq);
        $regionList[$key]['large_genre_list'] = $bmModel->getLargeGenreList($rq);
    }

    // 最近見た機械
    $FaviMachineList = $bmModel->getFaviList($bidOpenId);

    // 最近見た機械
    $IPLogMachineList = $bmModel->getIPLogList($bidOpenId);

    // ロギング
    $lModel = new Actionlog();
    // $lModel->set('machine', 'bid_door', $bidOpenId);
    if ($mail) {
        $lModel->set('machine', 'bid_door', $bidOpenId, "mail_" . $mail);
    } else {
        $lModel->set('machine', 'bid_door', $bidOpenId);
    }

    /// トラッキングログ
    // $tlModel = new TrackingLog();
    // $tlModel->set(array("bid_open_id" => $bidOpen["id"]));

    // // ML結果
    // $trackingUserTable = new TrackingUser();
    // $trackingUser = $trackingUserTable->checkTrackingTag();

    // if (!empty($trackingUser)) {
    //     $tbuTable = new TrackingBidResult();
    //     $recommends = $tbuTable->getRecommends($bidOpenId, 'user', $trackingUser['id']);
    // }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'        => $bidOpen['title'] . ' 会場',
        // 'pageDescription' => '入札会商品リストです。入札、出品者へのお問い合せは、全機連会員を通して行なってください',
        'pankuzu'          => array(),
        'bidOpenId'        => $bidOpenId,
        'bidOpen'          => $bidOpen,
        'regionList'       => $regionList,
        // 'stateList'       => $stateList,
        'xlGenreList'      => $xlGenreList,
        'largeGenreList'   => $largeGenreList,
        'count'            => $count,

        'q'                => $q,

        'IPLogMachineList' => $IPLogMachineList,
        'FaviMachineList'  => $FaviMachineList,

        // 'recommends'       => $recommends,
    ))->display("bid_door.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => $bidOpen['title'],
        'pankuzu'   => array(),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
