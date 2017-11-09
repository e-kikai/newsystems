<?php
/**
 * 在庫機械から入札会出品フォーム
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/05/09
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');
    
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    
    if (empty($bidOpenId)) { throw new Exception('入札会情報が取得出来ません'); }
    
    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);
    
    //// 会社情報を取得(絞り込み用) ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'A会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    } else if (Auth::check('system') && in_array($bidOpen['status'], array('entry', 'margin', 'bid')) ) {
        // 管理者の場合は、入札期間でも登録変更を行えるようにする
    } else if ($bidOpen['status'] != 'entry') {
        $e = "この入札会は、「出品期間」ではありません\n";
        $e.= "出品期間 : " . date('Y/m/d H:i', strtotime($bidOpen['entry_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['entry_end_date']));
    } else if (empty($company)) {
        $e = '会社情報が取得出来ませんでした';
    }
    
    if (!empty($e)) { throw new Exception($e); }
    
    //// 商品出品登録チェック ////
    if (empty($company['bid_entries'])) {
        header('Location: /admin/bid_entry_form.php?e=1');
        exit;
    }
    
    //// 機械情報一覧を取得 ////
    $start_date = null;
    $end_date   = null;
    if (Req::query('startYear') && Req::query('startMonth') && Req::query('startDay')) {
        $start_date = Req::query('startYear'). '-' . Req::query('startMonth') . '-' . Req::query('startDay');
    }
    if (Req::query('endYear') && Req::query('endMonth') && Req::query('endDay')) {
        $end_date = Req::query('endYear'). '-' . Req::query('endMonth') . '-' . Req::query('endDay');
    }
    
    $q = array(
        'company_id'  => $_user['company_id'],
        'view_option' => 'full',
        
        'large_genre_id' => Req::query('l'),
        'genre_id'       => Req::query('g'),
        'maker'          => Req::query('m'),
        'keyword'        => Req::query('k'),
        
        'period'         => Req::query('pe'),
        'start_date'     => $start_date,
        'end_date'       => $end_date,
        
        // 'sort'        => 'created_at'
        
        'limit'          => Req::query('limit', 50),
        'page'           => Req::query('page', 1),
    );
    $mModel = new Machine();
    $result = $mModel->search($q);
    
    // 現在既に登録されている機械IDを取得
    $bmModel = new BidMachine();
    $bidMachineIds = $bmModel->getMachineIds(array('status' => 'entry'));
    
    foreach ($result['machineList'] as $key => $m) {
        /*
        foreach ($bidMachineIds as $bo) {
            if (in_array($m['id'], $bo['machine_ids'])) {
                $result['machineList'][$key]['bid_title'] = $bo['title'];
            }
        }
        */
        
        if (!empty($bidMachineIds[$m['id']])) {
            $result['machineList'][$key] += $bidMachineIds[$m['id']];
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
        'pageTitle'        => '在庫機械から出品',
        'pageDescription'  => '在庫機械から出品したい機械に最低入札金額を設定して出品できます',
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
            '/admin/bid_machine_list.php?o=' . $bidOpenId => $bidOpen['title'] . ':出品商品一覧'
        ),
        'bidOpenId'   => $bidOpenId,
        'bidOpen'     => $bidOpen,
        'genreList'   => $result['genreList'],
        'makerList'   => $result['makerList'],
        'machineList' => $result['machineList'],
        'bidMachineIds' => $bidMachineIds,
        'pager'       => $pgn->getPages(),
        'cUri'        => $cUri,
        
        'q'           => $q,
        
        'company'     => $company,
    ))->display("admin/bid_machine2machine.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '在庫機械から出品',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
            '/admin/bid_machine_list.php?o=' . $bidOpenId => '出品商品一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
