<?php
/**
 * 入札会商品詳細(入札詳細)
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/22
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    //// 変数を取得 ////
    $machineId = Req::query('m');
    $bidOpenId = Req::query('o');
    
    if (empty($bidOpenId) && empty($machineId)) {
        throw new Exception('入札会情報、商品情報が取得出来ません');
    }
    
    //// 入札商品情報を取得 ////
    $bmModel = new BidMachine();
    $machine = $bmModel->get($machineId);
    
    // 入札詳細の取得
    $bbModel = new BidBid();
    $bidBidList = $bbModel->getByBidMachineId($machineId);
    
    $mModel = new Machine();
    $others  = $mModel->makerOthers($machine['spec_labels'], $machine['others']);
    
    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($machine['bid_open_id']);
    
    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
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
            'result'    => $result,
            'resultCompany' => $resultCompany,
            
            'pageTitle'        => $bidOpen['title'] . ' : 落札詳細',
            'pankuzu'          => array(
                '/system/' => '管理者ページ',
                '/system/bid_list.php?o=' . $machine['bid_open_id'] => '落札結果一覧'
            ),
        ));
    } else {
        $_smarty->assign(array(
            
            'pageTitle'        => $bidOpen['title'] . ' : 商品詳細',
            'pankuzu'          => array(
                '/system/' => '管理者ページ',
                '/system/bid_list.php?o=' . $machine['bid_open_id'] => '商品リスト'
            ),
        ));
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'machineId' => $machineId,
        'bidOpenId' => $machine['bid_open_id'],
        'bidOpen'   => $bidOpen,
        'machine'   => $machine,
        'bidBidList' => $bidBidList,
        'others'    => $others,
        'company'   => $company,
        'alt'       => $alt,
    ))->display("system/bid_detail.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'        => '入札',
        'pageDescription'  => '商品IDから、入札を行います',
        'pankuzu'          => array(
            '/system/' => '管理者ページ',
            '/system/bid_list.php?o=' . $machine['bid_open_id'] => '落札結果一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
