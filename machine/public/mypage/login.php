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


switch (Req::query('e')) {
    case 1:
        $_smarty->assign('errorMes', "ログイン出来ませんでした。\n入力したメールアドレスとパスワードをご確認下さい。");
        break;
    case 2:
        $_smarty->assign('errorMes', 'ログインしていません。');
        break;
    case 3:
        $_smarty->assign('message', "ログアウトしました。\nWeb入札会へのご参加、ありがとうございました。");
        break;
    case 4:
        $_smarty->assign('errorMes', 'マイページ表示する権限がありません');
        break;
    case 5:
        $_smarty->assign('errorMes', 'マイページの認証がタイムアウトしました');
        break;
    case 6:
        $_smarty->assign('message', "ユーザ認証が完了しました。\n早速、以下のフォームからマイページにログインしてみてください。");
        break;
    case 7:
        $_smarty->assign('errorMes', 'ユーザ認証に失敗しました。お手数ですが、もう一度メールのリンクにアクセスしてみてください。');
        break;
}

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => 'マイページ - ログイン',
    'pageDescription' => '入札会で入札を行うためのユーザログインです。メールアドレスとパスワードを入力してください。'
))->display("mypage/login.tpl");
