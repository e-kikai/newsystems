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
    //// 認証 ////
    // Auth::isAuth('machine');

    //// 変数を取得 ////
    // $companyId = Req::query('c');
    $companyId = 320;

    //// 会社情報を取得 ////
    $companyTable = new Companies();
    $company      = $companyTable->get($companyId);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '会社情報',
        'company'     => $company,
        // 'companysite' => $companysite,
    ))->display('daihou/company.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
      'pageTitle'   => '会社情報',
      'company'     => $company,
      'errorMes'  => $e->getMessage()
      ))->display('daihou/error.tpl');
    }
