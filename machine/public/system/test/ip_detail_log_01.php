<?php
/**
 * ip by detail log CSV test
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2021/02/15
 */
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('system');

    //// 変数を取得 ////
    $days   = Req::query('d');
    $target = Req::query('t');

    //// パラメータ取得 ////
    $alModel = new Actionlog();

    $count = $alModel->getDetailCount($days);

    if ($target == "now") {
        $result = $alModel->getDetailByNow($days, 5, $count / 2);

        $filename = date('Ymd') . '_ip_by_detaillog.csv';
        $header   = array(
            'action_id' => '機械ID',
        );
        B::downloadCsvFile($header, $result, $filename);
    } else {
        $result = $alModel->getIPDetail($days, 5, $count / 2);

        $filename = date('Ymd') . '_ip_by_detaillog.csv';
        $header   = array(
            'ip'            => 'IP',
            // 'hostname'      => 'host',
            'action_id'     => '機械ID',
        );
        B::downloadCsvFile($header, $result, $filename);
    }

    exit;

} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
