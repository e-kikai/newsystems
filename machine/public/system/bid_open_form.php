<?php
/**
 * Web入札会登録フォーム
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/02
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');

    $id = Req::query('id');
    //// 入札会開催情報を取得 ////
    if ($id) {
        $boModel = new BidOpen();
        $bidOpen = $boModel->get($id);
    } else {
        // 新規作成デフォルトを設定
        $bidOpen = array(
            'organizer' => '全機連事務局',
            'min_price' => 1000,
            'rate'      => 100,
            // 'tax'       => 8,
            'tax'       => 10,
            'entry_limit_style' => 0,
            'entry_limit_num'   => 0,
            'motobiki'  => 0,
            'deme'      => 50,
            'fee_calc'  => "100000 : 5 , 10\n1000000 : 4 , 10\n2000000 : 3 , 8\n3000000 : 3 , 7\n3000000 : 3 , 5",
        );
    }

    // 団体一覧
    $gModel = new Group();
    $groupList = $gModel->getList();

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $id ? 'Web入札会変更' : '新規Web入札会登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/bid_open_list.php' => 'Web入札会一覧',
        ),
        'id'        => $id,
        'bidOpen'      => $bidOpen,
        'groupList' => $groupList,
    ))->display("system/bid_open_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $id ? 'Web入札会変更' : '新規Web入札会登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/bid_open_list.php' => 'Web入札会一覧',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
