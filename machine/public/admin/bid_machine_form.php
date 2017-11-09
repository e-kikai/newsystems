<?php
/**
 * 入札会出品フォーム
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
    $machineId = Req::query('m');
    $bidOpenId = Req::query('o');
    
    $baseMachineId = Req::query('machine_id');
    
    if (empty($bidOpenId) && empty($machineId)) {
        throw new Exception('入札会情報、商品情報が取得出来ません');
    }
    
    //// 商品情報を取得 ////
    $boModel = new BidOpen();
    $bmModel = new BidMachine();
    
    if (!empty($machineId)) {
        $machine = $bmModel->get($machineId);
        
        // 入札会IDの取得
        $bidOpenId = $machine['bid_open_id'];
    } else if (empty($machineId) && !empty($baseMachineId)) {
        // 在庫情報からの出品    
        $mModel = new Machine();
        
        // 会社情報のチェック
        if (!$mModel->checkUser($baseMachineId, $_user['company_id'])) {
            throw new Exception("この在庫機械はあなたの在庫ではありません id:{$baseMachineId}");
        }
        
        $machine = $mModel->get($baseMachineId);
        $machine['machine_id'] = $baseMachineId;
    } else {
        // 在庫場所の初期化のため、会社情報を取得
        $cModel = new Company();
        $company = $cModel->get($_user['company_id']);
    
        // 新規作成デフォルトを設定
        $machine = array(
            'large_genre_id' => 1,
            'genre_id'       => 1,
            'year'           => '',
            'others'         => array(),
            'commission'     => null,
            'imgs'           => null,
            'pdfs'           => null,
            'location' => '本社',
            'addr1'    => $company['addr1'],
            'addr2'    => $company['addr2'],
            'addr3'    => $company['addr3'],
            'lat'      => $company['lat'],
            'lng'      => $company['lng'],
        );
    }
    
    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('このページの表示権限がありません');
    }
    
    // 出品期間のチェック
    $e = '';
    $bidOpen = $boModel->get($bidOpenId);
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
    
    // 選択用ジャンル一覧
    // $gModel = new Genre();
    // $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);
    $largeGenreTable = new LargeGenres();
    $largeGenreList  = $largeGenreTable->getMachineList();

    // 選択用年号一覧
    $mModel = new Machine();
    $yearList = $mModel->makeYearList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'        => !empty($machineId) ? '入札会出品商品の変更' : '入札会出品商品 新規登録',
        'pageDescription'  => '入札会出品商品の' . (!empty($machineId) ? '変更' : '新規登録') . 'を行うフォームです。',
        'pankuzu'          => array(
            '/admin/' => '会員ページ',
            '/admin/bid_machine_list.php?o=' . $bidOpenId => $bidOpen['title'] . ':入札会出品商品一覧'
        ),
        'machineId'      => $machineId,
        'bidOpenId'      => $bidOpenId,
        'machine'        => $machine,
        'bidOpen'        => $bidOpen,
        'largeGenreList' => $largeGenreList,
        'yearList'       => $yearList,
    ))->display("admin/bid_machine_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $machineId ? '在庫機械の変更' : '在庫機械 新規登録',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
