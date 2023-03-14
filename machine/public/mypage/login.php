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

$ref = !empty(Req::query('r')) ? $_SERVER["HTTP_REFERER"] : '';

// switch (Req::query('e')) {
//     case 1:
//         $_smarty->assign('errorMes', "ログイン出来ませんでした。\n入力したメールアドレスとパスワードをご確認下さい。");
//         break;
//     case 2:
//         $_smarty->assign('errorMes', 'ログインしていません。');
//         break;
//     case 3:
//         $_smarty->assign('message', "ログアウトしました。\nWeb入札会へのご参加、ありがとうございました。");
//         break;
// }

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => 'マイページ - ログイン',
    'pageDescription' => '入札会で入札を行うためのユーザログインです。メールアドレスとパスワードを入力してください。',

    'ref' => $ref,
))->display("mypage/login.tpl");
