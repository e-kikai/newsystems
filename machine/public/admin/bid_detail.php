<?php
/**
 * 入札会商品詳細(入札フォーム)
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/22
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');
    
    //// 変数を取得 ////
    $machineId = Req::query('m');
    $bidOpenId = Req::query('o');
    
    if (empty($bidOpenId) && empty($machineId)) {
        throw new Exception('入札会情報、商品情報が取得出来ません');
    }
    
    //// 入札商品情報を取得 ////
    $bmModel = new BidMachine();
    $machine = $bmModel->get($machineId);
    
    $mModel = new Machine();
    $others  = $mModel->makerOthers($machine['spec_labels'], $machine['others']);
    
    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($machine['bid_open_id']);
    
    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bidOpen['status'], array('margin', 'bid', 'carryout', 'after'))) {
        $e = "この入札会は現在、入札会の期間ではありません\n";
        $e.= "入札期間 : " . date('Y/m/d H:i', strtotime($bidOpen['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['bid_end_date']));
    }
    
    if (!empty($e)) { throw new Exception($e); }
    
    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($machine['company_id']);
    
    //// メーカー情報取得 ////
    $maModel = new Maker();
    $makers = $maModel->get($machine['maker']);
    
    // 画像altの整形
    $alt = $machine['name'];
    if (!empty($machine['hint']) && $machine['name'] != $machine['hint']) { $alt.= '(' . $machine['hint'] . ')'; }
    if (!empty($machine['maker'])) { $alt.= ' ' . $machine['maker']; }
    if (!empty($makers) && $machine['maker'] != $makers['makers']) { $alt.= '(' . $makers['makers'] . ')'; }
    if (!empty($machine['model'])) { $alt.= ' ' . $machine['model']; }
    $alt.= ' ' . $machine['company'];
    if (!empty($machine['addr1'])) { $alt.= '(' . $machine['addr1'] . ')'; }

    if (in_array($bidOpen['status'], array('carryout', 'after'))) {
        // 落札結果を取得
        $result = $bmModel->getResultByBidMachineId($machineId);
        
        // 自社の入札情報を取得
        $resultCompany = $bmModel->getResultCompanyByBidMachineId($machineId, $_user['company_id']);
        
        $_smarty->assign(array(
            'result'        => $result,
            'resultCompany' => $resultCompany,
        ));
    }

    //// 次へ・前へリスト ////
    $prevMachine = null;
    $nextMachine = null;

    $bidMachineList = $bmModel->getList(array('bid_open_id' => $machine['bid_open_id']));

    foreach($bidMachineList as $key => $m) {
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
    
    $lModel = new Actionlog();
    $lModel->set('machine', 'admin_bid_detail', $machineId);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'        => $bidOpen['title'] . ' : 商品詳細',
        // 'pageDescription'  => '出品番号から、入札を行います',
        'pankuzu'          => array(
            '/admin/'                                          => '会員ページ',
            '/admin/bid_list.php?o=' . $machine['bid_open_id'] => '入札会商品リスト'
        ),
        'machineId'        => $machineId,
        'bidOpenId'        => $machine['bid_open_id'],
        'bidOpen'          => $bidOpen,
        'machine'          => $machine,
        'others'           => $others,
        'company'          => $company,
        'alt'              => $alt,

        'nextMachine'      => $nextMachine,
        'prevMachine'      => $prevMachine,
    ))->display("bid_detail.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'        => '入札',
        // 'pageDescription'  => '出品番号から、入札を行います',
        'pankuzu'          => array(
            '/admin/'                                          => '会員ページ',
            '/admin/bid_list.php?o=' . $machine['bid_open_id'] => ' 入札会商品リスト'
        ),
        'errorMes'        => $e->getMessage()
    ))->display('error.tpl');
}
