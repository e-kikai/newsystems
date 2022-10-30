<?php
/**
 * 在庫機械情報の追加・変更処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/08/18
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');

    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'A会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    //// 在庫機械情報を取得 ////
    $id = Req::post('id');
    $data = array(
        'no'         => Req::post('no'),
        'name'       => Req::post('name'),
        'genre_id'   => Req::post('genre_id'),
        'maker'      => Req::post('maker'),
        'model'      => Req::post('model'),
        'catalog_id' => Req::post('catalog_id'),
        'year'       => Req::post('year'),
        'capacity'   => Req::post('capacity'),
        'others'     => Req::post('others'),
        'accessory'  => Req::post('accessory'),
        'spec'       => Req::post('spec'),
        'comment'    => Req::post('comment'),
        'commission' => Req::post('commission'),
        'location'   => Req::post('location'),
        'location_address' => Req::post('location_address'),
        'youtube'    => Req::post('youtube'),
        'view_option' => Req::post('view_option'),

        'addr1' => Req::post('addr1'),
        'addr2' => Req::post('addr2'),
        'addr3' => Req::post('addr3'),
        'lat'   => Req::post('lat'),
        'lng'   => Req::post('lng'),

        'price'     => Req::post('price'),
        'price_tax' => Req::post('price_tax'),

        'used_change' => Req::post('used_change'),

        // 入札会商品からの登録
        'bid_machine_id' => Req::post('bid_machine_id'),

        // 独自ラベル
        // 'label_title' => Req::post('label_title'),
        // 'label_url'   => Req::post('label_url'),
        // 'label_color' => Req::post('label_color'),
    );

    /// 画像ファイルを実ディレクトリに移動 ////
    $f = new File();
    $data['imgs'] = $f->check(
        (array)Req::post('imgs'),
        (array)Req::post('imgs_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/machine',
        true
    );
    $data['top_img'] = $f->checkOne(
        Req::post('top_img'),
        Req::post('top_img_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/machine',
        true
    );

    // PDFの配列を処理
    $pdfs = array();
    foreach ((array)Req::post('pdfs') as $key => $val) {
        $pdfs[$val] = $key;
    }
    $data['pdfs'] = $f->check(
        $pdfs,
        (array)Req::post('pdfs_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/machine'
    );

    // データの保存
    $mModel = new Machine();
    $mModel->set($data, $id, $_user['company_id']);

    $_SESSION['_temp']['message'][] = '在庫機械情報を変更しました';

    $bidOpenId = Req::post('bid_open_id');
    if (!empty($bidOpenId)) {
        header('Location: /admin/bid_machine_list.php?o=' . $bidOpenId);
    } else {
        header('Location: /admin/machine_list.php');
    }

    exit;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '在庫機械の変更',
        'pankuzu'   => array(
            '/admin/'                 => '在庫管理',
            '/admin/machine_list.php' => '在庫機械一覧'
        ),

        'company'         => $data,
        'errorMes'        => $e->getMessage()
    ))->display('admin/machine_form.tpl');
}
