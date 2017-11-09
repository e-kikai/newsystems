<?php
/**
 * お問い合せ完了ページ
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/11/10
 */
require_once '../lib-machine.php';
try {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'       => 'お問い合せ完了',
        'pageDescription' => 'お問い合せは送信されました'
    ))->display("contact_fin.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => 'お問い合せ完了',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
