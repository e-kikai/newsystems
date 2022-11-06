<?php

/**
 * 新着メール test
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once dirname(__FILE__) . '/../lib-machine.php';
try {
  //// 認証 ////
  // Auth::isAuth('system');

  //// パラメータ取得 ////
  $date = date("Y-m-d", strtotime("-1 day"));

  $sql = "SELECT
      l.id,
      l.large_genre,
      count(m.*) as count
    FROM
      large_genres l
      LEFT JOIN xl_genres x
        ON x.id = l.xl_genre_id
      LEFT JOIN genres g
        ON g.large_genre_id = l.id
      LEFT JOIN machines m
        ON m.genre_id = g.id
      LEFT JOIN companies c
        ON c.id = m.company_id
    WHERE
      c.deleted_at IS NULL AND
      CAST (m.created_at AS DATE) = ? AND
      m.deleted_at IS NULL AND
      (m.view_option IS NULL OR m.view_option <> 1)
    GROUP BY
      l.id,
      x.order_no
    ORDER BY
      x.order_no,
      l.order_no;";
  $result = $_db->fetchAll($sql, $date);

  //// 機械詳細を取得 ////
  $mModel = new Machine();
  $q = array('date' => $date);
  $mresult = $mModel->search($q);

  //// 入札会情報を取得 ////
  // $sql = "SELECT
  //   *
  // FROM
  //   bidinfos b
  // WHERE
  //   (
  //     bid_date > now() OR
  //     preview_end_date > current_date
  //   )
  //   AND deleted_at IS NULL
  // ORDER BY
  //   created_at DESC;";
  // $bidinfoList = $_db->fetchAll($sql);

  //// 入札会バナー情報を取得 ////
  $bModel      = new Bidinfo();
  $bidinfoList = $bModel->getList(array('sort' => "bid_date"));

  //// メール送信ユーザの取得 ////
  $muModel = new Mailuser();
  $mailuserList = $muModel->getList();

  if (!empty($result) && !empty($mailuserList)) {
    $count = 0;
    foreach ($result as $l) {
      $count += $l['count'];
    }

    //// 表示変数アサイン ////
    $body = $_smarty->assign(array(
      'largeGenreList' => $result,
      'machineList'    => $mresult['machineList'],
      'bidinfoList'    => $bidinfoList,
      'date'           => $date,
      'count'          => $count,
    ))->fetch('scripts/mailtest_03.tpl');
    $subject = 'マシンライフ新着中古機械情報(' . date("Y/m/d", strtotime($date)) . ')';

    // test
    // exit($body);

    // メール送信処理
    $maModel = new Mailsend();
    /*
        $maModel->sendMail('qqgx76kd@galaxy.ocn.ne.jp', null, $body, $subject, null, 'html');
        $maModel->sendMail('kazuyoshih@gmail.com', null, $body, $subject, null, 'html');
        $maModel->sendMail('jimukyoku@zenkiren.net', null, $body, $subject, null, 'html');
        $maModel->sendMail('tsuneyama@omdc.or.jp', null, $body, $subject, null, 'html');
        */

    foreach ($mailuserList as $m) {
      $maModel->sendMail($m['mail'], null, $body, $subject, null, 'html');
    }
  }
} catch (Exception $e) {
  //// 表示変数アサイン ////
  echo 'システムエラー';
  echo '<pre>';
  echo $e->getMessage();
  echo '</pre>';
}
