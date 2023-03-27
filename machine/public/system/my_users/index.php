<?php

/**
 * 入札会ユーザ一覧ページ
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
$limit = Req::query('limit', 100);

$my_user_model = new MyUser();

// ユーザ一覧の取得
$count = $my_user_model->my_count();
$select = $my_user_model->my_select()->limitPage($page, $limit);
$my_users = $my_user_model->fetchAll($select);

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
  'pageTitle' => "入札会ユーザ一覧",
  'pankuzu'   => array(
    '/system/' => '管理者ページ',
  ),
  'pager'     => $pgn->getPages(),
  'cUri'      => $cUri,

  'my_users'  => $my_users,
))->display('system/my_users/index.tpl');
