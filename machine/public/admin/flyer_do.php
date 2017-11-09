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

    $flyer = array(
        'id'        => Req::post('id'),

        'title'     => Req::post('title'),
        'subject'   => Req::post('subject'),
        'from_name' => Req::post('from_name'),
        'from_mail' => Req::post('from_mail'),
        'status'    => Req::post('status'),
        'send_date' => !empty(Req::post('send_date')) ? (Req::post('send_date') . " " . Req::post('send_time')) : '',

        'design_main_text'   => Req::post('design_main_text'),
        'design_sub_text'    => Req::post('design_sub_text'),
        'design_button'      => Req::post('design_button'),
        'design_url'         => Req::post('design_url'),
        'design_bottom_text' => Req::post('design_bottom_text'),
    );

    /// 画像ファイルを実ディレクトリに移動 ////
    $f = new File();
    $flyer['design_top_img'] = $f->checkOne(
        Req::post('top_img'),
        Req::post('top_img_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/flyer',
        true
    );
    $flyer['design_img_01'] = $f->checkOne(
        Req::post('img_01'),
        Req::post('img_01_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/flyer',
        true
    );
    $flyer['design_img_02'] = $f->checkOne(
        Req::post('img_02'),
        Req::post('img_02_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/flyer',
        true
    );
    $flyer['design_img_03'] = $f->checkOne(
        Req::post('img_03'),
        Req::post('img_03_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/flyer',
        true
    );

    // データの保存
    $fModel = new Flyer();
    $fModel->set($flyer, $id, $_user['company_id']);

    $_SESSION['_temp']['message'][] = 'チラシメール情報を保存しました';

    /// mailchimpへキャンペーンの新規作成・変更 ///
    $resId = empty($id) ? $fModel->getLastId() : $id;
    $flyer  = $fModel->get($resId);

    if (empty($flyer['campaign'])) {
        // campaign新規作成
        $campaign = $fModel->apiCreateCampaign($flyer, $company, $_conf);

        // campaignIDの保存
        $fModel->setCampaign($campaign, $resId);
        $flyer['campaign'] = $campaign;
    } else {
        // campaign更新
        $campaign = $fModel->apiUpdateCampaign($flyer, $company, $_conf);
    }

    /// mailchimpへメールデザインを送信 ///
    $html = $_smarty->assign(array('flyer' => $flyer,))->fetch("admin/flyer_design_body.tpl");
    $campaign = $fModel->apiSetHtml($flyer, $html, $_conf);

    header('Location: /admin/flyer_menu.php?id=' . $resId . '&r=form');

    exit;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメールフォーム',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧'
        ),
        'flyer'     => $flyer,
        'errorMes'  => $e->getMessage()
    ))->display('admin/flyer_form.tpl');
}
