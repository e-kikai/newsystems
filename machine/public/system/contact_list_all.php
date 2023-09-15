<?php

/**
 * お問い合わせ一覧(すべて)表示隠しページ表示
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2013/02/05
 */
/// 設定ファイル読み込み ///
require_once '../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('system');

    /// 変数を取得 ///
    $output = Req::query('output');
    $month  = Req::query('monthYear') ? Req::query('monthYear') . '/' . Req::query('monthMonth') . '/01' : null;

    $cModel = new Contact();

    /// CSVに出力する場合 ///
    if ($output == 'csv') {
        // $mailuserList = $cModel->getMailuserList();
        $mailuserList = $cModel->getContactMailList();

        $header = array(
            'mail'         => 'mail',
            'user_company' => '会社名',
            'user_name'    => 'ユーザ名',
            'xl_genre_id'  => 'xl_genre_id',
        );

        B::downloadCsvFile($header, $mailuserList, 'contact_all_mailuser.csv');
        exit;
    } else if ($output == 'csvall') {
        /// お問い合わせ一覧を取得 ///
        $contactList = $cModel->getList('ALL', $month);
        $filename    = (Req::query('monthYear') ? (Req::query('monthYear') . Req::query('monthMonth')) : 'last') . '_contact_all.csv';

        $header = array(
            'id'            => 'ID',
            'company_id'    => '問い合わせ先会社ID',
            'company'       => '問い合わせ先会社',
            'machine_id'    => '機械ID',
            'no'            => '機械No.',
            'name'          => '機械名',
            'maker'         => 'メーカー',
            'model'         => '型式',
            'user_company'  => '会社名',
            'user_name'     => 'ユーザ名',
            'tel'           => 'TEL',
            'fax'           => 'FAX',
            'addr1'         => '都道府県',
            'mail'          => 'メールアドレス',
            'return_time'   => '返信',
            'message'       => '内容',
            'created_at'    => '登録日時',
            'mailuser_flag' => 'メルマガ',

        );

        B::downloadCsvFile($header, $contactList, $filename);
        exit;
    }

    /// お問い合わせ一覧を取得 ///
    $contactList = $cModel->getList('ALL', $month);

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => 'お問い合わせ一覧(すべて)',
        'pankuzu'     => array('/system/' => '管理者ページ'),
        'contactList' => $contactList,
        'month'       => $month,
        'monthYear'   => Req::query('monthYear'),
        'monthMonth'  => Req::query('monthMonth'),
    ))->display("system/contact_list_all.tpl");
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせ一覧(すべて)',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
