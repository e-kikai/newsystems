<?php
/**
 * 在庫管理トップページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('member');

    //// 会社情報 ////
    $companyTable = new Companies();
    $company      = $companyTable->get($_user['company_id']);

    //// ミニブログ ////
    $miModel      = new Miniblog();
    $miniblogList = $miModel->getList('machine', 20);

    //// 事務局お知らせ ////
    $iModel   = new Info();
    $infoList = $iModel->getList('member', $company['group_id'], 20);

    //// 売りたし買いたし ////
    $uModel     = new Urikai();
    $urikaiList = $uModel->getList(array('limit' => 20));

    //// 在庫総数 ////
    $mModel = new Machine();
    // $mCountAll = $mModel->getCountAll();
    $cCountByEntry = $mModel->getCountCompany();

    //// 自社サイトチェック ////
    $companysiteTable = new Companysites();
    $companysite      = $companysiteTable->getByCompanyId($_user['company_id']);

    // 入札会開催情報の取得
    $cModel      = new BidOpen();
    $bmModel     = new BidMachine();
    $bidOpenList = $cModel->getList(array('isopen' => true));

    foreach ($bidOpenList as $key => $bo) {
        //// 出品商品情報一覧を取得 ////
        $bidOpenList[$key]['count'] = $bmModel->getCount(array('bid_open_id' => $bo['id'], 'company_id' => $_user['company_id']));
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => '会員ページ',
        'pageDescription' => 'メニューを選択してください',
        'miniblogList'    => $miniblogList,
        'infoList'        => $infoList,
        'urikaiList'      => $urikaiList,
        // 'mCountAll'      => $mCountAll,
        'cCountByEntry'   => $cCountByEntry,

        'userName'        => $_user['user_name'],
        'company'         => $company['company'],
        'treenames'       => $company['treenames'],
        'rank'            => $company['rank'],

        'companysite'     => $companysite,
        'bidOpenList'     => $bidOpenList,
    ))->display('admin/index.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '在庫管理トップページ',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
