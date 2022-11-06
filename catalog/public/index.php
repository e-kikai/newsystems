<?php

/**
 * 電子カタログトップページ表示
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.2
 * @since   2012/04/19
 */
require_once '../lib-catalog.php';
try {
    /// 認証 ///
    Auth::isAuth('catalog');

    /// @ba-ta 20141231 会社情報を取得して、表示権限チェック ///
    $companyTable = new Companies();
    $company      = $companyTable->get($_user['company_id']);
    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('電子カタログの表示権限がありません');
    }

    /// メーカー一覧を取得 ///
    $cModel     = new Catalog();
    $makerList  = $cModel->getMakerList();
    $makerCount = $cModel->getMakerCount();
    $count      = $cModel->getListCount();

    // 50音列ごとに分割
    $maker50onList = B::get50onListInit();
    foreach ($makerList as $val) {
        $maker50onList[B::get50onRow($val['maker_kana'])][] = $val;
    }

    // お知らせ
    $iModel    = new Info();
    $infoList = $iModel->getList('catalog', 3);

    // ミニブログ
    $miModel      = new Miniblog();
    $miniblogList = $miModel->getList('catalog', 20);

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pankuzu'         => false,
        'pageDescription' => '工作機械のカタログを「型式で検索」か「メーカー一覧から選択」が行えます。',
        'maker50onList'   => $maker50onList,
        'makerCount'      => $makerCount,
        'count'           => $count,
        'infoList'        => $infoList,
        'miniblogList'    => $miniblogList
    ))->display("index.tpl");
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
