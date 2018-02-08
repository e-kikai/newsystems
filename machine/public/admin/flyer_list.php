<?php
/**
 * チラシメール一覧ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2017/10/16
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    $user = Auth::isAuth('member');

    $r = Req::query('r');

    //// チラシメール一覧を取得 ////
    $fModel = new Flyer();

    $aq = array(
        'company_id'  => $_user['company_id'],
    );
    $q = $aq + array(
        'limit'       => Req::query('limit', 20),
        'page'        => Req::query('page', 1),
    );
    $flyerList = $fModel->getList($q);
    $count     = $fModel->getCount($aq);

    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);

    /// reports取得 ///
    $campaignList = array();
    $reportList   = array();
    foreach ($flyerList as $f) {
      if (empty($f["campaign"])) { continue; }
      $campaignList[$f["campaign"]] = $fModel->apiGetCampaign($f, $_conf);
      $reportList[$f["campaign"]] = $fModel->apiGetReport($f, $_conf);
    }

    $message = "";
    if (!empty($r)) {
        if ($r == "send") {
            $message = "チラシメールの配信を開始しました\n結果レポートは順次一覧に表示されます";
        } else if ($r == 'schedule') {
            $message = "チラシメールの配信スケジュールを設定しました\n開始時間になると自動的に送信されます";
        } else if ($r == 'unschedule') {
            $message = "チラシメールの配信スケジュールをキャンセルしました";
        } else if ($r == 'sended') {
            $message = "このチラシメールは、既に配信済みです";
        } else if ($r == 'copy') {
            $message = "チラシメールを複製しました";
        } else if ($r == 'copy_error') {
            $message = "チラシメールの複製に失敗しました";
        } else if ($r == 'delete') {
            $message = "チラシメールを削除しました";
        } else if ($r == 'delete_error') {
            $message = "チラシメールの削除に失敗しました";
        }
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'    => 'チラシメール一覧',
        'pankuzu'      => array('admin/' => '会員ページ'),
        'flyerList'    => $flyerList,
        'campaignList' => $campaignList,
        'reportList'   => $reportList,
        'pager'        => $pgn->getPages(),
        'cUri'         => "/admin/flyer_list.php?",

        'message'      => $message,
    ))->display("admin/flyer_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'チラシメール一覧',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
