<?php
/**
 * お問い合わせ一覧(すべて)表示隠しページ表示
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2013/02/05
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数を取得 ////
    $output = Req::query('output');
    
    $cModel = new Contact();

    //// CSVに出力する場合 ////
    if ($output == 'csv') {
        $mailuserList = $cModel->getMailuserList();

        $header = array(
            'user_company' => '会社名',
            'user_name'    => 'ユーザ名',
            'mail'         => 'メールアドレス',
        );

        B::downloadCsvFile($header, $mailuserList, 'contact_all_mailuser.csv');
        exit;
    }

    //// お問い合わせ一覧を取得 ////
    $month = Req::query('monthYear') ? Req::query('monthYear') . '/' . Req::query('monthMonth') .'/01' : null;
    
    $contactList = $cModel->getList('ALL', $month);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせ一覧(すべて)',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'contactList'   => $contactList,
        'month'     => $month,
    ))->display("system/contact_list_all.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせ一覧(すべて)',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

