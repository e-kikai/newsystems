<?php
/**
 * 画像特徴ベクトル処理データ入出力
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

    //// 入札会情報を取得 ////
    $mnrModel = new MachineNitamono();
    $datas    = $mnrModel->getMachineList();

    //// 商品情報一覧を取得 ////
    $filename = 'machines_new_top_imgs.csv';
    $header   = array(
        "id"      => 'id',
        "top_img" => 'top_img',
    );

    B::downloadCsvFile($header, $datas, $filename);

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
