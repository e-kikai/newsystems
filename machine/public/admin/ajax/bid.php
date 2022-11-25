<?php

/**
 * 入札会用をAJAX処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/05/13
 */
/// 設定ファイル読み込み ///
require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('member');

    if ($_SERVER["REQUEST_METHOD"] == "POST") {

        $action = Req::post('action');
        $target = Req::post('target');
        $d      = Req::post('data');

        $res = '';

        $bmModel = new BidMachine();
        $bbModel = new BidBid();

        if ($action == "set2machine") {
            $bmModel->set2machine($d['machine_id'], $_user['company_id'], $d['bid_open_id'], $d['min_price']);
        } else if ($action == "set") {
            /// 画像ファイルを実ディレクトリに移動 ///
            $f = new File();
            $imgs = !empty($d['imgs']) ? (array)$d['imgs'] : array();
            $imgsDelete = !empty($d['imgs_delete']) ? (array)$d['imgs_delete'] : array();
            $d['imgs'] = $f->check(
                $imgs,
                $imgsDelete,
                $_conf->tmp_path,
                $_conf->htdocs_path . '/media/machine',
                true
            );

            if (!empty($d['top_img'])) {
                $d['top_img'] = $f->checkOne(
                    $d['top_img'],
                    array(),
                    $_conf->tmp_path,
                    $_conf->htdocs_path . '/media/machine',
                    true
                );
            }

            // PDFの配列を処理
            $pdfs = array();
            if (!empty($d['pdfs'])) {
                foreach ($d['pdfs'] as $key => $val) {
                    $pdfs[$val] = $key;
                }
            }
            $pdfsDelete = !empty($d['pdfs_delete']) ? (array)$d['pdfs_delete'] : array();
            $d['pdfs'] = $f->check(
                $pdfs,
                $pdfsDelete,
                $_conf->tmp_path,
                $_conf->htdocs_path . '/media/machine'
            );

            // データの保存
            $bmModel->set($d, $d['id'], $_user['company_id']);
        } else if ($action == "delete") {
            $bmModel->deleteById($d['machine_id'], $_user['company_id']);
        } else if ($action == "bid") {
            $bbModel->set($d, $_user['company_id']);
        } else if ($action == "bidDelete") {
            $bbModel->deleteById($d['id'], $_user['company_id']);
        } else if ($action == "setBidEntry") {
            $cModel = new Company();
            $cModel->setBidEntries($d, $_user['company_id']);
        } else if ($action == "first") {
            $_SESSION[Auth::getNamespace()]['bid_first_flag'] = true;
        } else {
            throw new Exception('処理がありません');
        }
        echo 'success';
    }
} catch (Exception $e) {
    echo $e->getMessage();
}
