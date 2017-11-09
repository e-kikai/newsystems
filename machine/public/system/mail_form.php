<?php
/**
 * メール送信フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    $id = Req::query('id');
    
    //// メール情報を取得 ////
    $mModel = new Mail();
    if ($id) {
        $mail = $iModel->get($id);
    } else {
        // 新規作成デフォルトを設定
        $mail = array(
            'target' => 'member',
            'group_id' => NULL,
            'info_date' => date('Y/m/d'),
        );
    }
    
    // 団体一覧
    $gModel = new Groups();
    $groupList = $gModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $id ? 'メール変更' : 'メール一括送信',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'id'        => $id,
        'mail'      => $mail,
        'groupList' => $groupList,
    ))->display("system/mail_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $id ? 'メール変更' : 'メール一括送信',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
