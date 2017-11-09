<?php
/**
 * チラシメール操作メニュー
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2017/10/16
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    $user = Auth::isAuth('member');

    $id = Req::query('id');
    $r  = Req::query('r');

    if (empty($id)) { throw new Exception("チラシメールが選択されていません"); }

    //// チラシメール一覧を取得 ////
    $fModel = new Flyer();
    $flyer = $fModel->get($id);

    if ($flyer['company_id'] != $_user['company_id']) {
        throw new Exception("これはあなたのチラシメールではありません id:{$id}");
    }

    $campaign = $fModel->apiGetCampaign($flyer, $_conf);

    $message = "";
    if (!empty($r)) {
        if ($r == "form") {
            $message = "テストメールの内容を保存しました";
        } else if ($r == 'test') {
            $message = "テストメールを送信しました";
        }
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメール 操作メニュー',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧'
        ),
        'flyer'     => $flyer,
        'campaign'  => $campaign,
        'message'   => $message,
    ))->display("admin/flyer_menu.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメール 操作メニュー',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
