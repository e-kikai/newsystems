<?php

/**
 * ユーザマイページトップページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/07
 */

require_once '../../lib-machine.php';
try {
    /// 認証 ///
    // MyAuth::is_auth();

    // /// ユーザ情報 ///
    // $my_user_model = new MyUser();
    // $my_user       = $my_user_model->get($_my_user['id']);

    // /// 事務局お知らせ ///
    // $info_model = new Info();
    // $infos      = $info_model->getList('member', $company['group_id'], 20, true);

    // 入札会開催情報の取得
    $bid_open_model = new BidOpen();
    $bid_opens      = $bid_open_model->getList(array('isopen' => true));

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => 'Web入札会マイページ',
        'pageDescription' => 'メニューを選択してください',

        // 'my_user'         => $my_user,
        // 'infos'           => $infos,
        'bid_opens'       => $bid_opens,
    ))->display('mypage/index.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'マイページ',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
