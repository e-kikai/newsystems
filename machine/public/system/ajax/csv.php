<?php
/**
 * AJAXでお知らせ情報変更処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/17
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    $mModel = new Machine();
    if ($action == 'setCsv') {
        if (empty($_SESSION['system_csv_data'])) {
            throw new Exception("機械データが取得できませんでした。\nCSVファイルを再アップロードしてください");
        }

        // $mModel->setCsv($_SESSION['system_csv_data'], $_user['company_id']);

        if (empty($_SESSION['system_csv_company_id'])) {
            throw new Exception('会社が選択されていません');
        } else if (empty($_SESSION['system_csv_data'])) {
            throw new Exception('機械情報がありません');
        }

        // $companyId = 2; // 楠本機械様(from 百貨店)テスト
        $companyId = $_SESSION['system_csv_company_id'];

        $fModel = new File();

        $_db->beginTransaction(); // トランザクション
        try {
            // (変更)一括削除
            $mModel->update(
                array('deleted_at' => new Zend_Db_Expr('now()')),
                $_db->quoteInto(' deleted_at IS NULL AND used_id IS NOT NULL AND company_id = ? ', $companyId)
            );

            //// 機械登録部分 ////
            foreach ($_SESSION['system_csv_data'] as $m) {
                $id = !empty($m['id']) ? $m['id'] : null;

                // (変更)更新しない、処理を飛ばす
                if ($id) {
                    $mModel->update(array('deleted_at' => null), $_db->quoteInto(' id = ? ', $id));
                    continue;
                }

                //// 画像ファイルのDL・処理 ////
                foreach($m['used_imgs'] as $i) {
                    // ファイル名の生成・格納
                    $img = 'used_' . str_replace('/', '_', $i);
                    // if ($m['top_img'] != $img && (empty($m['imgs']) || !in_array($img, $m['imgs']))) {
                        // ファイルのダウンロード
                        // $fileUri  = 'http://www.jp.usedmachinery.bz/img/jpmachines/' . $i;
                        $fileUri  = 'https://www.jp.usedmachinery.bz/assets/images/jpmachines/' . $i;

                        $tempPath = $_conf->htdocs_path . 'media/tmp' ;
                        $realPath = $_conf->htdocs_path . 'media/machine' ;
                        $filePath = $realPath . $img;

                        // @ba-ta 20141215 httpヘッダからファイルサイズを取得、更新チェック
                        $headers = @get_headers($i, true);

                        // if (!file_exists($filePath)) {
                        if (!file_exists($filePath) ||
                            (!empty($headers) && filesize($filePath) != $headers["Content-Length"])) {

                            // ファイルがない場合は、ファイルをDL
                            if ($data = @file_get_contents($fileUri)) {

                                // file_put_contents($filePath, $data);
                                file_put_contents($tempPath . '/'. $img, $data);
                                $fModel->autoOrient($tempPath . '/'. $img);

                                // サムネイル生成
                                // $fModel->makeThumbnail($realPath, $img);
                                $fModel->makeThumbnail($tempPath, $realPath, $img);

                                rename($tempPath . '/'. $img, $realPath . '/'. $img);
                            } else {
                               continue;
                            }
                        }

                        // データの格納
                        if (empty($m['top_img']))       { $m['top_img'] = $img; }
                        else if ($m['top_img'] != $img) { $m['imgs'][] = $img; }
                    // }
                }

                // 不要部分を削除
                unset($m['id'], $m['genre'], $m['capacity_unit'], $m['used_imgs']);

                // データの格納
                $m['deleted_at'] = null;
                $mModel->set($m, $id, $companyId);
            }
            $_db->commit(); // コミット
        } catch (Exception $e) {
            $_db->rollBack();
            throw new Exception($e->getMessage());
        }
    } else {
        throw new Exception('処理がありません');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
    // var_dump(B::post('c'));
}
