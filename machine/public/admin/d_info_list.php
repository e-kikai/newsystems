<?php
/**
 * 大宝お知らせ一覧ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2017/10/16
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    $user = Auth::isAuth('member');

    if ($_user['company_id'] != 320) {
        header('Location: /admin/');
        exit;
    }

    $r = Req::query('r');

    /// お知らせ一覧を取得 ///
    $diTable = new DInfo();
    $dInfoList = $diTable->getList($_user['company_id']);

    /// dummy //
    // $dInfoList = [
    //     3 => [
    //         "id"      => "3",
    //         "date"    => "2022/01/09",
    //         "title"   => "新規入荷しました",
    //         "content" => "<新規入荷情報>
    //         テスト",
    //         "company_id" => 320,
    //         "created_at" => "2022/01/04 12:13:34"
    //     ],
    //     2 => [
    //         "id"      => "2",
    //         "date"    => "2021/12/01",
    //         "title"   => "新規入荷しました",
    //         "content" => "新規入荷情報 テスト

    //         テスト",
    //         "company_id" => 320,
    //         "created_at" => "2021/11/24 14:13:34"
    //     ],
    //     1 => [
    //         "id"      => "1",
    //         "date"    => "2021/01/12",
    //         "title"   => "新規入荷しました",
    //         "content" => "新規入荷情報 テスト・テスト",
    //         "company_id" => 320,
    //         "created_at" => "2021/01/04 17:13:34"
    //     ]
    // ];
    // $count     = 20;

    /// ページャ ///
    // Zend_Paginator::setDefaultScrollingStyle('Sliding');
    // $pgn = Zend_Paginator::factory(intval($count));
    // $pgn->setCurrentPageNumber($q['page'])
    //     ->setItemCountPerPage($q['limit'])
    //     ->setPageRange(15);

    $message = "";
    if (!empty($r)) {
        if ($r == "create") {
            $message = "お知らせを作成しました";
        } else if ($r == 'update') {
            $message = "お知らせを変更しました";
        } else if ($r == 'delete') {
            $message = "お知らせを削除しました";
        } else if ($r == 'delete_error') {
            $message = "お知らせの削除に失敗しました";
        }
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'    => '自社サイト お知らせ一覧',
        'pankuzu'      => array('admin/' => '会員ページ'),
        'dInfoList'    => $dInfoList,
        // 'pager'        => $pgn->getPages(),

        'message'      => $message,
    ))->display("admin/d_info_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'    => '自社サイト お知らせ一覧',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
