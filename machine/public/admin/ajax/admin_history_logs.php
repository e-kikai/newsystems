<?php

/**
 * 分析ログをAJAX処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2023/08/06
 */
/// 設定ファイル読み込み ///
require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('member');

    if (!Company::check_sp($_user["company_id"])) throw new Exception("このページの閲覧権限がありません。");

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        /// 変数取得 ///
        $post = json_decode(file_get_contents('php://input'), true);

        /// ロギング ///
        $admin_history_log_model = new AdminHistoryLog();
        $admin_history_log_model->write($_user, $post["page"],  $post["event"],  $post["datas"]);

        echo 'success';
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
