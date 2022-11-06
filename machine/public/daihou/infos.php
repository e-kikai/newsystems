<?php

/**
 * お問い合わせページ
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
    $infoId    = Req::query('id');
    $companyId = 320;

    /// 会社情報を取得 ///
    $companyTable = new Companies();
    $company      = $companyTable->get($companyId);

    /// お知らせを取得 ///
    $diTable = new DInfo();
    $diList  = $diTable->getList($companyId);
    if (!empty($infoId)) {
        $dInfo = $diTable->get($companyId, $infoId);
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'お知らせ',
        'company'     => $company,
        // 'companysite' => $companysite,

        'diList'     => $diList,
        'dInfo'      => $dInfo,
    ))->display('daihou/infos.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'お知らせ',
        'company'     => $company,
        'errorMes'  => $e->getMessage()
    ))->display('daihou/error.tpl');
}
