<?php
/**
 * 電子カタログダウンロード + 電子透かし
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.2
 * @since   2012/04/19
 */
require_once '../lib-catalog.php';
try {
    //// 認証 ////
    // Auth::isAuth('catalog');

    //// @ba-ta 20141231 会社情報を取得して、表示権限チェック ////
    // $companyTable = new Companies();
    // $company      = $companyTable->get($_user['company_id']);
    // if (!Companies::checkRank($company['rank'], 'B会員')) {
    //     throw new Exception('電子カタログの表示権限がありません');
    // }

    // 表示かDLか
    $disposition = Req::query('dl') ? 'attachment' : 'inline';

    //// 電子カタログ情報を取得 ////
    $id      = Req::query('id');
    $cTable  = new Catalog();
    $catalog = $cTable->get($id);

    // test
    $style = Req::query('s');

    //// ファイル名 ////
    // ダウンロードさせる元ファイル
    if ($style == 1) {
        $source = $_conf->catalog_dir . $catalog['uid'] . '_s.pdf';
    } else if ($style == 2) {
        $source = $_conf->catalog_dir . $catalog['uid'] . '_p.pdf';
    } else {
        $source = $_conf->catalog_dir . $catalog['uid'] . '.pdf';
    }

    // // ダウンロードさせる元ファイル
    // if ($style == 1) {
    //     $source = $_conf->catalog_path . '/' . $catalog['uid'] . '_s.pdf';
    // } else if ($style == 2) {
    //     $source = $_conf->catalog_path . '/' . $catalog['uid'] . '_p.pdf';
    // } else {
    //     $source = $_conf->catalog_path . '/' . $catalog['uid'] . '.pdf';
    // }

    // 保存時のファイル名(デフォルト)
    $filename = "{$catalog['maker']}_{$catalog['uid']}.pdf";

    //// ファイル有無のチェック ////
    if (empty($catalog)) {
        throw new Exception("カタログ情報が取得できませんでした(id : {$id})");
    // } else if (!file_exists($source)) {
    //     throw new Exception("カタログPDFファイルがありません(id : {$source}, file : {$filename})");
    }

    // //// 電子透かし ////
    // $pdf = Zend_Pdf::load($source);
    //
    // // $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);
    // $img  = Zend_Pdf_Image::imageWithPath('./imgs/header_logo_over.png');
    //
    // // 電子透かし画像の埋め込み
    // foreach($pdf->pages as $key => $p) {
    //     $pdf->pages[$key]->drawImage($img, 10, 10, 130, 60);
    // }

    $res = file_get_contents($source);

    //// ファイルのダウンロード処理 ////
    header("Content-type: application/pdf");
    header("Content-Disposition: {$disposition}; filename=\"{$filename}\"");
    // echo $pdf->render();
    echo $res;

    // アクションロギング
    $lModel = new Actionlog();
    $lModel->set('catalog', 'PDF', $id);

    exit;
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'PDFファイルダウンロードエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
