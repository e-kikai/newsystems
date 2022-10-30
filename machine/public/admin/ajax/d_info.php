<?php
/**
 * 大宝機械自社サイトお知らせをAJAX処理
 *
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/11/10
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    $diModel = new DInfo();

    // 会社情報変更処理
    $id = !empty($data['id']) ? $data['id'] : NULL;

    /// 変更チェック ///
    if (!empty($id)) {
        $dInfo   = $diModel->get($_user['company_id'], $id);
        if (empty($dInfo)) { throw new Exception('このお知らせは自社のものではありません'); }
    }

    if ($action == 'set') {
        // 会社情報変更処理
        $q = array(
            'info_date'  => $data['info_date'],
            'company_id' => $_user['company_id'],
            'title'      => $data['title'],
            'contents'   => $data['contents'],
        );
        $diModel->set($_user['company_id'], $id, $q);
    } else if ($action == "delete") {
        if (empty($id)) { throw new Exception('削除するお知らせIDがありません'); }
        $diModel->deleteById($_user['company_id'], $id);
    } else {
        throw new Exception('処理がありません');
    }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
}
