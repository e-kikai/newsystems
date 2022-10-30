<?php
/**
 * flutter API テスト : 入札会在庫一覧取得
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

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $command = Req::post('c');

        if ($command == "login") {
            /// ログイン処理 ///
            $account = Req::post('account');
            $passwd  = Req::post('passwd');

            $auth = new Auth();
            $auth->login($account, $passwd, false);

            if ($auth == true) {
                /// 会社情報取得 ///
                $id = $_SESSION[self::$_namespace]["id"];

                $companyTable = new Companies();
                $res          = $companyTable->get($id);

                http_response_code(201); // 認証成功
            } else {
                http_response_code(401); // 認証失敗
            }
        }
    } else {
        $command = Req::query('c');

        if ($command == "get") {
            /// 会社情報取得 ///
            $id = Req::query('id');

            $companyTable = new Companies();
            $res          = $companyTable->get($id);
        }
    }

    /// 結果をJSONに変換して出力 ///
    header("Content-Type: application/json; charset=utf-8");
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
