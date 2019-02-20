<?php
/**
 * 売り買い一覧ページ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2019/02/08
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    $user = Auth::isAuth('member');

    $r = Req::query('r');

    //// 売り買い一覧を取得 ////
    $fModel = new Urikai();

    $aq = array(
        'company_id' => $_user["company_id"],
        'goal'      => Req::query('goal'),
        'is_notend' => Req::query('is_notend'),
    );
    $q = $aq + array(
        'limit'       => Req::query('limit', 30),
        'page'        => Req::query('page', 1),
    );
    $urikaiList = $fModel->getList($q);
    $count      = $fModel->getCount($aq);

    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => '売りたし買いたし一覧',
        'pankuzu'    => array('admin/' => '会員ページ'),
        'urikaiList' => $urikaiList,
        'pager'      => $pgn->getPages(),
        'cUri'       => "/admin/urikai_list.php?",
        // 'message'    => $message,
    ))->display("admin/urikai_list.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'    => '売りたし買いたし一覧',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
