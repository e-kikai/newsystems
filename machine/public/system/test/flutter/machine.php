<?php
/**
 * flutter API テスト : (マシンライフから出品用)在庫一覧取得
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2022/10/22
 */
//// 設定ファイル読み込み ////
require_once '../../../../lib-machine.php';
try {
    /// 認証 ///
    // Auth::isAuth('system');

    // タイムアウトを長く設定
    set_time_limit(3000);

    $command = Req::query('c');

    if ($command == "list_by_company_id") {
        /// 出品商品一覧 ///
        $sql = "SELECT bm.*
        FROM bid_machines bm
        WHERE bm.deleted_at IS NULL
        AND bm.company_id = ?
        AND bm.bid_open_id = ?
        ORDER BY list_no;";

        // $sql   = "SELECT bm.*, ac.count as detail_count
        // FROM bid_machines bm
        // LEFT JOIN (
        //     SELECT a.action_id, count(a.id) AS count
        //     FROM actionlogs a
        //     WHERE action = 'bid_detail' GROUP BY a.action_id
        //     LIMIT 100
        // ) ac ON ac.action_id = bm.id
        // WHERE bm.deleted_at IS NULL
        // AND bm.company_id = ?
        // AND bm.bid_open_id = ?
        // ORDER BY list_no;";
        $param = [Req::query('company_id'),  Req::query('bid_open_id')];
        $res = $_db->fetchAll($sql, $param);

    } else if ($command == 'find') {
        $bmModel = new BidMachine();
        $machine = $bmModel->get($machineId);

    } else if ($command == "large_genres") {
        /// 中ジャンル一覧 ///
        $sql   = "SELECT lg.id, lg.large_genre, xg.xl_genre
        FROM large_genres lg
        LEFT JOIN xl_genres xg ON xg.id = lg.xl_genre_id
        WHERE lg.deleted_at IS NULL ORDER BY xg.order_no, lg.order_no;";
        $param = [];
        $res = $_db->fetchAll($sql, $param);
    }

    /// 結果をJSONに変換して出力 ///
    header("Content-Type: application/json; charset=utf-8");
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
