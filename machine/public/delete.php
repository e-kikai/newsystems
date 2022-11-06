<?php

/**
 * 売却情報ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/09/22
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 新着情報取得日数取得 ///
    $period = Req::query('pe');
    $date   = Req::query('input_date');

    // 日付計算
    $news = $_conf->news;  // 初期値(7days)
    if ($period == 'input' && !empty($date)) {
        $news = (time() - strtotime($date)) / (60 * 60 * 24);
    } else if (intval($period)) {
        $news = $period;
    } else {
        $period = $_conf->news;  // 初期値(7days)
    }

    /// 新着情報を取得 ///
    $mModel = new Machine();
    $result = $mModel->search(array('news' => $news, 'delete' => 'delete'));

    // テンプレートの格納・取得
    $p = Req::query('p');
    if (!empty($p)) {
        $tp = $mModel->template(Req::query('p'));
        if (Req::query('c') && $tp == 'company') {
            $tp = 'list';
        }
    } else {
        $tp = 'list';
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => '売却情報',
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        'companyList' => $result['companyList'],
        'tp'          => $tp,
        'cUrl'        => 'delete.php?',

        'period'      => $period,
        'input_date'  => $date,
    ))->display('machine_list.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '新着情報',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
