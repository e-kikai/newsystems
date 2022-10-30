<?php
/**
 * AJAXでトップ機械画像一覧の取得(ジャンルID or 商品名正規表現)
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2013/01/03
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('system');

    // タイムアウトを長く設定
    set_time_limit(3000);

    //// パラメータ取得 ////
    $gid    = Req::query('gid');
    $gid_to = Req::query('gid_to');
    $name   = Req::query('name');
    $limit  = Req::query('limit', 1100);
    $offset = Req::query('offset', 0);

    $where = " m.top_img IS NOT NULL AND  m.top_img != '' ";
    if (!empty($gid) && !empty($gid_to)) {
        $where .= $_db->quoteInto(' AND (m.genre_id BETWEEN ?  ', $gid);
        $where .= $_db->quoteInto(' AND ?) ', $gid_to);
    } else if (!empty($gid)) {
        $where .= $_db->quoteInto(' AND (m.genre_id = ?) ', $gid);
    }

    if (!empty($name)) {
        $where .= $_db->quoteInto(' AND (m.name ~ ?) ', $name);
    }


    //// 機械画像を取得 ////
    $sql = 'SELECT m.id, m.name, m.top_img FROM machines m WHERE ' . $where . ' ORDER BY m.id LIMIT ? OFFSET ?;';
    $res = $_db->fetchAll($sql, array($limit, $offset));
    // echo $sql;

    if (empty($res)) {
        throw new Exception('会社情報を取得できませんでした');
    }

    // 結果をJSONに変換して出力
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
