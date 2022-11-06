<?php

/**
 * 会員区分と利用サービスについてページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2014/06/10
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '会員区分と利用サービスについて'
    ))->display('help_rank.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
