<?php

/**
 * 出品キャンセルフォーム
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/04
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('member');

    /// 変数を取得 ///
    $machine_id  = Req::query('m');

    if (empty($machine_id)) {
        throw new Exception('商品情報が取得出来ません');
    }

    /// 入札会情報・入札商品情報を取得 ///
    $bmModel = new BidMachine();
    $machine = $bmModel->get($machine_id);

    $boModel  = new BidOpen();
    $bid_open = $boModel->get($machine['bid_open_id']);

    // 出品期間のチェック
    $e = '';
    if (empty($bid_open)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (!in_array($bid_open['status'], array('margin', 'bid'))) {
        $e = "この入札会は現在、下見・入札期間ではありません。\n";

        $start = date('Y/m/d H:i', strtotime($bid_open['bid_start_date']));
        $end   = date('m/d H:i', strtotime($bid_open['bid_end_date']));
        $e .= "入札期間 : ${start} ～ ${end}";
    }

    if (!empty($e)) {
        throw new Exception($e);
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   =>  "出品キャンセル",
        'pankuzu'     => array(
            '/admin/'                                                 => '会員ページ',
            "/admin/bid_machine_list.php?o={$machine['bid_open_id']}" => "{$bid_open['title']} : 出品商品一覧"
        ),
        'machine_id'  => $machine_id,
        'bid_open_id' => $machine['bid_open_id'],
        'bid_open'    => $bid_open,
        'machine'     => $machine,
    ))->display("admin/bid_machine_cancel_form.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => '出品キャンセル',
        'pankuzu'   => array(
            '/admin/'                                                 => '会員ページ',
            "/admin/bid_machine_list.php?o={$machine['bid_open_id']}" => "{$bid_open['title']} : 出品商品一覧"
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
