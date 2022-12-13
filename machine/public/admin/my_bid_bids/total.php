<?php

/**
 * 落札結果一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/12
 */

require_once '../../../lib-machine.php';
/// 認証 ///
Auth::isAuth('member');

/// 変数を取得 ///
$bid_open_id = Req::query('o');
$output      = Req::query('output');

/// 会社情報を取得 ///
$company_model = new Company();
$company = $company_model->get($_user['company_id']);

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

// 出品期間の終了チェック
$my_bid_bid_model = new MyBidBid();
$e = $my_bid_bid_model->check_end_errors($bid_open);
if (!empty($e)) throw new Exception($e);

/// 出品商品情報一覧を取得 ///
$q = array(
  'bid_open_id'    => $bid_open_id,

  'limit'          => Req::query('limit', 50),
  'page'           => Req::query('page', 1),
  'order'          => Req::query('order'),
);
$bid_machine_model = new BidMachine();
$bid_machines = $bid_machine_model->getList($q);
$bid_machines_count = $bid_machine_model->getCount($q);

/// ページャ ///
Zend_Paginator::setDefaultScrollingStyle('Sliding');
$pgn = Zend_Paginator::factory(intval($bid_machines_count));
$pgn->setCurrentPageNumber($q['page'])
  ->setItemCountPerPage($q['limit'])
  ->setPageRange(15);

/// 落札結果を取得 ///
if (in_array($bid_open['status'], array('carryout', 'after'))) {
  $ids = $my_bid_bid_model->bid_machines2ids($bid_machines);
  $bids_count  = $my_bid_bid_model->count_by_bid_machine_id($ids);
  $bids_result = $my_bid_bid_model->results_by_bid_machine_id($ids);

  $_smarty->assign(array(
    "bids_count"  => $bids_count,
    "bids_result" => $bids_result,
  ));
}

/// CSVに出力する場合 ///
// if ($output == 'csv') {
//   if (!in_array($bid_open['status'], array('carryout', 'after'))) {
//     throw new Exception("{$bid_open['title']}は現在、落札商品個別計算表の出力は行えません");
//   }

//   $filename = "{$bid_open_id}_bid_bid_list.csv";
//   $header   = array(
//     'id'         => '商品ID',
//     'list_no'    => '出品番号',
//     'name'       => '商品名',
//     'maker'      => 'メーカー',
//     'model'      => '型式',
//     'year'       => '年式',
//     'company'    => '出品会社',
//     'min_price'  => '最低入札金額',
//     'amount'     => '入札金額',
//     'comment'    => '備考欄',
//     'res_amount' => '落札金額',
//     'csv_res'    => '落札結果',
//   );
//   B::downloadCsvFile($header, $bid_machines, $filename);
//   exit;
// }

/// 表示変数アサイン ///
$_smarty->assign(array(
  'pageTitle'       => "{$bid_open["title"]} 落札結果一覧",
  'pageDescription' => '入札会の落札結果一覧です。',
  'pankuzu'          => array(
    '/admin/' => '会員ページ',
  ),

  'company'     => $company,
  'bid_open'     => $bid_open,
  "bid_machines" => $bid_machines,
  'pager'        => $pgn->getPages(),
  'cUri'         => "/admin/my_bid_bids/total.php?o={$bid_open_id}",
))->display('admin/my_bid_bids/total.tpl');
