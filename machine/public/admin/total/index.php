<?php

/**
 * 集計ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2023/08/01
 */

require_once '../../../lib-machine.php';

/// 認証 ///
Auth::isAuth('member');

if (!Company::check_sp($_user["company_id"])) throw new Exception("このページの閲覧権限がありません。");

/// セレクタ ///
$target_selector = [
    "特大ジャンル" => "xl_genre",
    "大ジャンル"   => "large_genre",
    "ジャンル"     => "genre",
];

///  変数を取得 ///
$output = Req::query('output');
$target = Req::query('target');
$year   = Req::query('dYear', date('Y'));
$month  = Req::query('dMonth', date('m'));

// 日付整形
$date       = "{$year}-{$month}-01";
$first_day  = date('Y-m-01 00:00:00', strtotime($date));
$last_day   = date('Y-m-t 23:59:59',  strtotime($date));
$new_year   = date('Y-01-01 00:00:00', strtotime($date));
$date_count = (int)date('t', strtotime($date));

/// 各種集計の取得 ///
$results = [];

// ベース
$m_select = $_db->select()
    ->from("machines as m", null)
    ->join(["ge" => "genres"], "ge.id = m.genre_id", null)
    ->join(["la" => "large_genres"], "la.id = ge.large_genre_id", null)
    ->join(["xl" => "xl_genres"], "xl.id = la.xl_genre_id", null)
    ->where("la.xl_genre_id <= ?", XlGenres::MACHINE_ID_LIMIT);

// ジャンル
if ($target == "genre") { // ジャンル
    $m_select->columns(["ge.id"])->group(["ge.id"]);

    $gt = "ジャンル";

    $g_select = $_db->select()
        ->from("genres as ge", ["ge.id", "ge.genre"])
        ->join(["lg" => "large_genres"], "lg.id = ge.large_genre_id", "large_genre")
        ->join(["xg" => "xl_genres"], "xg.id = lg.xl_genre_id", ["xl_genre"])
        ->where("xg.id <= ?", XlGenres::MACHINE_ID_LIMIT)
        ->order(["xg.order_no", "lg.order_no", "ge.order_no"]);
    $genres = $_db->fetchAll($g_select);

    $results["特大ジャンル"] = array_column($genres, "xl_genre", "id");
    $results["大ジャンル"] = array_column($genres, "large_genre", "id");
    $results["ジャンル"] = array_column($genres, "genre", "id");
} else if ($target == "large_genre") { // 大ジャンル
    $m_select->columns(["la.id"])->group(["la.id"]);
    $gt = "大ジャンル";

    $g_select = $_db->select()
        ->from("large_genres as lg", ["lg.id", "lg.large_genre"])
        ->join(["xg" => "xl_genres"], "xg.id = lg.xl_genre_id", ["xl_genre"])
        ->where("xg.id <= ?", XlGenres::MACHINE_ID_LIMIT)
        ->order(["xg.order_no", "lg.order_no"]);
    $genres = $_db->fetchAll($g_select);

    $results["特大ジャンル"] = array_column($genres, "xl_genre", "id");
    $results["大ジャンル"] = array_column($genres, "large_genre", "id");
} else { // 特大ジャンル
    $m_select->columns(["la.xl_genre_id as id"])->group(["la.xl_genre_id"]);
    $gt = "特大ジャンル";

    $g_select = $_db->select()
        ->from("xl_genres as xg", ["xg.id as id", "xg.xl_genre"])
        ->where("xg.id <= ?", XlGenres::MACHINE_ID_LIMIT)
        ->order("xg.order_no");
    $genres = $_db->fetchAll($g_select);
    $results["特大ジャンル"] = array_column($genres, "xl_genre", "id");
}

$ids = array_column($genres, "id");

/// 総在庫数, 会社数 ///
$select = clone $m_select;

$select
    ->columns([
        "count(m.id) as c",
        "count(DISTINCT m.company_id) as company_c",
        "count(CASE WHEN m.view_option=1 THEN 1 ELSE NULL END) as v1",
        "count(CASE WHEN m.view_option=2 THEN 1 ELSE NULL END) as v2"
    ])
    ->where("m.deleted_at >= ? OR m.deleted_at IS NULL", $last_day)
    ->where("m.created_at <= ?", $last_day);
$res = $_db->fetchAll($select);

$results["総在庫 件数"] = array_column($res, "c", "id");
$results["うち、 非表示"] = array_column($res, "v1", "id");
$results["うち、 商談中"] = array_column($res, "v2", "id");
$results["総在庫 会社数"] = array_column($res, "company_c", "id");

/// 登録件数、会社数 ///
$select = clone $m_select;

$select->columns("count(m.id) as c, count(DISTINCT m.company_id) as company_c")
    ->where("m.created_at >= ?", $first_day)
    ->where("m.created_at <= ?", $last_day);
