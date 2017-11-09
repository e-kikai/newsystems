<?php
/**
 * 支払・請求額シミュレータ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/18
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    
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
    }
    if (!empty($e)) { throw new Exception($e); }
    
    // 手数料テーブルの取得
    $bmModel = new BidMachine();
    $feeTable = $bmModel->getFeeTable();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $bidOpen['title'] . ' 支払・請求額シミュレータ',
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
            '/admin/bid_fee_help.php?o=' . $bidOpenId => '入札会手数料について',
        ),
        'bidOpenId' => $bidOpenId,
        'bidOpen'   => $bidOpen,
        
        'feeTable'  => $feeTable,
    ))->display("admin/bid_fee_sim.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '入札会手数料について',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
            '/admin/bid_fee_help.php?o=' . $bidOpenId => '支払・請求額シミュレータ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
