<?php
/**
 * AJAXでのPOST処理の共通インターフェイス(管理者ページ)
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/11/12
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';

//// 管理者ページ認証 ////
Auth::isAuth('system');

try {
    if ($_SERVER["REQUEST_METHOD"] != "POST") { throw new Exception("処理がPOSTではありません"); }

    //// 変数を取得 ////
    $data   = Req::post();
    $target = Req::post('_target');
    $action = Req::post('_action');
    unset($data['_action'], $data['_target']);

    if ($target == 'company') {

        //// 会社情報 ////
        $companyTable = new Companies();

        if ($action == 'set') {
            $companyTable->set($data['company_id'], $data);
        } else if ($action == 'delete') {
            $companyTable->deleteById($data['company_id']);
        } else if ($action == 'login') {
            // 代理ログイン
            $auth = new Auth();
            $auth->systemLogin($data['company_id']);
        } else { throw new Exception('処理がありません'); }

    } else if ($target == 'companysite') {

        //// 自社サイト ////
        $companysiteTable = new Companysites();

        if ($action == 'set') {
            $companysiteTable->set($data['companysite_id'], $data);
        } else if ($action == 'delete') {
            $companysiteTable->deleteById($data['companysite_id']);
        } else { throw new Exception('処理がありません'); }

    } else if ($target == 'xlGenre') {

        //// 特大ジャンル ////
        $xlGenreTable = new XlGenres();

        if ($action == 'set') {
            $xlGenreTable->set($data['id'], $data);
        } else if ($action == 'delete') {
            $xlGenreTable->deleteById($data['id']);
        } else { throw new Exception('処理がありません'); }

    } else if ($target == 'largeGenre') {

        //// 大ジャンル ////
        $largeGenreTable = new LargeGenres();

        if ($action == 'set') {
            $largeGenreTable->set($data['id'], $data);
        } else if ($action == 'delete') {
            $largeGenreTable->deleteById($data['id']);
        } else { throw new Exception('処理がありません'); }

    } else if ($target == 'genre') {

        //// ジャンル ////
        $GenreTable = new Genres();

        if ($action == 'set') {
            $GenreTable->set($data['id'], $data);
        } else if ($action == 'delete') {
            $GenreTable->deleteById($data['id']);
        } else { throw new Exception('処理がありません'); }

    } else { throw new Exception('対象がありません'); }

    echo 'success';
} catch (Exception $e) {
    echo $e->getMessage();
}
