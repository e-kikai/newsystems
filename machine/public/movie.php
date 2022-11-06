<?php

/**
 * 動画一覧ページ(未設定)
 *
 * @author youhei
 */
require_once '../lib-machine.php';

try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '動画一覧'
    ))->display('help_blank.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
