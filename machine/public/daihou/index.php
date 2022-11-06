<?php

/**
 * 会社情報ページ
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
  $newlimit  = 8;

  /// 会社情報を取得 ///
  $companyTable = new Companies();
  $company      = $companyTable->get($companyId);

  /// 新着商品を取得 ///
  $mModel         = new Machine();
  $newMachineList = $mModel->getList(array('company_id' => $companyId, 'sort' => 'created_at', 'limit' => $newlimit));

  /// お知らせを取得 ///
  $diTable = new DInfo();
  $diList  = $diTable->getList($companyId, 5);

  /// 表示変数アサイン ///
  $_smarty->assign(array(
    // 'pageTitle'   => $company['company'] . ' トップページ',
    'company'     => $company,
    // 'companysite' => $companysite,
    'newMachineList' => $newMachineList,

    'diList'     => $diList,
  ))->display('daihou/index.tpl');
} catch (Exception $e) {
  /// 表示変数アサイン ///
  $_smarty->assign(array(
    'pageTitle'   => $company['company'] . ' トップページ',
    'company'     => $company,
    'errorMes'  => $e->getMessage()
  ))->display('error.tpl');
}
