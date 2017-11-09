<?php
/**
 * 自社サイト在庫一覧ページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/04/11
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// パラメータ取得 ////

    //// URLから自社サイト情報の取得 ////
    $companysiteTable = new Companysites();
    $site             = $companysiteTable->getByUrl($_SERVER['REQUEST_URI']);

    //// このページは在庫機械のページなので、A会員のみ表示 ////
    if ($site['rank'] < Companies::RANK_A) { throw new Exception('在庫機械のページはありません'); }

    //// 自社在庫機械情報を取得 ////
    $q = array(
        'company_id'     => $site['company_id'],        
        'large_genre_id' => Req::query('l'),
        'genre_id'       => Req::query('g'),
        'maker'          => Req::query('m'),
        'keyword'        => Req::query('k'),

        // 'sort'        => 'created_at'
        
        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
    );
    $mModel = new Machine();
    $result = $mModel->search($q);
    foreach($result['machineList'] as $key => $m) {
        $oSpec = $mModel->makerOthers($m['spec_labels'], $m['others']);
        if (!empty($oSpec)) {
            $result['machineList'][$key]['spec'] = $oSpec . ' | ' . $m['spec'];
        }
    }
    
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($result['count']));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);
        
    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) { $cUri.= '?'; }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pankuzu'     => false,
        'pageTitle'   => '在庫一覧 - ' . $site['company'],
        'site'        => $site,
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        'pager'       => $pgn->getPages(),
        'cUri'        => $cUri,
        
        'q'           => $q,
    ))->display('companysite/machine_list.tpl');

} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
