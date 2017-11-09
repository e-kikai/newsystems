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

    if (empty($id)) { throw new Exception("チラシメールが選択されていません"); }

    //// チラシメール一覧を取得 ////
    $fModel = new Flyer();
    $flyer = $fModel->get($id);

    if ($flyer['company_id'] != $_user['company_id']) {
        throw new Exception("これはあなたのチラシメールではありません id:{$id}");
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシサンプル',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧',
            '/admin/flyer_menu.php?id=' . $id  => '操作メニュー',
        ),
        'flyer'     => $flyer,
    ))->display("admin/flyer_design.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシサンプル',
        'pankuzu'   => array(
            '/admin/'               => '会員ページ',
            '/admin/flyer_list.php' => 'チラシメール一覧',
            '/admin/flyer_menu.php?id=' . $id  => '操作メニュー',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
