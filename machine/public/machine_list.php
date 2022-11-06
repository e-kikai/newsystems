<?php

/**
 * 在庫機械一覧情報ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('machine');

    /// 在庫情報を検索 ///
    $q = array(
        'large_genre_id' => Req::query('l'),
        'genre_id'       => Req::query('g'),
        'company_id'     => Req::query('c')
    );
    $mModel = new Machine();
    $result = $mModel->search($q);

    /// 大ジャンル一覧を取得 ///
    $gModel = new Genre();
    $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);

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

    // カレントURL、ページタイトル生成
    $cUri = array();
    $pageTitle = array();
    foreach ($result['queryDetail'] as $val) {
        $pageTitle[] = $val['label'];
        $cUri[] = $val['key'] . '[]=' . $val['id'];
    }

    if (empty($result['machineList'])) {
        $_smarty->assign('message', 'この条件の機械は現在登録されていません');
    }

    /// リファラ処理 ///
    // デフォルト
    $backUri   = '';
    $backTitle = '';
    $pankuzu = array();

    // ジャンルと会社で検索した時のみ
    if (!empty($q['large_genre_id']) && !empty($q['company_id']) && !empty($_SERVER['HTTP_REFERER'])) {
        $ref = urldecode($_SERVER['HTTP_REFERER']);

        if (strstr($ref, 'machine_list.php')) {
            $backUri   = $ref;
            $backTitle = '検索結果';
            $pankuzu = array($ref => '検索結果');
        } elseif (strstr($ref, 'news.php')) {
            $backUri   = $ref;
            $backTitle = '新着情報';
            $pankuzu = array($ref => '新着情報');
        } elseif (strstr($ref, 'mylist.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(在庫機械)';
            $pankuzu = array($ref => 'マイリスト(在庫機械)');
        } elseif (strstr($ref, 'company_list.php')) {
            $backUri   = $ref;
            $backTitle = '会社一覧';
            $pankuzu = array($ref => '会社一覧');
        } elseif (strstr($ref, 'mylist_company.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(会社)';
            $pankuzu = array($ref => 'マイリスト(会社)');
        }
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'   => implode(' /', $pageTitle) . ' :: 検索結果',
        'pankuzu'     => $pankuzu,
        'cUri'        => 'machine_list.php?' . implode('&', $cUri),
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        'companyList' => $result['companyList'],
        'addr1List'   => $result['addr1List'],
        'queryDetail' => $result['queryDetail'],
        'largeGenreList' => $largeGenreList,
        'largeGenreId' => Req::query('l'),
        'tp'          => $tp,
        'noCompanyFlag' => Req::query('c') ? true : false
    ))->display('machine_list.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => '検索結果',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
