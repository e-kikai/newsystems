<?php

/**
 * ユーザ入札結果一覧
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/25
 */

require_once '../../../lib-machine.php';
/// 認証 ///
MyAuth::is_auth();

/// 変数を取得 ///
$bid_open_id = Req::query('o');
$output      = Req::query('output');

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

// 出品期間のチェック
$my_bid_bid_model = new MyBidBid();
$e = $my_bid_bid_model->check_date_errors($bid_open);

if (!empty($e)) throw new Exception($e);

/// 出品商品情報一覧を取得 ///
$q = array(
    'bid_open_id'    => $bidOpenId,
    'limit'          => Req::query('limit', 50),
    'page'           => Req::query('page', 1),
    'order'          => Req::query('order'),
);
$bmModel = new BidMachine();
$bidMachineList = $bmModel->getList($q);
$count          = $bmModel->getCount($q);

// ジャンル・地域一覧を取得
$sq = array('bid_open_id' => $bidOpenId);
$xlGenreList    = $bmModel->getXlGenreList($sq);
$largeGenreList = $bmModel->getLargeGenreList($sq);
$stateList      = $bmModel->getStateList($sq);
$regionList     = $bmModel->getRegionList($sq);
$countAll       = $bmModel->getCount($sq);

if (in_array($bidOpen['status'], array('carryout', 'after'))) {
    // 落札結果を取得
    $resultListAsKey = $bmModel->getResultListAsKey($bidOpenId);

    $_smarty->assign(array(
        'resultListAsKey' => $resultListAsKey,

        'pageTitle'        => $bidOpen['title'] . ' : 落札結果',
        'pageDescription'  => '入札会落札結果です。出品者へのお問い合せを行えます',
    ));
} else {
    $_smarty->assign(array(
        'pageTitle'        => $bidOpen['title'] . ' : 入札会商品リスト',
        'pageDescription'  => '入札会商品リストです。出品者へのお問い合せ、入札を行えます',
    ));
}

/// CSVに出力する場合 ///
if ($output == 'csv') {
    $filename = $bidOpenId . '_bid_list.csv';
    $header   = array(
        'id'            => '商品ID',
        'list_no'       => '出品番号',
        'name'          => '商品名',
        'maker'         => 'メーカー',
        'model'         => '型式',
        'year'          => '年式',
        'addr1'         => '出品地域',
        'capacity'      => '能力',
        'spec'          => '仕様',
        'min_price'     => '最低入札金額',
    );
    B::downloadCsvFile($header, $bidMachineList, $filename);
    exit;
}

/// ページャ ///
Zend_Paginator::setDefaultScrollingStyle('Sliding');
$pgn = Zend_Paginator::factory(intval($count));
$pgn->setCurrentPageNumber($q['page'])
    ->setItemCountPerPage($q['limit'])
    ->setPageRange(15);

$cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
if (!preg_match("/\?/", $cUri)) {
    $cUri .= '?';
}

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pankuzu'          => array(
        '/admin/' => '会員ページ',
    ),
    'bidOpenId'      => $bidOpenId,
    'bidOpen'        => $bidOpen,
    'bidMachineList' => $bidMachineList,
    'largeGenreList' => $largeGenreList,
    'regionList'     => $regionList,
    'stateList'      => $stateList,
    'xlGenreList'    => $xlGenreList,
    'count'          => $count,
    'countAll'       => $countAll,
    'pager'          => $pgn->getPages(),
    'cUri'           => $cUri,

    'q' => $q,

    'resultListCompanyAsKey' => $resultListCompanyAsKey,
))->display("admin/bid_list.tpl");
