<?php

/**
 * 新着RSS
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2019/07/25
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// パラメータ取得 ///
    $mail = Req::query('mail');

    // 新着情報取得日数
    $news = $_conf->news;

    /// 新着情報を取得 ///
    $mModel = new Machine();
    if (!empty($mail)) {
        // $newMachineList = $mModel->getList(array('period' => 1, 'sort' => 'img_random', 'limit' => 12));
        $newMachineList = $mModel->getList(array('period' => 7, 'sort' => 'img_random', 'limit' => 12));
    } else {
        $newMachineList = $mModel->getList(array('period' => $news, 'sort' => 'created_at', 'limit' => 300));
    }

    /// XML出力 ///
    header("Content-Type: text/xml");
    header("Content-Disposition: inline");

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pankuzu'          => false,
        'mail'             => $mail,
        'newMachineList'   => $newMachineList,
    ))->display('rss.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
