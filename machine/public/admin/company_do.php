<?php
/**
 * 会社情報変更処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');
    
    //// 会社情報を取得 ////
    $data = array(
        /*
        'company'      => Req::post('company'),
        'company_kana' => Req::post('company_kana'),
        'zip'          => Req::post('zip'),
        'addr1'        => Req::post('addr1'),
        'addr2'        => Req::post('addr2'),
        'addr3'        => Req::post('addr3'),
        'tel'          => Req::post('tel'),
        'fax'          => Req::post('fax'),
        'mail'         => Req::post('mail'),
        'website'      => Req::post('website'),
        */
        'officer'      => Req::post('officer'),
        'contact_tel'  => Req::post('contact_tel'),
        'contact_fax'  => Req::post('contact_fax'),
        'contact_mail' => Req::post('contact_mail'),
        'infos'        => Req::post('infos'),
    );
    
    /// 画像ファイルを実ディレクトリに移動 ////
    $f = new File();
    $data['imgs'] = $f->check(
        (array)Req::post('imgs'), 
        (array)Req::post('imgs_delete'), 
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/company'
    );
    $data['top_img'] = $f->checkOne(
        Req::post('top_img'),
        Req::post('top_img_delete'),
        $_conf->tmp_path,
        $_conf->htdocs_path . '/media/company/'
    );
    
    //// 営業所情報 ////
    $names       = (array)Req::post('offices_name');
    $officeZip   = (array)Req::post('offices_zip');
    $officeAddr1 = (array)Req::post('offices_addr1');
    $officeAddr2 = (array)Req::post('offices_addr2');
    $officeAddr3 = (array)Req::post('offices_addr3');
    $officeLat   = (array)Req::post('offices_lat');
    $officeLng   = (array)Req::post('offices_lng');
    
    $offices   = array();
    foreach ($names as $key => $name) {
        if (!empty($name)) {
            $offices[] = array(
                'name'  => $name,
                'zip'   => $officeZip[$key],
                'addr1' => $officeAddr1[$key],
                'addr2' => $officeAddr2[$key],
                'addr3' => $officeAddr3[$key],
                'lat'   => $officeLat[$key],
                'lng'   => $officeLng[$key],
            );
        }
    }
    $data['offices'] = $offices;

    // データの保存
    $cModel = new Company();
    $cModel->set($_user['company_id'], $data);
    
    header('Location: /admin/');
    exit;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '会社情報の変更',
        'pageDescription' => '会社情報の変更を行うフォームです',
        'pankuzu'         => array('admin/' => '在庫管理'),
        'company'         => $data,
        'errorMes'        => $e->getMessage()
    ))->display('admin/company_form.tpl');
}
