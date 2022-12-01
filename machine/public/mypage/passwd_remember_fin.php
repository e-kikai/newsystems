<?php

/**
 * ユーザ登録完了ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/18
 */
require_once '../../lib-machine.php';

$_smarty->assign(array(
    'pageTitle' => 'マイページ - パスワード再設定メール送信',
    'pankuzu'   => array(
        '/mypage/login.php'   => 'マイページ - ログイン',
    ),
))->display("mypage/passwd_remember_fin.tpl");
