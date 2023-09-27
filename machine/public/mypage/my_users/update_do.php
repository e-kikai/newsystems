<?php

/**
 * ユーザ情報変更する処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/27
 */
require_once '../../../lib-machine.php';

try {
    $data = Req::post('data');

    $my_user_model = new MyUser();

    // ユーザ情報保存処理
    $res = $my_user_model->my_update(
        $data,
        $_my_user['id']
    );

    /// Mailchimpリスト登録 ///
    $my_user = $my_user_model->get($_my_user['id']);

    if ($my_user["mailuser_flag"] == 1) {
        $my_user_model->mailchimp_subscribe($my_user);
    } else {
        $my_user_model->mailchimp_unsubscribe($my_user);
    }

    $_SESSION["flash_notice"] = "ユーザ情報を変更しました。";

    header('Location: /mypage/');
    exit;
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => "ユーザ情報変更",
        'pageDescription' => '登録されているユーザ情報を変更します。',

        'pankuzu'         => array(
            '/mypage/' => 'マイページ',
        ),

        'errorMes' => $e->getMessage(),
        "data"     => $data,
    ))->display('mypage/my_users/edit.tpl');
}
