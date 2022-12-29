<?php

/**
 * 詳細ログ一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/27
 */

require_once '../../../lib-machine.php';

/// 認証処理 ///
Auth::isAuth('system');

/// 変数を取得 ///
$page  = Req::query('page', 1);
$limit = Req::query('limit', 50);
$bid_open_id = Req::query('o');

/// 入札会情報を取得 ///
$bid_open_model = new BidOpen();
$bid_open = $bid_open_model->get($bid_open_id);

// 詳細ログ一覧の取得
$bid_detail_log_model = new BidDetailLog();

$select = $bid_detail_log_model->select()->from('bid_detail_logs', 'count(*) as count');
$res = $bid_detail_log_model->fetchRow($select);
$count = $res["count"];

$select = $bid_detail_log_model->select()->setIntegrityCheck(false)->from("bid_detail_logs", "*")
  ->joinLeft("bid_machines", "bid_machines.id = bid_detail_logs.bid_machine_id",  ["list_no", "name", "maker", "model", "min_price", "top_img", "company_id"])
  ->joinLeft("my_users", "my_users.id = bid_detail_logs.my_user_id", ["uniq_account", "user_name" => "name", "user_company" => "company"])
  ->joinLeft("companies", "companies.id = bid_machines.company_id", ["company"])
  ->where("bid_machines.bid_open_id = ?", $bid_open_id)
  ->limitPage($page, $limit)->order("bid_detail_logs.id DESC");
$bid_detail_logs = $bid_detail_log_model->fetchAll($select);

/// ページャ ///
Zend_Paginator::setDefaultScrollingStyle('Sliding');
$pgn = Zend_Paginator::factory(intval($count));
$pgn->setCurrentPageNumber($page)
  ->setItemCountPerPage($limit)
  ->setPageRange(15);
$cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
if (!preg_match("/\?/", $cUri)) $cUri .= '?';

/// 表示変数アサイン ///
$_smarty->assign(array(
  'pageTitle' => "{$bid_open["title"]} 詳細ログ一覧",
  'pankuzu'   => array(
    '/system/' => '管理者ページ',
  ),
  'pager'     => $pgn->getPages(),
  'cUri'      => $cUri,

  'bid_detail_logs'  => $bid_detail_logs,
))->display('system/bid_detail_logs/index.tpl');
