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
    
    //// 在庫機械情報を取得 ////
    $id = Req::post('id');
    $data = array(
        'bid_open_id' =>  Req::post('bid_open_id'),
        'machine_id'  =>  Req::post('machine_id'),
        'min_price'   => Req::post('min_price'),
        
        'name'       => Req::post('name'),
        'genre_id'   => Req::post('genre_id'),
        'maker'      => Req::post('maker'),
        'model'      => Req::post('model'),
        'year'       => Req::post('year'),
        'capacity'   => Req::post('capacity'),
        'others'     => Req::post('others'),
        'accessory'  => Req::post('accessory'),
        'spec'       => Req::post('spec'),
        'comment'    => Req::post('comment'),
        'commission' => Req::post('commission'),
        'location'   => Req::post('location'),
        'youtube'    => Req::post('youtube'),
        'view_option' => Req::post('view_option'),
        
        'addr1' => Req::post('addr1'),
        'addr2' => Req::post('addr2'),
        'addr3' => Req::post('addr3'),
        'lat'   => Req::post('lat'),
        'lng'   => Req::post('lng'),
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
    
    // データの保存
    $bmModel = new BidMachine();
    $bmModel->set($data, $id, $_user['company_id']);
    
    $_SESSION['_temp']['message'][] = '在庫機械情報を変更しました';
    
    header('Location: /admin/bid_machine_list.php?o=' . $data['bid_open_id']);
    exit;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '入札会商品の変更',
        'pankuzu'   => array(
            '/admin/'                 => '会員ページ',
            '/admin/bid_machine_list.php' => '入札会商品一覧'
        ),

        'company'         => $data,
        'errorMes'        => $e->getMessage()
    ))->display('admin/bid_machine_form.tpl');
}

