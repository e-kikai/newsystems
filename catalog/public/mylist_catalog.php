<?php
/**
 * 電子カタログマイリストページ表示
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.2
 * @since   2012/04/19
 */
require_once '../lib-catalog.php';
try {
    //// 認証 ////
    Auth::isAuth('catalog');

    //// @ba-ta 20141231 会社情報を取得して、表示権限チェック ////
    $companyTable = new Companies();
    $company      = $companyTable->get($_user['company_id']);
    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('電子カタログの表示権限がありません');
    }
    
    $q = array(
        'mylist'    => $_user['id'],
        'page'      => Req::query('p', 1),
        'order'     => Req::query('o'),
    );
    
    //// 電子カタログ情報を取得 ////
    $cModel = new Catalog();
    $result = $cModel->search($q);
    
    // テンプレートの格納・取得
    $view = $cModel->template(Req::query('v'));
    setcookie('catalog_view', $view, 0, '/');
    
    if (empty($result['catalogList'])) {
        $_smarty->assign('message', 'マイリストには現在登録されていません');
    }
    
    /*
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $paginator = Zend_Paginator::factory(intval($count));
    $paginator->setCurrentPageNumber($page)
              ->setItemCountPerPage($limit);
    */
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'マイリスト(電子カタログ)',
        'cUrl'        => 'mylist_catalog.php',
        'catalogList' => $result['catalogList'],
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'queryDetail' => $result['queryDetail']['detail'],
        'v'         => $view,
        // 'pager'     => $paginator->getPages(),
    ))->display("catalog_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
