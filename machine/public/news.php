<?php
/**
 * 新着情報ページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    //// 新着情報取得日数取得 ////
    $period = Req::query('pe', 7);

    $base   = Req::query('b');

    if ($base == 1) {
        $baseTitle = "新着中古工具一覧";
        $baseKey   = 'tool';
        $baseXlGenreIds = array(6,7,8,9,10,11);
    } else {
        $baseTitle = "新着中古機械一覧";
        $baseKey   = 'machine';
        $baseXlGenreIds = array(1,2,3,4,5);
    }
    
    //// 新着情報を取得 ////
    $mModel = new Machine();
    $q = array(
        'period'     => $period,
        'start_date' => Req::query('start_date'),
        'end_date'   => Req::query('end_date'),
        'date'       => Req::query('date'),
        'company_id' => Req::query('c'),
        'xl_genre_id'    => $baseXlGenreIds,
        'large_genre_id' => Req::query('l'),
        // 'delete' => 'each',
    
        'limit'  => Req::query('limit', 50),
        'page'   => Req::query('page', 1),

        'sort'   => 'created_at',
    );
    $result = $mModel->search($q);
    $os     = $mModel->getOtherSpecs();
    
    //// ページャ ////
    Zend_Paginator::setDefaultScrollingStyle('Sliding');
    $pgn = Zend_Paginator::factory(intval($result['count']));
    $pgn->setCurrentPageNumber($q['page'])
        ->setItemCountPerPage($q['limit'])
        ->setPageRange(15);
    
    //// ページタイトル ///
    $title = $baseTitle;
    /*
    $pageTitle = array();
    if (!empty($q['date'])) {
        $pageTitle[] = date('Y/m/d' ,strtotime($q['date']));
    }
    
    if (!empty($q['start_date']) && !empty($q['end_date'])) {
        $pageTitle[] = date('Y/m/d' ,strtotime($q['start_date'])) . '～' . date('m/d' ,strtotime($q['end_date']));
    } else if (!empty($q['start_date'])) {
        $pageTitle[] = date('Y/m/d' ,strtotime($q['start_date'])) . '～';
    }
    
    foreach ($result['queryDetail'] as $val) {
        $pageTitle[] = $val['label'];
    }
    
    if (!empty($pageTitle)) {
        $title.= '(' . implode(' ', $pageTitle) . ')';
    }
    
    // 現在既に登録されている機械IDを取得
    $bmModel = new BidMachine();
    $bidMachineIds = $bmModel->getMachineIds();
    */

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => $title,
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        'companyList' => $result['companyList'],
        'addr1List'   => $result['addr1List'],
        'capacityList' => $result['capacityList'],
        'cUri'        => 'news.php?pe=' . $period . '&b=' . $base,
        
        'period'      => $period,
        'start_date'  => $q['start_date'],
        'end_date'    => $q['end_date'],
        
        'tp'         => 'list',
        'largeGenreId' => Req::query('l', array()),
        'genreId'      => Req::query('g', array()),
        'isNc'         => false,
        'noCompanyFlag' => Req::query('c') ? true : false,
        
        'pager'       => $pgn->getPages(),
        'os'          => $os,
        
        'k'           => B::f(Req::query('k')),
        'q'           => $q,
        
        // 'bidMachineIds' => $bidMachineIds,

        'baseKey'     => $baseKey,
    ))->display('news_02.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => '新着中古機械一覧',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
