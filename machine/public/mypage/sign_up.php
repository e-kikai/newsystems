<?php

/**
 * ユーザ登録ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/09
 */
require_once '../../lib-machine.php';
try {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'マイページ - 入札会ユーザ登録',
        'pageDescription' => '入札会で入札を行うため、ユーザ登録を行います。必要な情報を入力して「登録する」をクリックしてください。',
        'pankuzu'     => array(
            '/mypage/login.php' => 'マイページ - ログイン',
        ),
    ))->display("mypage/sign_up.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => 'マイページ - 入札会ユーザ登録',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
