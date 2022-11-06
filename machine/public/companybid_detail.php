<?php

/**
 * 入札会商品詳細(入札フォーム)一般ユーザ用
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/22
 */
require_once '../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('machine');

    /// 変数を取得 ///
    $machineId = Req::query('m');
    if (empty($machineId)) {
        throw new Exception('会員入札会商品情報が指定されていません');
    }

    /// 入札商品情報を取得 ///
    $companybidMachineTable = new CompanybidMachines();
    $machine                = $companybidMachineTable->get($machineId);
    if (empty($machine)) {
        throw new Exception('会員入札会商品情報が取得出来ませんでした');
    }

    /// 入札会情報を取得 ///
    $companybidOpenTable = new CompanybidOpens();
    $companybidOpen      = $companybidOpenTable->get($machine['companybid_open_id']);
    if (empty($companybidOpen)) {
        throw new Exception('会員入札会情報が取得出来ませんでした');
    } else if (date('Y/m/d', strtotime($companybidOpen['bid_date'])) < date('Y/m/d')) {
        throw new Exception($companybidOpen['title'] . 'は、終了しました');
    }

    // セッションから会場情報を取得
    $siteName = !empty($_SESSION['bid_siteName']) ? $_SESSION['bid_siteName'] : '商品リスト';
    $siteUrl  = !empty($_SESSION['bid_siteUrl'])  ? $_SESSION['bid_siteUrl']  : '';

    // ページタイトルの整形
    $title = $machine['name'];
    if (!empty($machine['maker'])) {
        $title .= ' ' . $machine['maker'];
    }
    if (!empty($machine['model'])) {
        $title .= ' ' . $machine['model'];
    }

    $pageTitle    = $companybidOpen['title'] . '(出品番号:' . $machineId . ')' . $title;
    $h1Title      = $companybidOpen['title'] . ' 商品詳細 : ' . $title;
    $pankuzuTitle = '商品詳細';

    // ロギング
    /*
    $lModel = new Actionlog();
    $lModel->set('machine', 'bid_detail', $machineId);
    */

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'        => $pageTitle,
        'h1Title'          => $h1Title,
        'pankuzuTitle'     => $pankuzuTitle,
        'pankuzu'          => array(
            '/companybid_index.php?o=' . $machine['companybid_open_id']           => $companybidOpen['title'],
            '/companybid_list.php?o=' . $machine['companybid_open_id'] . $siteUrl => $siteName,
        ),

        'machineId'        => $machineId,
        'companybidOpenId' => $machine['companybid_open_id'],
        'companybidOpen'   => $companybidOpen,
        'machine'          => $machine,
    ))->display("companybid_detail.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '商品詳細',
        'pankuzu'   => array(
            '/companybid_index.php?o=' . $machine['companybid_open_id'] => $companybidOpen['title'],
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
