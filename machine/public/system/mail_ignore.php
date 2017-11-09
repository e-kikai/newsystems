<?php
/**
 * 非送信メールアドレス編集
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2014/01/31
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    /// CSVファイルを読み込み ///
    if (($mailIgnore = mb_convert_encoding(file_get_contents(APP_PATH . Mail::MAIL_IGNORE_FILE), 'utf-8', 'sjis-win')) === FALSE) {
        throw new Exception('ファイルが開けませんでした');
    }
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '非送信メールアドレス編集',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'mailIgnore'      => $mailIgnore,
    ))->display("system/mail_ignore.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '非送信メールアドレス編集',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

