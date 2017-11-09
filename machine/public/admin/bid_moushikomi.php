<?php
/**
 * 入札申込書
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since   2016/02/24
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    
    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }
    
    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);
    
    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    
    //// PDF出力準備 ////
    $filename = $bidOpenId . '_moushikomi.pdf';
    
    require_once('fpdf/MBfpdi.php'); //PDF
    $pdf = new Pdf();
    $res = $pdf->makeMoushikomi($bidOpen, $company);
    
    //// ファイルのダウンロード処理 ////
    header("Content-type: application/pdf");
    header('Content-Disposition: inline; filename="' . $filename . '"');
    echo $res;
    exit;
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '入札履歴',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
