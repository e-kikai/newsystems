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
    $id = Req::post('id');
    if (empty($id)) { throw new Exception("チラシメールが選択されていません"); }

    //// チラシメールのコピー ////
    // 取得
    $fModel = new Flyer();
    $flyer = $fModel->get($id);

    $flyer['campaign'] = null;
    $flyer['id']       = null;
    $flyer['created_at'] = null;

    // データの保存
    $fModel->set($flyer, null, $_user['company_id']);

    /// mailchimpへキャンペーンの新規作成・変更 ///
    $resId = $fModel->getLastId();
    $flyer = $fModel->get($resId);

    // campaign新規作成
    $campaign = $fModel->apiCreateCampaign($flyer, $company, $_conf);

    // campaignIDの保存
    $fModel->setCampaign($campaign, $resId);
    $flyer['campaign'] = $campaign;

    /// mailchimpへメールデザインを送信 ///
    $html = $_smarty->assign(array('flyer' => $flyer,))->fetch("admin/flyer_design_body.tpl");
    $campaign = $fModel->apiSetHtml($flyer, $html, $_conf);

    header('Location: /admin/flyer_list.php?r=copy');

    exit;
} catch (Exception $e) {
    header('Location: /admin/flyer_list.php?r=copy_error');
}
