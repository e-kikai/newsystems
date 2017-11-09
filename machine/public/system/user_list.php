<?php
/**
 * ユーザ一覧表示ページ
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2012/10/29
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    //// 変数を取得 ////
    $output = Req::query('output');

    $q = array(
        'target' => Req::query('t'),
        'action' => Req::query('a'),
        'page'   => Req::query('p'),
        'limit'  => Req::query('limit'),
    );
    
    $uModel   = new User();
    $userList = $uModel->getList($q);

    //// CSVに出力する場合 ////
    if ($output == 'csv') {
        // データ整形
        foreach ($userList as $key => $c) {
            $userList[$key]['created_date'] =
                !empty($c['created_at']) ? date('Y/m/d', strtotime($c['created_at'])) : '';
            $userList[$key]['changed_date'] =
                !empty($c['changed_at']) ? date('Y/m/d', strtotime($c['changed_at'])) : '';

        }

        $header = array(
            'id'           => 'ユーザID',
            'user_name'    => 'ユーザ名',
            'company_id'   => '会社ID',
            'role'         => '権限',
            'account'      => 'アカウント',
            'passwd'       => 'パスワード',
            'created_date' => '登録日',
            'changed_date' => '変更日',            
        );

        B::downloadCsvFile($header, $userList, 'user_list.csv');
        exit;
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'ユーザ一覧',
        'pankuzu' => array('/system/' => '管理者ページ'),
        'userList'   => $userList,
    ))->display("system/user_list.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'システムエラー',
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

