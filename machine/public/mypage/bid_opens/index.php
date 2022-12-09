<?php

/**
 * 入札会一覧ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/11/25
 */

require_once '../../../lib-machine.php';
/// 認証 ///
MyAuth::is_auth();

/// ユーザ情報 ///
$my_user_model = new MyUser();
$my_user       = $my_user_model->get($_my_user['id']);

/// 入札会一覧を取得 ///
$bid_open_model = new BidOpen();
$bid_opens = $bid_open_model->getList();

/// 表示変数アサイン ///
$_smarty->assign(array(
  'pageTitle'       => "入札会一覧",
  'pageDescription' => '現在までに開催された入札会の一覧です。ここから各種履歴を閲覧することもできます。',
  'pankuzu'         => array(
    '/mypage/' => 'マイページ'
  ),

  'my_user'   => $my_user,
  'bid_opens' => $bid_opens,
))->display('mypage/bid_opens/index.tpl');
