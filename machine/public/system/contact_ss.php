<?php
/**
 * お問い合わせログ集計表ページ表示
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2013/01/21
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    $company_id = Req::query('c');
    $month      = Req::query('m');
    
    $cModel = new Contact();
    $contactSS = $cModel->getSS($company_id, $month);
    
    if (empty($month)) {
        $t = '月単位';
    } else if ($month == 'now') {
        $t = '今月';
    } else {
        $t = date('Y/m', strtotime($month));
    }
    
    $pankuzu = array('/system/' => '管理者ページ');
    if ($month) { $pankuzu['/system/contact_ss.php'] = 'お問い合わせログ集計(月単位)'; }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせログ集計(' . $t . ')',
        'pankuzu'   => $pankuzu,
        'contactSS' => $contactSS,
        'month'     => $month,
    ))->display("system/contact_ss.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合わせログ集計',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

