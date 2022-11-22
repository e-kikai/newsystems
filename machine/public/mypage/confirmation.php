<?php

/**
 * 入札会登録確認処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/18
 */
require_once '../../lib-machine.php';

/// ログイン処理 ///
$auth = new MyAuth();

try {
    $id    = Req::query('id');
    $token = Req::query('t');

    $my_auth       = new MyAuth();

    // チェック処理
    $res = $my_auth->confirmation($id, $token);

    if ($res) {
        header('Location: /mypage/login.php?e=6');
    } else {
        header('Location: /mypage/login.php?e=7');
    }
} catch (Exception $e) {
    header('Location: /mypage/login.php?e=7');
}
exit;
