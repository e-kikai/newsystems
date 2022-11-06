<?php

/**
 * 在庫一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2021/11/29
 */
require_once '../../lib-machine.php';
try {
  /// 認証 ///
  // Auth::isAuth('machine');

  /// 変数を取得 ///
  // $companyId = Req::query('c');
  $companyId = 320;
  $machineId = Req::query('m');

  /// 会社情報を取得 ///
  $companyTable = new Companies();
  $company      = $companyTable->get($companyId);

  /// 商品情報 ///
  $mModel  = new Machine();
  $machine = $mModel->get($machineId);

  /// 表示変数アサイン ///
  $_smarty->assign(array(
    'pageTitle'   => "${machine['maker']} ${machine['name']} ${machine['model']}",
    'hideTitle'   => True,
    'company'     => $company,
    'machine'     => $machine,
    'hideFooterbanner' => True,
  ))->display('daihou/detail.tpl');
} catch (Exception $e) {
  /// 表示変数アサイン ///
  $_smarty->assign(array(
    'pageTitle'   => '在庫機械一覧',
    'company'     => $company,
    'hideFooterbanner' => True,
    'errorMes'  => $e->getMessage()
  ))->display('error.tpl');
}
