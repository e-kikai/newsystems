<?php
/**
 * 会員入札会商品リスト
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/16
 */
require_once '../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');
    
    //// 変数を取得 ////
    $companybidOpenId = Req::query('o');
    if (empty($companybidOpenId)) { throw new Exception('会員入札会情報が指定されていません'); }
    
    //// 入札会情報を取得 ////
    $companybidOpenTable = new CompanybidOpens();
    $companybidOpen      = $companybidOpenTable->get($companybidOpenId);
    if (empty($companybidOpen)) {
        throw new Exception('会員入札会情報が取得出来ませんでした');
    } else if (date('Y/m/d', strtotime($companybidOpen['bid_date'])) < date('Y/m/d')) {
        throw new Exception($companybidOpen['title'] . 'は、終了しました');
    }
    
   //// 出品商品情報一覧を取得 ////
    $companybidMachineTable = new CompanybidMachines();
    $q = array(
        'companybid_open_id' => $companybidOpenId,
        'xl_genre_id'        => Req::query('x'),
        'large_genre_id'     => Req::query('l'),
        'location'           => Req::query('lo'),

        'list_no'            => Req::query('no'),
        
        'limit'              => Req::query('limit', 50),
        'page'               => Req::query('page', 1),
        'order'              => Req::query('order'),
    );

    //// ジャンル・地域一覧を取得 ////
    $sq = array('companybid_open_id' => $companybidOpenId);
    $xlGenreList    = $companybidMachineTable->getXlGenreList($sq);
    $largeGenreList = $companybidMachineTable->getLargeGenreList($sq);
    
    //// 会場選択 ////
    $siteUrl  = '';
    $siteName = '';
    
    // 会場
    if (!empty($q['location'])) {
        $siteName .= $q['location'];
        $siteUrl  .= '&lo=' . $q['location'];
    } else {
        $siteName .= '全国';
    }
    
    $siteName .= '/';

    // ジャンル
    if (!empty($q['xl_genre_id'])) {
        foreach ($xlGenreList as $x) {
            if ($x['xl_genre_id'] == $q['xl_genre_id']) {
                $siteName .= $x['xl_genre'];
                $siteUrl  .= '&x=' . $q['xl_genre_id'];
                break;
            }
        }
    } else if (!empty($q['large_genre_id'])) {
        foreach ($largeGenreList as $l) {
            if ($l['large_genre_id'] == $q['large_genre_id']) {
                $siteName .= $l['large_genre'];
                $siteUrl  .= '&l=' . $q['large_genre_id'];
                break;
            }
        }
    } else {
        $siteName .= 'すべての商品';
    }
    
    // 会場情報をセッションに格納
    $_SESSION['bid_siteName'] = $siteName;
    $_SESSION['bid_siteUrl']  = $siteUrl;
    
    $companybidMachineList = $companybidMachineTable->getList($q);
    $count                 = $companybidMachineTable->getCount($q);
    
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($count));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);
    
    $cUri = preg_replace("/(\&?page=[0-9]+)/", '', $_SERVER["REQUEST_URI"]);
    if (!preg_match("/\?/", $cUri)) { $cUri.= '?'; }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'             =>  $companybidOpen['title'] . ' 商品リスト : ' . $siteName,
        'pankuzuTitle'          => $siteName,
        'pankuzu'               => array('companybid_index.php?o=' . $companybidOpenId => $companybidOpen['title']),
        'companybidOpenId'      => $companybidOpenId,
        'companybidOpen'        => $companybidOpen,
        'companybidMachineList' => $companybidMachineList,
        'count'                 => $count,
        'pager'                 => $pgn->getPages(),
        'cUri'                  => $cUri,
        
        'siteName'              => $siteName,
        'siteUrl'               => $siteUrl,
        
        'q' => $q,
    ))->display("companybid_list.tpl");
} catch (Exception $e) {
    header("HTTP/1.1 404 Not Found");
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '商品リスト',
        'pankuzu'   => array(
            '/companybid_index.php?o=' . $companybidOpenId => $companybidOpen['title'],
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
