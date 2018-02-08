<?php
/**
 * チラシメール情報の削除処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2017/11/09
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

    // データの削除
    $fModel = new Flyer();
    $fModel->deleteById($id, $company['id']);

    header('Location: /admin/flyer_list.php?r=delete');

    exit;
} catch (Exception $e) {
  echo $e->getMessage();
  exit;
    header('Location: /admin/flyer_list.php?r=delete_error');
}
