<?php

/**
 * 会員一覧表示ページ表示
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2012/10/29
 */
/// 設定ファイル読み込み ///
require_once '../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('system');

    /// 変数を取得 ///
    $output = Req::query('output');

    /// 会社一覧を取得 ///
    $companyTable = new Companies();
    $companyList  = $companyTable->getList();

    /// CSVに出力する場合 ///
    if ($output == 'csv') {
        // データ整形
        foreach ($companyList as $key => $c) {
            $companyList[$key]['rank_label']   = Companies::getRankLabel($c['rank']);

            $companyList[$key]['created_date'] = !empty($c['created_at']) ? date('Y/m/d', strtotime($c['created_at'])) : '';

            $companyList[$key]['companysite']  = !empty($c['subdomain']) ? "{$_conf->site_uri}s/{$c['subdomain']}/" : '';
        }

        $header = array(
            'id'                => '会社ID',
            'company'           => '会社名',
            'company_kana'      => '会社名(カナ)',
            'representative'    => '代表者',
            'zip'               => '郵便番号',
            'addr1'             => '住所(都道府県)',
            'addr2'             => '住所(市区町村)',
            'addr3'             => '住所(番地その他)',
            'mail'              => '代表メールアドレス',
            'tel'               => '代表TEL',
            'fax'               => '代表FAX',
            'website'           => 'ウェブサイトURL',

            'rootname'          => '所属団体1',
            'groupname'         => '所属団体2',
            'rank_label'        => 'ランク',
            'parent_company_id' => '親会社ID',
            'parent_company'    => '親会社名',

            'officer'           => '担当者',
            'contact_mail'      => 'お問い合わせメールアドレス',
            'count'             => '在庫件数',
            'companysite'       => '自社サイトURL',

            'created_date'      => '登録日',
        );

        B::downloadCsvFile($header, $companyList, 'company_list.csv');
        exit;
    } else if ($output == 'pdf') {
        /// PDF出力準備 ///
        require_once('fpdf/MBfpdi.php'); //PDF
        $pdf = new Pdf();

        $filename = 'rank_seikyu.pdf';
        $res      = $pdf->makeCompanySeikyu($companyList, Req::query('date'));

        /// ファイルのダウンロード処理 ///
        header("Content-type: application/pdf");
        header('Content-Disposition: inline; filename="' . $filename . '"');
        echo $res;
        exit;
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => '会員一覧',
        'pankuzu'     => array('/system/' => '管理者ページ'),
        'companyList' => $companyList,
    ))->display("system/company_list.tpl");
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
