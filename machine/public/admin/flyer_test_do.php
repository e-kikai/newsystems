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
    // データの保存
    $fModel = new Flyer();
    $flyer  = $fModel->get($id);
    $fModel->apiTest($flyer, $mail, $_conf);

    $_SESSION['_temp']['message'][] = 'テストメールを送信しました';

    header('Location: /admin/flyer_menu.php?id=' . $id . '&r=test');

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
    ))->display('admin/flyer_test.tpl');
}
