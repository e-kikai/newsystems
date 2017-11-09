<?php
/**
 * チラシメールフォーム
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

    //// チラシメール一覧を取得 ////
    if ($id) {
        $fModel = new Flyer();
        $flyer = $fModel->get($id);
        if ($flyer['company_id'] != $_user['company_id']) {
            throw new Exception("これはあなたのチラシメールではありません id:{$id}");
        }
    } else {
        //// 会社情報を取得 ////
        $cModel = new Company();
        $company = $cModel->get($_user['company_id']);

        // 新規作成デフォルトを設定
        $flyer = array(
            'from_name'     => $company["company"],
            'from_mail'     => $company["contact_mail"],
            'design_button' => "詳しくはこちらをクリック",
        );
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメールフォーム',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧'
        ),
        'flyer'     => $flyer,
    ))->display("admin/flyer_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメールフォーム',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
