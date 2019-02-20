<?php
/**
 * 売り買いフォーム
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
    if (empty($id)) { throw new Exception("情報が指定されていません"); }
    //// 売り買い情報を取得 ////
    $fModel = new Urikai();
    $urikai = $fModel->get($id);

    if (empty($urikai)) { throw new Exception("売りたし買いたし情報がありません id:{$id}"); }

    $cModel  = new Company();
    $company = $cModel->get($urikai['company_id']);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '売りたし買いたし詳細',
        'pankuzu'   => array(
            '/admin/'                => '会員ページ',
        ),
        'urikai'    => $urikai,
        'company'   => $company,
    ))->display("admin/urikai_detail.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '売りたし買いたし詳細',
        'pankuzu'   => array(
            '/admin/'                => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
