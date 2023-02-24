<?php

/**
 * AJAXでクロール設定・結果のセット・削除
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/05/25
 */
/// 設定ファイル読み込み ///

set_time_limit(30000);

require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    // Auth::isAuth('catalog');

    // タイムアウトを長く設定
    // set_time_limit(3000);

    /// パラメータ取得 ///
    $companyId = Req::post('id');
    $company   = Req::post('company');
    $data      = Req::post('data');
    $rex       = Req::post('rex');

    ///////test ////////
    /*
    $tarray = Req::post('tarray');

    $data = json_decode($tarray, true);
    $sql = 'SELECT * FROM genres WHERE genre = ? LIMIT 1;';
    $sql2 = 'SELECT * FROM machines WHERE name = ? LIMIT 1;';

    foreach ($data as $d) {
        $res = $_db->fetchRow($sql, $d);

        if (empty($res)) {
            // echo $d . "\r";

            $res = $_db->fetchRow($sql2, $d);
            if (!empty($res)) {
                echo $d . ',' . $res['genre_id'], "\r";
            }
        }
    }
    exit;
    */

    /// 会社情報のチェック ///
    $sql = 'SELECT * FROM companies WHERE id = ? AND company = ?;';
    $res = $_db->fetchRow($sql, array($companyId, $company));

    if (empty($res)) {
        throw new Exception('会社情報を取得できませんでした');
    }

    /// 既存機械情報の削除 ///
    $mModel = new Machine();
    $res = $mModel->deleteByNotUsedId(json_decode($rex, true), $companyId);

    /// 機械情報の保存 ///
    $res .= $mModel->setCrawledData($companyId, $data);

    exit($res);
} catch (Exception $e) {
    echo $e->getMessage();
}
