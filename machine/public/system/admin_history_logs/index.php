<?php

/**
 * 会員分析ログ一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2023/08/08
 */

require_once '../../../lib-machine.php';

/// 認証処理 ///
Auth::isAuth('system');

/// セレクタ ///
$target_selector = [
    "すべて"               => "",
    "同型式の在庫登録履歴" => "histories",
    "機械在庫集計"         => "total",
];

/// 変数を取得 ///
$page   = Req::query('page', 1);
$limit  = Req::query('limit', 100);
$target = Req::query('target');
$year   = Req::query('dYear', date('Y'));
$month  = Req::query('dMonth', date('m'));
$output = Req::query('output');

// 日付整形
$date      = "{$year}-{$month}-01";
$first_day = date('Y-m-01 00:00:00', strtotime($date));
$last_day  = date('Y-m-t 23:59:59',  strtotime($date));

// ベース
$base_select = $_db->select()
    ->from("admin_history_logs as ahl", null)
    ->where("ahl.created_at >= ?", $first_day)
    ->where("ahl.created_at <= ?", $last_day);

if (!empty($target)) { // ページ
    $base_select->where("ahl.page = ?", $target);
}

// ->join(["ge" => "genres"], "ge.id = m.genre_id", null)
// ->join(["la" => "large_genres"], "la.id = ge.large_genre_id", null)
// ->join(["xl" => "xl_genres"], "xl.id = la.xl_genre_id", null)
// ->where("la.xl_genre_id <= ?", XlGenres::MACHINE_ID_LIMIT);

/// 件数取得 ///
$count_select = clone $base_select;
$count_select->columns("count(*) as c");

$count = $_db->fetchRow($count_select);

/// 取得 ///
$select = clone $base_select;
$select->columns("ahl.*")
    ->join(["co" => "companies"], "co.id = ahl.company_id", "co.company")
    ->order("ahl.created_at DESC");

if ($output == 'csv') { // CSV
    $admin_history_logs = $_db->fetchAll($select);  // 全件取得

    $header   = array(
        'id'         => 'ID',
        'created_at' => '登録日時',
        'company_id' => '会社ID',
        'company'    => '会社名',
        'utag'       => 'utag',
        'ip'         => 'IP',
        'host'       => 'host',
        'page'       => 'ページ',
        'event'      => 'イベント',
        'datas'      => 'datas',
        'referer'    => 'リファラ',
    );
    $filename = "{$year}/{$month}_admin_history_logs.csv";
    B::downloadCsvFile($header, $admin_history_logs, $filename);
} else {
    $admin_history_logs = $_db->fetchAll($select->limitPage($page, $limit));  // ページ取得

    /// ページャ ///
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($page)
        ->setItemCountPerPage($limit)
        ->setPageRange(15);
    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) $cUri .= '?';

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'          => "{$year}/{$month} 会員ページ分析ログ一覧",
        'pankuzu'            => array('/system/' => '管理者ページ',),
        'r'                  => $pgn->getPages(),
        'cUri'               => $cUri,
        'admin_history_logs' => $admin_history_logs,
        "date"               => $date,
        "target"             => $target,
        "target_selector"    => $target_selector,
    ))->display('system/admin_history_logs/index.tpl');
}
