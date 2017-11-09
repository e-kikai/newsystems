<?php
/**
 * チラシメール情報の追加・変更処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/08/18
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');

    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    //// 在庫機械情報を取得 ////
    $id   = Req::post('id');
    $mail = Req::post('mail');

    if (empty($id)) { throw new Exception("チラシメールが選択されていません"); }

    //// チラシメールを取得 ////
    $fModel = new Flyer();
    $flyer = $fModel->get($id);

    if ($flyer['company_id'] != $_user['company_id']) {
        throw new Exception("これはあなたのチラシメールではありません id:{$id}");
    }

    $campaign = $fModel->apiGetCampaign($flyer, $_conf);

    if ($campaign['emails_sent'] > 0) {
        header('Location: /admin/flyer_list.php?ir=sended');
        exit;
    }

    /// メール配信開始処理 ///
    $fModel->apiSend($flyer, $_conf);

    if (empty($flyer["send_date"])) {
        header('Location: /admin/flyer_list.php?r=send');
    } else {
        header('Location: /admin/flyer_list.php?r=schedule');
    }
    exit;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメール送信確認',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧',
            '/admin/flyer_menu.php?id=' . $id  => '操作メニュー',
        ),
        'flyer'     => $flyer,
        'campaign'  => $campaign,

        'errorMes'  => $e->getMessage()
    ))->display('admin/flyer_conf.tpl');
}
