<?php

/**
 * ユーザマイページログインページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/07
 */
require_once '../../lib-machine.php';

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => 'マイページ - ログイン',
    'pageDescription' => '入札会で入札を行うためのユーザログインです。メールアドレスとパスワードを入力してください。'
))->display("mypage/login.tpl");
