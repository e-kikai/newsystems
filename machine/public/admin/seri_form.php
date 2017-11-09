<?php
/**
 * 企業間売り切り出品フォーム
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2017/2/20
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');

    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $output    = Req::query('output');
    $result    = Req::query('result');

    if (empty($bidOpenId)) { throw new Exception('入札会情報が取得出来ません'); }

    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);

    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'B会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    // 出品期間のチェック
    $e = '';
    if (empty($bidOpen)) {
        $e = '入札会情報が取得出来ませんでした';
    // } else if (!in_array($bidOpen['status'], array('entry', 'margin', 'bid', 'carryout', 'after'))) {
    //     $e = $bidOpen['title'] . " は、現在「出品期間」ではありません\n";
    //     $e.= "出品期間 : " . date('Y/m/d H:i', strtotime($bidOpen['entry_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['entry_end_date']));
    } else if (empty($company)) {
        $e = '会社情報が取得出来ませんでした';
    }
    if (!empty($e)) { throw new Exception($e); }

    //// 商品出品登録チェック ////
    if (empty($company['bid_entries'])) {
        header('Location: /admin/bid_entry_form.php?e=1');
        exit;
    }

    //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    if (strtotime($bidOpen["entry_start_date"]) <= time() && strtotime($bidOpen["seri_start_date"]) > time()) {
        $q = array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id']);
    } else {
        $q = array('bid_open_id' => $bidOpenId, 'company_id' => $_user['company_id'], 'is_seri' => true);
    }

    $bidMachineList = $bmModel->getList($q);

    //// 企業間売り切り入札取得 ////
    if (strtotime($bidOpen["seri_start_date"]) <= time()) {
        $resultListAsKey = $bmModel->getSeriResultListAsKey($bidOpenId);

        $seriSum = 0;
        foreach($bidMachineList as $key => $m) {
            $m["seri_result"] = false;
            if (!empty($resultListAsKey[$m['id']]['amount'])) {
                $r = $resultListAsKey[$m['id']];

                // 落札結果の格納
                $m['seri_count']      = $r['count'];
                $m['seri_company']    = $r['company'];
                $m['seri_company_id'] = $r['company_id'];
                $m['seri_amount']     = $r['amount'];

                if (($m['seri_price'] <=  $m['seri_amount']) || !empty($m['prompt'])) {
                    $m["seri_result"] = true;
                    $seriSum += $m['seri_amount'];
                }
            }
            $bidMachineList[$key] = $m;
        }

        $_smarty->assign(array(
            'seriSum'      => $seriSum,
        ));
    }

    //// 落札済・未落札のフィルタリング ////
    if ($result != null) {
        $res = array();
        foreach($bidMachineList as $key => $m) {
            if ($result == "notbidoff" && $m["seri_result"] == false) { $res[] = $m; }
            if ($result == "bidoff"    && $m["seri_result"] == true)  { $res[] = $m; }
        }
        $bidMachineList = $res;
    }

    //// 期間によって表示切り替え ////
    if (strtotime($bidOpen["entry_start_date"]) <= time() && strtotime($bidOpen["seri_start_date"]) > time()) {
        $_smarty->assign(array(
            'pageTitle'       => $bidOpen['title'] . ' : 企業間売り切りシステム 出品一覧',
            // 'pageDescription' => '出品する場合は売り切り価格を入力して「反映」をクリックしてください。出品を取り消したい場合は金額を削除して「反映」をクリックしてください',
        ));
    } else if (strtotime($bidOpen["seri_start_date"]) <= time() && strtotime($bidOpen["seri_end_date"]) > time()) {
        $_smarty->assign(array(
            'pageTitle'       => $bidOpen['title'] . ' : 企業間売り切りシステム 管理',
            // 'pageDescription' => "企業間売り切りの状況を表示できます。「即決」をクリックすることで、金額に達していなくても、現在の金額・入札会社で即落札にすることができます。",
        ));
    } else {
       $_smarty->assign(array(
          'pageTitle'       => $bidOpen['title'] . ' : 企業間売り切りシステム 出品個別計算表',
          // 'pageDescription' => "企業間売り切りの結果を表示します。",
      ));
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pankuzu'        => array(
            '/admin/' => '会員ページ',
        ),
        'bidOpenId'      => $bidOpenId,
        'bidOpen'        => $bidOpen,
        'bidMachineList' => $bidMachineList,
        'rank'           => $company['rank'],

        'result'         => $result,
    ))->display("admin/seri_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '企業間売り切りシステム 登録・管理',
        'pankuzu'   => array(
            '/admin/' => '会員ページ',
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
