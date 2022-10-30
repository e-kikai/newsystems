<?php
/**
 * 大宝お知らせフォーム
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2021/01/12
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    $user = Auth::isAuth('member');

    if ($_user['company_id'] != 320) {
        header('Location: /admin/');
        exit;
    }

    /// 変数取得 ///
    $id = Req::query('id');

    //// お知らせ一覧を取得 ////
    if (!empty($id)) {
        $diModel = new DInfo();
        $dInfo   = $diModel->get($_user['company_id'], $id);

        /// dummy ///
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

        // $dInfo = $dInfoList[$id];

        if ($dInfo['company_id'] != $_user['company_id']) {
            throw new Exception("これはあなたのお知らせ情報ではありません id:{$id}");
        }
    } else {
        //// 会社情報を取得 ////
        $cModel  = new Company();
        $company = $cModel->get($_user['company_id']);

        // 新規作成デフォルトを設定
        $dInfo = array(
            'from_name'     => $company["company"],
            'from_mail'     => $company["contact_mail"],
            'design_button' => "詳しくはこちらをクリック",
        );
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '自社サイト お知らせフォーム',
        'pankuzu'   => array(
            '/admin/'                => '会員ページ',
            '/admin/d_info_list.php' => 'お知らせ一覧'
        ),
        'dInfo'     => $dInfo,
    ))->display("admin/d_info_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '自社サイト お知らせフォーム',
        'pankuzu'   => array(
            '/admin/'                => '会員ページ',
            '/admin/d_info_list.php' => 'お知らせ一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
