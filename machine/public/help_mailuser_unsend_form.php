<?php
/**
 * 新着メール配信停止フォームページ
 * 
 * @author youhei
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '新着メール配信停止フォーム'
    ))->display('help_mailuser_unsend_form.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
