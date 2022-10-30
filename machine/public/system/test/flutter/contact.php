<?php
/**
 * flutter API テスト : (マシンライフから出品用)問合せ一覧取得
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

    $command = Req::query('command');

    if ($command == "list_by_company_id") {
        /// 問合せ一覧 ///
        $cModel = new Contact();
        $param = [Req::query('company_id')];
        $res    = $cModel->getList($param);
    }

    /// 結果をJSONに変換して出力 ///
    header("Content-Type: application/json; charset=utf-8");
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
