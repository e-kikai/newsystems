<?php
/**
 * AJAXで問い合わせ処理ほか
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2012/08/10
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('machine');

    $action = Req::post('action');
    $target = Req::post('target');
    $data   = Req::post('data');

    //// 全機連サイトお問い合せ(セキュリティコードの処理を飛ばすため) ////
    if ($action == 'send') {
        // 問い合わせ処理
        $cModel = new Contact();

        $data['addr1']   = '.';
        $data['company'] = '.';
        $cModel->send($data);

        echo 'success';
        exit;
    }

    //// セキュリティコードのチェック ////
    if (!isset($_SESSION['captcha_keystring'])) {
        throw new Exception('セキュリティコードのチェックに失敗しました');
    } else if($_SESSION['captcha_keystring'] !=  $data['keystring']) {
        throw new Exception('セキュリティコードが間違っています');
    }

    if ($action == 'sendMachine') {
        //// 問い合わせ処理(在庫ページ) ////
        $data['user_id'] = !empty($_user['id']) ? $_user['id'] : NULL;

        $cModel = new Contact();
        $cModel->sendMachine($data);
    } else {
        throw new Exception('問い合わせができませんでした');
    }

    // セキュリティコードのunset
    unset($_SESSION['captcha_keystring']);

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
}
