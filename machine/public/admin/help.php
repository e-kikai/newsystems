<?php
/**
 * ヘルプページ共通
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    $user = Auth::isAuth('member');
    
    $page = Req::query('p');
    
    if ($page = 'linkbunner') {
        $template        = 'admin/help_linkbunner.tpl';
        $pageTitle       = 'リンクバナーについて';
        $pageDescription = 'マシンライフ中古機械情報へのリンクを行う場合は、以下のリンクバナーをダウンロードしてお使いください';    
    } else if (file_exsist($_smarty->template_dir . '/admin/help_' . $page. '.tpl')) {
        $template = 'admin/help_' . $page. '.tpl';
        $pageTitle       = 'ヘルプページ';
        $pageDescription = 'マシンライフ会員ページのヘルプページです'; 
    } else {
        throw new Exception('指定されたページはありませんでした');
    }
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => $pageTitle,
        'pageDescription' => $pageDescription,
        'pankuzu'   => array('admin/' => '会員ページ'),
    ))->display($template);
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'ヘルプページ',
        'pankuzu'   => array('admin/' => '会員ページ'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

