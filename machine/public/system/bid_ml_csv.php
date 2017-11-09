<?php
/**
 * 入札会商品リスト(会員用)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $target    = Req::query('t');

    $bidMachineIds = array();

    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('margin', 'bid', 'carryout', 'after'))) {
        $e = "この入札会は現在、入札会の期間ではありません\n";
        $e.= "下見期間 : " . date('Y/m/d', strtotime($bidOpen['preview_start_date'])) . " ～ " . date('m/d', strtotime($bidOpen['preview_end_date']));
    } else if (in_array($bidOpen['status'], array('after'))) {
        $e = $bidOpen['title'] . "は、終了しました";
    }

    if (!empty($e)) { throw new Exception($e); }

    //// 出品商品情報一覧を取得 ////
    if ($target == "machine") {
        $filename = $bidOpenId . '_ml_machines.csv';
        $header   = array(
          "id"             => "machine_id",
          "name"           => "name",
          "maker_master"   => 'maker',
          "model2"         => 'model',
          "year"           => 'year',
          "xl_genre_id"    => 'xl_genre_id',
          "large_genre_id" => 'large_genre_id',
          "genre_id"       => 'genre_id',
          "region"         => 'region',
          'addr1'          => 'addr1'
        );
        $bmModel  = new BidMachine();
        $datas    = $bmModel->getList(array('bid_open_id' => $bidOpenId,));

    } else if ($target == "user") {
        $filename = $bidOpenId . '_ml_users.csv';
        $header   = array(
            "id"           => 'user_id',
            "tracking_tag" => 'tracking_tag',
            'ip'           => 'ip',
            "created_at"   => 'created_at'
        );
        $tuModel  = new TrackingUser();
        $datas    = $tuModel->getList();

    } else {
        $filename = $bidOpenId . '_ml_ratings.csv';
        $header   = array(
            "user_id"    => 'user_id',
            "machine_id" => 'machine_id',
            "rating"     => 'rating',
        );
        $tlModel  = new TrackingLog();
        // $count    = $tlModel->getRatingCount($bidOpenId);
        $trackingUserIds = $tlModel->getRatingTrackingUserIds($bidOpenId);
        $trackingUserCount = count($trackingUserIds);

        $datas   = array();

        for ($i = 0; $i < $trackingUserCount; $i++) {
            $ratings = array();
            $logs    = $tlModel->getRatingList($bidOpenId, $trackingUserIds[$i]);

            foreach ($logs as $key => $l) {
                if (preg_match('/^\/bid_detail\.php/', $l['url'])) {
                    if (!ctype_digit($l['bid_machine_ids'])) { continue; }

                    if (empty($ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['visit'])) {
                        $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['visit']    = 0;
                        $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['interval'] = 0;
                    }
                    $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['visit']    += 1;
                    $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['interval'] += $l['interval'];

                    if (preg_match('/\&rec\=/', $l['url'])) {
                        $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['recomend'] = true;
                    }

                } else if (preg_match('/^\/bid_list\.php/', $l['url'])) {
                    $ids = explode(',', $l['bid_machine_ids']);
                    foreach ($ids as $id) {
                        if (!ctype_digit($id)) { continue; }

                        if (empty($ratings[$l['tracking_user_id']][$id]['visit'])) {
                            $ratings[$l['tracking_user_id']][$id]['visit']    = 0;
                            $ratings[$l['tracking_user_id']][$id]['interval'] = 0;
                        }
                        $ratings[$l['tracking_user_id']][$id]['visit']    += 1 * 0.1;
                        $ratings[$l['tracking_user_id']][$id]['interval'] += $l['interval'] * 0.1;
                    }
                } else if (preg_match('/^\/ajax\/contact\.php/', $l['url'])) {
                    if (!ctype_digit($l['bid_machine_ids'])) { continue; }

                    $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['contact'] = true;
                } else if (preg_match('/^\/bid_detail_tel\.php/', $l['url'])) {
                    if (!ctype_digit($l['bid_machine_ids'])) { continue; }

                    $ratings[$l['tracking_user_id']][$l['bid_machine_ids']]['tel_contact'] = true;
                }
            }

            //// レーティング計算 ////
            foreach ($ratings as $trackingUserId => $bm) {
                foreach ($bm as $bidMachineId => $d) {

                    if ($bidMachineId == 7943 || $bidMachineId == 7985) { continue; }

                    $contactRate    = !empty($d['contact']) ? 5 : 0;
                    $telContactRate = !empty($d['tel_contact']) ? 5 : 0;

                    if      (empty($d['visit'])) { $visitRate = 0; }
                    else if ($d['visit'] <= 2)   { $visitRate = 1; }
                    else if ($d['visit'] <= 5)   { $visitRate = 2; }
                    else if ($d['visit'] <= 8)   { $visitRate = 3; }
                    else if ($d['visit'] <= 10)  { $visitRate = 4; }
                    else                         { $visitRate = 5; }

                    if      (empty($d['interval'])) { $intervalRate = 0; }
                    else if ($d['interval'] <= 60)  { $intervalRate = 1; }
                    else if ($d['interval'] <= 120) { $intervalRate = 2; }
                    else if ($d['interval'] <= 180) { $intervalRate = 3; }
                    else if ($d['interval'] <= 240) { $intervalRate = 4; }
                    else                            { $intervalRate = 5; }

                    // $contactRate    = (!empty($d['contact']) || !empty($d['tel_contact'])) ? 10 : 0;
                    // $telContactRate = 0;
                    //
                    // if      (empty($d['visit'])) { $visitRate = 0; }
                    // else if ($d['visit'] <= 1)   { $visitRate = 0; }
                    // else if ($d['visit'] <= 5)   { $visitRate = 1; }
                    // else if ($d['visit'] <= 8)   { $visitRate = 2; }
                    // else if ($d['visit'] <= 10)  { $visitRate = 3; }
                    // else if ($d['visit'] <= 12)  { $visitRate = 4; }
                    // else                         { $visitRate = 5; }
                    //
                    // if      (empty($d['interval'])) { $intervalRate = 0; }
                    // else if ($d['interval'] <= 5)   { $intervalRate = 0; }
                    // else if ($d['interval'] <= 70) { $intervalRate = 1; }
                    // else if ($d['interval'] <= 130) { $intervalRate = 2; }
                    // else if ($d['interval'] <= 190) { $intervalRate = 3; }
                    // else if ($d['interval'] <= 250) { $intervalRate = 4; }
                    // else                            { $intervalRate = 5; }

                    $recomendRate   = (!empty($d['recomend'])) ? 5 : 0;

                    $rate = $contactRate + $telContactRate + $visitRate + $intervalRate + $recomendRate;

                    if ($rate > 0) {
                        $datas[] = array(
                            "user_id"    => $trackingUserId,
                            "machine_id" => $bidMachineId,
                            'rating'     => $rate,
                        );
                    }
                }
            }
        }


    }

    B::downloadCsvFile($header, $datas, $filename);
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
