<?php
/**
 * 画像特徴ベクトル処理データ保存
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/05/11
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    // Auth::isAuth('machine');

    //// 変数を取得 ////
    $rawData = file_get_contents("php://input");
    $json    = json_decode($rawData, true);

    //// 入札会情報を取得 ////
    $mnrModel = new MachineNitamono();

    foreach ($json as $d) {
        $mnrModel->set([
            "machine_id"  => (int)($d[0]),
            "nitamono_id" => (int)($d[1]),
            "norm"        => (float)($d[2]),
        ]);
        $mnrModel->set([
            "machine_id"  => (int)($d[1]),
            "nitamono_id" => (int)($d[0]),
            "norm"        => (float)($d[2]),
        ]);
    }

} catch (Exception $e) {
    //// エラー画面表示 ////
    header("HTTP/1.1 404 Not Found");
    $_smarty->assign(array(
        'pageTitle' => '出品機械一覧',
        'pankuzu'   => array(
            '/system' . "管理者ページ",
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
