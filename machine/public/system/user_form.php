<?php

/**
 * ユーザ情報登録フォーム
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/05/19
 */
require_once '../../lib-machine.php';
try {
    /// 認証処理 ///
    Auth::isAuth('system');

    $id = Req::query('id');
    /// 入札会開催情報を取得 ///
    if ($id) {
        $uModel = new User();
        $user = $uModel->get($id);
    } else {
        // 新規作成デフォルトを設定
        $user = array(
            'company_id' => null,
            'role'       => 'guest'
        );
    }

    /// 会社情報を取得 ///
    $cModel = new Company();
    $companyList = $cModel->getList();

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => $id ? 'ユーザ情報変更' : 'ユーザ情報新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/user_list.php' => 'ユーザ一覧',
        ),
        'id'          => $id,
        'user'        => $user,
        'companyList' => $companyList,
    ))->display("system/user_form.tpl");
} catch (Exception $e) {
    /// エラー画面表示 ///
    $_smarty->assign(array(
        'pageTitle' => $id ? 'ユーザ情報変更' : 'ユーザ情報新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/user_list.php' => 'ユーザ一覧',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
