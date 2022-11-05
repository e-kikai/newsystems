<?php

/**
 * Web入札会利用規約ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4ß
 * @since 2013/05/27
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('member');

    /// 変数を取得 ///
    /*
    $bidOpenId = Req::query('o');

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
    }
    if (!empty($e)) { throw new Exception($e); }
    */

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '全機連Web入札会 運用規程',
        'pankuzu'   => array('/admin/' => '会員ページ',),
    ))->display("admin/bid_first_help.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => '全機連Web入札会 運用規程',
        'pankuzu'   => array('/admin/' => '会員ページ',),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
