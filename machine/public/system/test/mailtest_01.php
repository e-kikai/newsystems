<?php
/**
 * 新着メール test
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    //// パラメータ取得 ////
    $mModel = new Machine();
    
    $result = $mModel->search(array('period' => 1));
    $date = date("Y/m/d", strtotime("-1 day"));
    
    if (!empty($result['machineList'])) {
        //// 表示変数アサイン ////
        $body = $_smarty->assign(array(
            'machineList' => $result['machineList'],
        ))->fetch('system/test/mailtest_01.tpl');
        
        $maModel = new Mailsend();
        $maModel->sendMail('bata44883@gmail.com', null, $body, 'マシンライフ新着中古機械情報(' . $date . ')', null, 'html');
        $maModel->sendMail('kazuyoshih@gmail.com', null, $body, 'マシンライフ新着中古機械情報(' . $date . ')', null, 'html');
        $maModel->sendMail('qqgx76kd@galaxy.ocn.ne.jp', null, $body, 'マシンライフ新着中古機械情報(' . $date . ')', null, 'html');
    }
} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
