<?php
/**
 * Web入札会参加申し込みフォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/06/17
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $ref = Req::query('r');
    
    /*
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
    } else if (in_array($bidOpen['status'], array('carryout', 'after'))) {
        $e = $bidOpen['title'] . "は入札が終了いたしました";
    }
    if (!empty($e)) { throw new Exception($e); }
    */
    
    //// 都道府県一覧 ////
    $sModel = new State();
    $addr1List = $sModel->getList();
    
    // 選択用ジャンル一覧
    $gModel = new Genre();
    $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'Web入札会 参加申し込みフォーム',
        
        // 'bidOpenId'      => $bidOpenId,
        // 'bidOpen'        => $bidOpen,
        'addr1List'      => $addr1List,
        'largeGenreList' => $largeGenreList,
        
        'ref' => $ref,
    ))->display('help_bidlp_form.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会 参加申し込みフォーム',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
