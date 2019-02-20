<?php
/**
 * 実績用データ集計
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2019/01/24
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    //// 変数を取得 ////
    $output     = Req::query('output');
    $monthYear  = Req::query('monthYear', date('Y'));
    $monthMonth = Req::query('monthMonth', date('m'));

    $month     = $monthYear . '/' . $monthMonth . '/01';

    $firstDay  = date('Y-m-01 00:00:00', strtotime($month));
    $lastDay   = date('Y-m-t 23:59:59',  strtotime($month));
    $newYear   = date('Y-01-01 00:00:00', strtotime($month));

    $dateCount = (int)date('t', strtotime($month));

    $lank = 5;

    // 登録数
    // $createMonth = $_db->quoteInto(' CAST(t.created_at as DATE) >= ? ',     $firstDay);
    // $createMonth.= $_db->quoteInto(' AND CAST(t.created_at as DATE) <= ? ', $lastDay);
    //
    // // 総数
    // $intoMonth = $_db->quoteInto(' (CAST(t.deleted_at as DATE) >= ? OR t.deleted_at IS NULL)',     $firstDay);
    // $intoMonth.= $_db->quoteInto(' AND CAST(t.created_at as DATE) <= ? ', $lastDay);
    //
    // // 削除数
    // $deleteMonth = $_db->quoteInto(' CAST(t.deleted_at as DATE) >= ? ',     $firstDay);
    // $deleteMonth.= $_db->quoteInto(' AND CAST(t.deleted_at as DATE) <= ? ', $lastDay);

    // 登録数
    $createMonth = $_db->quoteInto(' t.created_at >= ? ',     $firstDay);
    $createMonth.= $_db->quoteInto(' AND t.created_at <= ? ', $lastDay);

    // 登録数(年累計)
    $createTotal = $_db->quoteInto(' t.created_at >= ? ',     $newYear);
    $createTotal.= $_db->quoteInto(' AND t.created_at <= ? ', $lastDay);

    // 総数
    $intoMonth = $_db->quoteInto(' (t.deleted_at >= ? OR t.deleted_at IS NULL)', $firstDay);
    $intoMonth.= $_db->quoteInto(' AND t.created_at<= ? ',                       $lastDay);

    // 削除数
    $deleteMonth = $_db->quoteInto(' t.deleted_at >= ? ',     $firstDay);
    $deleteMonth.= $_db->quoteInto(' AND t.deleted_at <= ? ', $lastDay);

    //// 集計取得 ////
    $res = array();

    // 在庫
    $res["machinesCreate"] = $_db->fetchOne("SELECT count(t.*) FROM machines t WHERE {$createMonth};"); // 登録数
    $res["machinesInto"]   = $_db->fetchOne("SELECT count(t.*) FROM machines t WHERE {$intoMonth};");   // 総数
    $res["machinesDelete"] = $_db->fetchOne("SELECT count(t.*) FROM machines t WHERE {$deleteMonth};"); // 削除数

    $res["machinesCreateCompany"] = $_db->fetchOne("SELECT count(DISTINCT t.company_id) FROM machines t WHERE {$createMonth};"); // 出品会社数
    $res["machinesDeleteCompany"] = $_db->fetchOne("SELECT count(DISTINCT t.company_id) FROM machines t WHERE {$deleteMonth};"); // 削除会社数

    // $columns = "t.company_id, c.company";
    // $sql = "SELECT {$columns}, count(t.*) as count FROM machines t LEFT JOIN companies c ON c.id = t.company_id WHERE {$createMonth} GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    // $res["machinesCreateCompanyRanking"] = $_db->fetchAll($sql);

    // // ジャンルx出品ランキング
    // $columns = "t.genre";
    // $sql = "SELECT {$columns}, count(t.*) as count FROM view_machines t WHERE {$createMonth} GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    // $res["machinesCreateGenreRanking"] = $_db->fetchAll($sql);
    //
    // // ジャンルx削除ランキング
    // $columns = "t.genre";
    // $sql = "SELECT {$columns}, count(t.*) as count FROM view_machines t WHERE {$deleteMonth} GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    // $res["machinesDeleteGenreRanking"] = $_db->fetchAll($sql);

    // 中ジャンルx出品ランキング
    $columns = "t.large_genre";
    $sql = "SELECT {$columns}, count(t.*) as count FROM view_machines t WHERE {$createMonth} GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    $res["machinesCreateGenreRanking"] = $_db->fetchAll($sql);

    // 中ジャンルx削除ランキング
    $columns = "t.large_genre";
    $sql = "SELECT {$columns}, count(t.*) as count FROM view_machines t WHERE {$deleteMonth} GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    $res["machinesDeleteGenreRanking"] = $_db->fetchAll($sql);

    // 問合せ
    $contactCountSQL = "SELECT count(t.*) FROM contacts t WHERE {$createMonth}";
    $res["contactsMachine"] = $_db->fetchOne("{$contactCountSQL} AND t.machine_id IS NOT NULL;"); // 在庫
    $res["contactsCompany"] = $_db->fetchOne("{$contactCountSQL} AND t.machine_id IS NULL AND t.company_id IS NOT NULL;"); // 会社
    $res["contactsSystem"]  = $_db->fetchOne("{$contactCountSQL} AND t.machine_id IS NULL AND t.company_id IS NULL;"); // 事務局

    $res["contactsAll"]     = $res["contactsMachine"] + $res["contactsCompany"] + $res["contactsSystem"]; // 総数
    $res["contactsTotal"]   = $_db->fetchOne("SELECT count(t.*) FROM contacts t WHERE {$createTotal}"); // 累計

    $res["contactsUser"]  = $_db->fetchOne("SELECT count(DISTINCT t.mail) FROM contacts t WHERE {$createMonth};"); // 問合せユーザ数

    // 在庫機械x問合せランキング
    $columns = "t.machine_id, m.name, m.maker, m.model, m.year";
    $sql = "SELECT {$columns}, count(t.*) as count FROM contacts t LEFT JOIN machines m ON m.id = t.machine_id WHERE {$createMonth} AND t.machine_id IS NOT NULL GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    $res["contactsMachinesRanking"] = $_db->fetchAll($sql);

    // 都道府県x問合せランキング
    $columns = "t.addr1";
    $sql = "SELECT {$columns}, count(t.*) as count FROM contacts t WHERE {$createMonth} AND t.addr1 != '' GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    $res["contactsAddr1Ranking"] = $_db->fetchAll($sql);

    // アクセス数
    $res["ActionlogMachine"]     = $_db->fetchOne("SELECT count(t.*) FROM actionlogs t WHERE action='machine_detail' AND t.hostname IS NOT NULL AND {$createMonth};"); // 総数
    $res["ActionlogMachineUniq"] = $_db->fetchOne("SELECT count(DISTINCT t.ip) FROM actionlogs t WHERE action='machine_detail' AND t.hostname IS NOT NULL AND {$createMonth};"); // ユニークユーザ数
    $res["ActionlogMachineUniqTotal"] = $_db->fetchOne("SELECT count(DISTINCT t.ip) FROM actionlogs t WHERE action='machine_detail' AND t.hostname IS NOT NULL AND {$createTotal};"); // ユーザ数累計

    // echo "<pre>";
    // var_dump($_db->fetchAll("EXPLAIN ANALYZE SELECT count(t.*) FROM actionlogs t WHERE action='machine_detail' AND t.hostname IS NOT NULL AND {$createMonth};")); // ユニークユーザ数
    // echo "</pre>";
    // exit;


    // 在庫機械x詳細アクセスランキング
    $columns = "t.action_id, m.name, m.maker, m.model, m.year";
    $sql = "SELECT {$columns}, count(t.*) as count FROM actionlogs t LEFT JOIN machines m ON m.id = t.action_id WHERE action='machine_detail' AND t.hostname IS NOT NULL AND {$createMonth} AND t.action_id IS NOT NULL GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
    $res["ActionlogMachineRanking"] = $_db->fetchAll($sql);

    // 電子カタログ
    $res["ActionlogPDF"] = $_db->fetchOne("SELECT count(t.*) FROM actionlogs t WHERE action='PDF' AND t.hostname IS NOT NULL AND {$createMonth};"); // 総数
    $res["ActionlogPDFUniq"] = $_db->fetchOne("SELECT count(DISTINCT t.ip) FROM actionlogs t WHERE action='PDF' AND t.hostname IS NOT NULL AND {$createMonth};"); // ユニークユーザ数

    // Web入札会
    // 終了日取得
    $endMonth = $_db->quoteInto(' t.bid_end_date >= ? ',     $firstDay);
    $endMonth.= $_db->quoteInto(' AND t.bid_end_date <= ? ', $lastDay);

    $sql = "SELECT t.* FROM bid_opens t WHERE t.deleted_at IS NULL AND {$endMonth} ORDER BY t.bid_end_date;";
    $bidOpens = $_db->fetchAll($sql);

    $bmModel = new BidMachine();
    $res["bids"] = array();

    foreach ($bidOpens as $bo) {
      $bidCount = $_db->fetchOne("SELECT count(t.*) as count FROM bid_bids t WHERE t.deleted_at IS NULL AND t.created_at BETWEEN '${bo['bid_start_date']}' AND '{$bo['bid_end_date']}';"); // 入札数
      $bidCompanyCount = $_db->fetchOne("SELECT count(DISTINCT t.company_id) as count FROM bid_bids t WHERE t.deleted_at IS NULL AND t.created_at BETWEEN '${bo['bid_start_date']}' AND '{$bo['bid_end_date']}';"); // 入札数


      // 金額等集計
      $fullList = $bmModel->getList(array('bid_open_id' => $bo['id']));
      $sums = array(
          'count'        => count($fullList),
          'min_price'    => 0,
          'result_count' => 0,
          'result_price' => 0,

          'company_num'  => 0,
      );
      $cTemp = array();
      foreach ($fullList as $f) {
          $sums['min_price'] += $f['min_price'];
          $cTemp[] = $f['company_id'];
      }

      $sums['company_num'] = count(array_unique($cTemp));

      $resultListAsKey = $bmModel->getResultListAsKey($bo['id']); // 落札結果を取得
      foreach ($resultListAsKey as $r) {
          $sums['result_price'] += $r['amount'];
          if (!empty($r['amount'])) { $sums['result_count']++; }
      }

      // 売り切り
      //



      // アクセス数
      $log     = $_db->fetchOne("SELECT count(t.*) FROM actionlogs t WHERE t.action IN ('bid_detail', 'admin_bid_detail') AND t.hostname IS NOT NULL AND {$createMonth};"); // 総数
      $logUniq = $_db->fetchOne("SELECT count(DISTINCT t.ip) FROM actionlogs t WHERE t.action IN ('bid_detail', 'admin_bid_detail') AND t.hostname IS NOT NULL AND {$createMonth};"); // ユニークユーザ数

      // 出品商品x詳細アクセスランキング
      $columns = "t.action_id, m.name, m.maker, m.model, m.year, m.min_price";
      $sql = "SELECT {$columns}, count(t.*) as count FROM actionlogs t LEFT JOIN bid_machines m ON m.id = t.action_id WHERE t.action IN ('bid_detail', 'admin_bid_detail') AND t.hostname IS NOT NULL AND {$createMonth} AND t.action_id IS NOT NULL GROUP BY {$columns} ORDER BY count DESC LIMIT {$lank};";
      $logBMRanking = $_db->fetchAll($sql);

      $res["bids"][] = array(
        'open'     => $bo,
        'sums'     => $sums,
        'log'      => $log,
        'logUniq'  => $logUniq,
        "logBMRanking"    => $logBMRanking,
        'bidCount'        => $bidCount,
        'bidCompanyCount' => $bidCompanyCount,
      );
    }


    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '実績用データ集計',
        'pankuzu'     => array('/system/' => '管理者ページ'),
        'month'       => $month,
        'monthYear'   => $monthYear,
        'monthMonth'  => $monthMonth,
        'dateCount'   => $dateCount,
        'lank'        => $lank,
        'res'         => $res,
    ))->display("system/formula.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '実績用データ集計',
        'pankuzu'   => array('/system/' => '管理者ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
