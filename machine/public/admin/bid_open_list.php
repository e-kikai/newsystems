<?php

/**
 * 入札会開催一覧ページ(過去のWeb入札会一覧)表示
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2013/05/25
 */
/// 設定ファイル読み込み ///
require_once '../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('member');

    $cModel      = new BidOpen();
    $bidOpenList = $cModel->getList();

    /// 会社情報を取得 ///
    $cModel  = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) {
        throw new Exception('会社情報が取得できませんでした');
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'Web入札会一覧',
        'pankuzu'         => array('/admin/' => '会員ページ'),
        'pageDescription' => '過去のWeb入札会の一覧です。タイトルをクリックすると、過去の入札会の履歴を表示できます',
        'bidOpenList'     => $bidOpenList,
        'rank'            => $company['rank'],
    ))->display("admin/bid_open_list.tpl");
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'Web入札会一覧',
        'pankuzu'   => array('/admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
