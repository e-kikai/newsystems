<?php
/**
 * flutter API テスト : ジャンル取得
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2022/10/14
 */
//// 設定ファイル読み込み ////
require_once '../../../../lib-machine.php';
try {
    /// 認証 ///
    // Auth::isAuth('system');

    // タイムアウトを長く設定
    set_time_limit(3000);

    $command = Req::query('c');

    if ($command == "all") {
        /// ジャンル一覧取得 ///
        $sql   = "SELECT * FROM bid_machines WHERE deleted_at IS NULL AND company_id = ? AND bid_open_id = ? ORDER BY list_no;";
        $param = [Req::query('company_id'),  Req::query('bid_open_id')];
        $res = $_db->fetchAll($sql, $param);

    } else if ($command == "large_genres_by_company_id_in_bid_products") {

        /// 入札会出品商品の大ジャンル(フィルタ用) ///
        $sql   = "SELECT lg.id, lg.large_genre, xg.xl_genre, tbp1.count
      FROM large_genres lg
      LEFT JOIN xl_genres xg ON xg.id = lg.xl_genre_id
      LEFT JOIN (
          SELECT g2.large_genre_id, count(bm2.*) AS count
          FROM bid_machines bm2
          LEFT JOIN genres g2 ON g2.id = bm2.genre_id
          WHERE bm2.deleted_at IS NULL AND bm2.company_id = ? AND bm2.bid_open_id = ?
          GROUP BY g2.large_genre_id
        ) tbp1 ON tbp1.large_genre_id = lg.id
      WHERE lg.deleted_at IS NULL AND tbp1.count IS NOT NULL
      ORDER BY xg.order_no, lg.order_no;";
        $param = [Req::query('company_id'),  Req::query('bid_open_id')];
        $res = $_db->fetchAll($sql, $param);
    }

    /// 結果をJSONに変換して出力 ///
    header("Content-Type: application/json; charset=utf-8");
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
