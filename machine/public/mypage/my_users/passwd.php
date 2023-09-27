<?php

/**
 * パスワード変更フォームページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/27
 */

require_once '../../../lib-machine.php';
/// 認証 ///
MyAuth::is_auth();

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => "パスワード変更",
    'pageDescription' => '登録されているパスワードを変更します。',
    'pankuzu'         => array(
        '/mypage/' => 'マイページ',
    ),

    "data"     => $my_user,
))->display('mypage/my_users/passwd.tpl');