$res = $_db->fetchAll($select);

$results["登録 件数"] = array_column($res, "c", "id");
$results["登録 1日平均"] = array_map(function ($val) use ($date_count) {
    return round($val / $date_count, 2);
}, $results["登録 件数"]);
$results["登録 会社数"] = array_column($res, "company_c", "id");

// echo $select->__toString();

/// 削除件数、会社数 ///
$select = clone $m_select;

$select->columns("count(m.id) as c, count(DISTINCT m.company_id) as company_c")
    ->where("m.deleted_at >= ?", $first_day)
    ->where("m.deleted_at <= ?", $last_day);
$res = $_db->fetchAll($select);

$results["削除 件数"] = array_column($res, "c", "id");
$results["削除 1日平均"] = array_map(function ($val) use ($date_count) {
    return round($val / $date_count, 2);
}, $results["削除 件数"]);
$results["削除 会社数"] = array_column($res, "company_c", "id");

/// 問合せ件数、人数 ///
$select = clone $m_select;

$select->join(["c" => "contacts"], "m.id = c.machine_id", null)
    ->columns("count(c.id) as c,  count(DISTINCT c.mail) as mail_c, count(DISTINCT(m.id)) as machine_c,  count(DISTINCT(m.company_id)) as company_c")
    ->where("c.created_at >= ?", $first_day)
    ->where("c.created_at <= ?", $last_day);
$res = $_db->fetchAll($select);

$results["問合せ 件数"] = array_column($res, "c", "id");
$results["問合せ ユーザ数"] = array_column($res, "mail_c", "id");
$results["問合せ先 機械数"] = array_column($res, "machine_c", "id");
$results["問合せ先 会社数"] = array_column($res, "company_c", "id");


/// アクセス数、IP数 ///
$select = clone $m_select;

$select->join(["al" => "actionlogs"], "action = 'machine_detail' AND m.id = al.action_id", null)
    ->columns("count(al.id) as c,  count(DISTINCT(al.ip)) as ip_c")
    ->where("al.ip <> '' AND al.ip IS NOT NULL AND al.hostname <> '' AND al.hostname IS NOT NULL AND al.ip <> al.hostname")
    ->where("al.created_at >= ?", $first_day)
    ->where("al.created_at <= ?", $last_day);

// echo $select->__toString();

$res = $_db->fetchAll($select);

$results["詳細閲覧 件数"] = array_column($res, "c", "id");
$results["詳細閲覧 1日平均"] = array_map(function ($val) use ($date_count) {
    return round($val / $date_count, 2);
}, $results["詳細閲覧 件数"]);
$results["詳細閲覧 IP数"] = array_column($res, "ip_c", "id");


/// カタログアクセス、人数 ///
// $select = clone $m_select;

// $select->join(["al" => "actionlogs"], "action = 'PDF' AND m.catalog_id IS NOT NULL AND m.catalog_id = al.action_id", null)
//     ->columns("count(al.id) as c,  count(DISTINCT(al.ip, al.action_id)) as ip_c")
//     ->where("al.ip <> '' AND al.ip IS NOT NULL AND al.hostname <> '' AND al.hostname IS NOT NULL AND al.ip <> al.hostname")
//     ->where("al.created_at >= ?", $first_day)
//     ->where("al.created_at <= ?", $last_day);

// $res = $_db->fetchAll($select);

// $results["カタログ 件数"] = array_column($res, "c", "id");
// $results["カタログ 1日平均"] = array_map(function ($val) use ($date_count) {
//     return round($val / $date_count, 2);
// }, $results["カタログ 件数"]);
// $results["カタログ IP数"] = array_column($res, "ip_c", "id");

/// ロギング ///
$admin_history_log_model = new AdminHistoryLog();
$admin_history_log_model->write($_user, "total",  "search", [
    "target" => $target,
    "date"   => $date,
    "output" => $output,
]);


if ($output == 'csv') { // CSV
    $body = [];
    $keys = array_keys($results);

    foreach ($ids as $id) {
        $row = ["id" => $id];
        foreach ($keys as $key) $row[$key] = !empty($results[$key][$id]) ? $results[$key][$id] : "0";
        $body[] = $row;
    }

    $header = ["id" => "id"];
    foreach ($keys as $key) $header[$key] = $key;

    $filename = "{$year}_{$month}_{$target}_total.csv";
    B::downloadCsvFile($header, $body, $filename);
} else {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => "{$year}/{$month} {$gt}ごとの在庫集計",
        'pankuzu'         => ['/admin/' => '会員ページ',],
        "ids"             => $ids,
        "results"         => $results,
        "date"            => $date,
        "target"          => $target,
        "target_selector" => $target_selector,
    ))->display('admin/total/index.tpl');
}
