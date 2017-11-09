<?php
/**
 * 広告バナー掲載のご案内情報ページ
 * 
 * @author youhei
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '広告バナー掲載のご案内'
    ))->display('help_banner.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
