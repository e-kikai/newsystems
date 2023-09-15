<?php

/**
 * 自社ユーザ入札一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/28
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

// // 出品期間のチェック
$my_bid_bid_model = new MyBidBid();
// $e = $my_bid_bid_model->check_date_errors($bid_open);
// if (!empty($e)) throw new Exception($e);

// 入札一覧の取得
$select = $my_bid_bid_model->my_select()
    ->join("bid_machines", "bid_machines.id = my_bid_bids.bid_machine_id",  ["list_no", "name", "maker", "model", "min_price", "top_img", "company_id"])
    ->join("my_users", "my_users.id = my_bid_bids.my_user_id", ["uniq_account"])
    ->where("bid_machines.company_id = ?", $_user['company_id'])
    ->where("bid_machines.bid_open_id = ?", $bid_open_id);

// $my_bid_bids = $bid_open_model->fetchAll($select);
$my_bid_bids = $_db->fetchAll($select);

/// 落札結果を取得 ///
if (in_array($bid_open['status'], array('carryout', 'after'))) {
    $ids = $my_bid_bid_model->bid_machines2ids($my_bid_bids, "bid_machine_id");
    $bids_count  = $my_bid_bid_model->count_by_bid_machine_id($ids);
    $bids_result = $my_bid_bid_model->results_by_bid_machine_id($ids);

    $_smarty->assign(array(
        "bids_count"  => $bids_count,
        "bids_result" => $bids_result,
    ));
}
// /// CSVに出力する場合 ///
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
//   B::downloadCsvFile($header, $bidBidList, $filename);
//   exit;
// }

/// 表示変数アサイン ///
$_smarty->assign(array(
    'pageTitle'       => "{$bid_open["title"]} 自社出品への入札履歴",
    'pageDescription' => 'あなたの会社が出品した商品への入札履歴です。',
    'pankuzu'          => array(
        '/admin/' => '会員ページ',
    ),

    'bid_open'    => $bid_open,
    'company'     => $company,
    'my_bid_bids' => $my_bid_bids,
))->display('admin/my_bid_bids/index.tpl');
