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
    //// 認証 ////
    Auth::isAuth('machine');
    
    $machineId = Req::query('m');
    
    //// 機械情報を取得 ////
    $mModel  = new Machine();
    $machine = $mModel->get($machineId);

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
    $sameMachineList  = $mModel->getSameList($machineId);
    
    // これを見た人の機械の取得
    $logMachineList   = $mModel->getLogList($machineId);
    
    // 最近見た機械
    // $IPLogMachineList = $mModel->getIPLogList();
    
    //// 会社情報を取得 ////
    $cModel  = new Company();
    $company = $cModel->get($machine['company_id']);
    
    //// メーカー情報取得 ////
    // $maModel = new Maker();
    // $makers  = $maModel->get($machine['maker']);
    
    //// リファラ処理 ////
    // デフォルト
    // $backUri   = 'search.php?l=' . $machine['large_genre_id'];
    // $backTitle = $machine['large_genre'];
    
    /*
    if (!empty($_SERVER['HTTP_REFERER'])) {
        $ref = urldecode($_SERVER['HTTP_REFERER']);
        
        if (strstr($ref, 'search.php')) {
            $backUri   = $ref;
            if (substr_count($ref, 'l[]=') == 1 || substr_count($ref, 'l=') == 1) {
                $backTitle = $machine['large_genre'];
            } else if (substr_count($ref, 'c[]=') == 1 || substr_count($ref, 'c=') == 1) {
                $backTitle = $machine['company'];
            } else {
                $backTitle = '検索結果';
            }
        } elseif (strstr($ref, 'news.php')) {
            $backUri   = $ref;
            $backTitle = '新着情報'; 
        } elseif (strstr($ref, 'mylist.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(在庫機械)'; 
        }
    }
    */
    
    //// 入札会情報を取得 ////
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

    // ロギング
    $lModel = new Actionlog();
    $lModel->set('machine', 'machine_detail', $machineId);
    
    // ページタイトルの整形
    $title = $machine['name'];
    if (!empty($machine['maker'])) { $title.= ' ' . $machine['maker']; }
    if (!empty($machine['model'])) { $title.= ' ' . $machine['model']; }
    
    /*
    $pageTitle = $title . '(' . $machine['company'];
    if (!empty($machine['no'])) { $pageTitle.= ':' . $machine['no']; }
    $pageTitle.= ')';
    
    $h1Title = $title . ' :: 機械詳細';
    */

    $pageTitle = $title;

    // 画像altの整形
    $alt = $machine['name'];
    /*
    if (!empty($machine['hint']) && $machine['name'] != $machine['hint']) { $alt.= '(' . $machine['hint'] . ')'; }
    if (!empty($machine['maker'])) { $alt.= ' ' . $machine['maker']; }
    if (!empty($makers) && $machine['maker'] != $makers['makers']) { $alt.= '(' . $makers['makers'] . ')'; }
    if (!empty($machine['model'])) { $alt.= ' ' . $machine['model']; }
    $alt.= ' ' . $machine['company'];
    if (!empty($machine['addr1'])) { $alt.= '(' . $machine['addr1'] . ')'; }
    */

    // 現在既に登録されている機械IDを取得
    $bmModel       = new BidMachine();
    $bidMachineIds = $bmModel->getMachineIds(array('machine_id' => $machine['id']));
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'        => $pageTitle,
        // 'h1Title'          => $h1Title,
        
        // 'pankuzu'         => array($backUri => $backTitle),
        'pankuzu'          => array(
            'search.php?l=' . $machine['large_genre_id']  => $machine['large_genre'],
            'search.php?g=' . $machine['genre_id']  => $machine['genre'],
        ),
        'machine'          => $machine,
        'others'           => $others,
        'company'          => $company,
        // 'backUri'          => $backUri,
        // 'os'               => $os,
        'alt'              => $alt,
        
        'bidMachineIds'    => $bidMachineIds,
        
        'sameMachineList'  => $sameMachineList,
        'logMachineList'   => $logMachineList,

        'bidOpenList'      => $bidOpenList,
        // 'IPLogMachineList' => $IPLogMachineList,
    ))->display('machine_detail.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '機械詳細',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
