<?php
/**
 * 会員入札会ドアページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/16
 */
require_once '../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');
    
    //// 変数を取得 ////
    $companybidOpenId = Req::query('o');
    if (empty($companybidOpenId)) { throw new Exception('会員入札会情報が指定されていません'); }
    
    //// 入札会情報を取得 ////
    $companybidOpenTable = new CompanybidOpens();
    $companybidOpen      = $companybidOpenTable->get($companybidOpenId);
    if (empty($companybidOpen)) {
        throw new Exception('会員入札会情報が取得出来ませんでした');
    } else if (date('Y/m/d', strtotime($companybidOpen['bid_date'])) < date('Y/m/d')) {
        throw new Exception($companybidOpen['title'] . 'は、終了しました');
    }

    //// 出品商品情報一覧を取得 ////
    $companybidMachineTable = new CompanybidMachines();
    
    // すべて情報を取得
    $sq = array('companybid_open_id' => $companybidOpenId);
    $xlGenreList    = $companybidMachineTable->getXlGenreList($sq);
    $largeGenreList = $companybidMachineTable->getLargeGenreList($sq);
    $count          = $companybidMachineTable->getCount($sq);
    
    /*
    $temp  = $companybidMachineTable->getList($sq);
    foreach($temp as $t) {
        $imgFile = '1-' . $t["list_no"] . '.jpeg';
        if (file_exists('./media/companybid/' . $imgFile)) {
            $companybidMachineTable->set($t["companybid_machine_id"], array('imgs' => array($imgFile)));
        }
    }
    */

    // 会場ごとにジャンル情報を取得
    foreach($companybidOpen['preview_locations'] as $key => $lo) {
        $loq = array('companybid_open_id' => $companybidOpenId, 'location' => $lo['location']);

        $locationList[$key]['location']         = $lo['location'];
        $locationList[$key]['xl_genre_list']    = $companybidMachineTable->getXlGenreList($loq);
        $locationList[$key]['large_genre_list'] = $companybidMachineTable->getLargeGenreList($loq);
        $locationList[$key]['count']            = $companybidMachineTable->getCount($loq);
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'        => $companybidOpen['title'],
        'pankuzu'          => array(),
        'companybidOpenId' => $companybidOpenId,
        'companybidOpen'   => $companybidOpen,
        'xlGenreList'      => $xlGenreList,
        'largeGenreList'   => $largeGenreList,
        'count'            => $count,

        'locationList'     => $locationList,
    ))->display("companybid_index.tpl");
} catch (Exception $e) {
    header("HTTP/1.1 404 Not Found");
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $companybidOpen['title'],
        'pankuzu'   => array(),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
