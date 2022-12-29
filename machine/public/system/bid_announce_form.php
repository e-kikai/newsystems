<?php

/**
 * Web入札会お知らせ変更フォーム
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/24
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('system');

    /// 変数を取得 ///
    $bidOpenId = Req::query('o');

    if (empty($bidOpenId)) throw new Exception('入札会情報が取得出来ません');

    /// 入札会情報を取得 ///
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) $e = '入札会情報が取得出来ませんでした';

    if (!empty($e)) throw new Exception($e);

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => $bidOpen['title'] . ' : お知らせ変更',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'bidOpenId' => $bidOpenId,
        'bidOpen'   => $bidOpen,
    ))->display("system/bid_announce_form.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => 'お知らせ変更',
        'pankuzu'   => array(
            '/system/' => '管理者ページ'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
