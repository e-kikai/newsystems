<?php

/**
 * メーカー一覧
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// メーカー情報を取得 ///
    $mModel = new Machine();
    $makerList = $mModel->getMakerList(array('notnull' => true, 'sort' => 'maker'));

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'メーカー一覧',
        'makerList' => $makerList
    ))->display('maker_list.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'メーカー一覧',
        'errorMes' => $e->getMessage()
    ))->display('error.tpl');
}
