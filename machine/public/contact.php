<?php
/**
 * お問い合わせページ
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

    //// 会社情報を取得 ////
    $bidFlag      = Req::query('b');
    $bidMachineId = Req::query('bm');
    $bidOpenId    = Req::query('o');
    $batch        = Req::query('batch');

    $machineList = array();
    $companyList = array();
    $pageTitle   = '全機連への問い合わせ';

    $bidMachine     = array();
    $bidMachineList = array();
    $bidOpen        = array();

    //// 機械情報一覧を取得 ////
    if (Req::query('m')) {
        $mModel = new Machine();
        $machineList = $mModel->getList(array('id'  => (array)Req::query('m')));

        $pageTitle = '在庫機械への' . (count($machineList) > 1 ? '一括' : '') . '問い合わせ';
    }

    //// 会社一覧を取得 ////
    if (Req::query('c')) {
        $companyTable = new Companies();
        $companyList  = $companyTable->getList(array('id'  => (array)Req::query('c')));

        $pageTitle = '会社への' . (count($companyList) > 1 ? '一括' : '') . '問い合わせ';
    }

    //// Web入札会情報を取得 ////
    if (!empty($bidMachineId)) {
        $bmModel    = new BidMachine();
        $bidMachine = $bmModel->get($bidMachineId);

        //// 入札会情報を取得 ////
        $boModel = new BidOpen();
        $bidOpen = $boModel->get($bidMachine['bid_open_id']);

        // 商品についての質問の場合、(会社IDがない場合)
        if (empty($companyList)) {
            // 会社情報を取得
            $companyTable = new Companies();
            $companyList  = $companyTable->getList(array('id'  => $bidMachine['company_id']));
        }

        $pageTitle = $bidOpen['title'] . 'の問い合わせ';
    }

    //// Web入札会一括問い合わせ ////
    if (!empty($batch)) {
        $_bidBatch =& $_SESSION['bid_batch'];
        if (empty($_bidBatch)) { throw new Exception("問い合わせ商品がありません"); }

        foreach((array)$_bidBatch as $key => $v) {
            if (is_int($key)) { $bidMachineIds[] = $key; }
        }

        $bmModel = new BidMachine();
        $bidMachineList = $bmModel->getList(array('bid_open_id' => $batch, 'id' => $bidMachineIds));

        //// 入札会情報を取得 ////
        $boModel = new BidOpen();
        $bidOpen = $boModel->get($batch);

        $pageTitle = $bidOpen['title'] . 'の一括問い合わせ';
    }

    //// select選択肢項目 ////
    $select = array(
        1 => 'この機械の状態を知りたい',
        2 => 'この機械の価格を知りたい',
        3 => '送料を知りたい (↓に送付先住所を記入してください)',
        4 => '現物を見たい',
        5 => '試運転は可能ですか'
    );

    //// select選択肢都道府県一覧 ////
    $sModel    = new State();
    $addr1List = $sModel->getList();

    //// リファラ処理 ////
    // デフォルト
    $backUri   = '/';
    $backTitle = 'トップページ';

    $pankuzu   = array();

    if (count($machineList) == 1) {
        $m = $machineList[0];
        $pankuzu = array(
          'search.php?l[]=' . $m['large_genre_id'] => $m['large_genre'],
          'machine_detail.php?m=' . $m['id'] => "{$m['name']} {$m['maker']} {$m['model']}",
        );
    } else if (!empty($bidMachineId)) {
        if (!empty($bidOpenId)) {
            $pankuzu['/bid_door.php?o=' . $bidOpenId] = $bidOpen['title'];

            // セッションから会場情報を取得
            $siteName = !empty($_SESSION['bid_siteName']) ? $_SESSION['bid_siteName'] : '商品リスト';
            $siteUrl  = !empty($_SESSION['bid_siteUrl']) ? $_SESSION['bid_siteUrl'] : '';
            $pankuzu['/bid_list.php?o=' . $bidOpenId . $siteUrl] = $siteName;
        }
        $pankuzu['/bid_detail.php?m=' . $bidMachineId] = '商品詳細';
        $pankuzu['/bid_company_list.php?o=' . $bidOpenId . '&m=' . $bidMachineId] = '全機連会員一覧';
    } else if (count($companyList) == 1) {
        $c = $companyList[0];
        $pankuzu = array(
          'company_list.php' => '会社一覧',
          'company_detail.php?c=' . $c['id'] => $c['company'],
        );
    } else if (!empty($_SERVER['HTTP_REFERER'])) {
        $ref = urldecode($_SERVER['HTTP_REFERER']);

        if (strstr($ref, 'search.php')) {
            $backUri   = $ref;
            $backTitle = '検索結果';
            $pankuzu   = array($ref => '検索結果');
        } elseif (strstr($ref, 'news.php')) {
            $backUri   = $ref;
            $backTitle = '新着情報';
            $pankuzu   = array($ref => '新着情報');
        } elseif (strstr($ref, 'mylist.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(機械情報)';
            $pankuzu   = array($ref => 'マイリスト(機械情報)');
        } elseif (strstr($ref, 'company_list.php')) {
            $backUri   = $ref;
            $backTitle = '会社一覧';
            $pankuzu   = array($ref => '会社一覧');
        } else if (strstr($ref, 'mylist_company.php')) {
            $backUri   = $ref;
            $backTitle = 'マイリスト(会社)';
            $pankuzu   = array($ref => 'マイリスト(会社)');
        }
    }

    //// @ba-ta 20150107 フォームテスト用 ////
    // $template = Req::query('test') ? 'contact_02.tpl' : 'contact.tpl';
    $template = 'contact.tpl';

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'    => $pageTitle,
        'pankuzu'      => $pankuzu,

        'machineList'  => $machineList,
        'companyList'  => $companyList,

        'addr1List'    => $addr1List,

        'backUri'      => $backUri,
        'select'       => $select,
        'bidFlag'      => $bidFlag,

        'bidMachineId' => $bidMachineId,
        'bidOpenId'    => $bidOpenId,
        'bidMachine'   => $bidMachine,
        'bidOpen'      => $bidOpen,

        'batch'        => $batch,
        'bidMachineList' => $bidMachineList,
    ))->display($template);
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせ',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
