<?php

/**
 * 売り買いフォーム
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

    $id = Req::query('id');

    /// 売り買い情報を取得 ///
    $fModel = new Urikai();
    if ($id) {
        $urikai = $fModel->get($id);
    } else {
        /// 会社情報を取得 ///
        $cModel = new Company();
        $company = $cModel->get($_user['company_id']);

        // 新規作成デフォルトを設定
        $urikai = array(
            'company_id' => $_user['company_id'],
            'goal'       => 'cell',
            'imgs'       => array(),
            'tel'        => $company["tel"],
            'fax'        => $company["fax"],
            'mail'       => $company["mail"],
        );
    }

    if ($urikai['company_id'] != $_user['company_id']) {
        throw new Exception("これはあなたの書きこみではありません id:{$id}");
    }

    $goalList = array(
        'cell' => '売りたし',
        'buy'  => '買いたし',
    );

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '売りたし買いたしフォーム',
        'pankuzu'   => array(
            '/admin/'                => '会員ページ',
            '/admin/urikai_list.php' => '売りたし買いたし一覧'
        ),
        'urikai'    => $urikai,
        'goalList'  => $goalList,
    ))->display("admin/urikai_form.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => '売りたし買いたしフォーム',
        'pankuzu'   => array(
            '/admin/'                => '会員ページ',
            '/admin/urikai_list.php' => '売りたし買いたし一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
