<?php
/**
 * 在庫機械情報フォーム
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');
    
    $id = Req::query('id');
    
    //// 機械情報を取得 ////
    $iModel = new Info();
    if ($id) {
        $info = $iModel->get($id);
    } else {
        // 新規作成デフォルトを設定
        $info = array(
            'target' => 'member',
            'group_id' => NULL,
            'info_date' => date('Y/m/d'),
        );
    }
    
    $targetList = array(
        'member'  => '会員ページ',
        'machine' => '中古機械情報',
        'catalog' => '電子カタログ',
    );
    
    // 団体一覧
    $gModel = new Group();
    $groupList = $gModel->getList();
    
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => $id ? 'お知らせ変更' : 'お知らせ新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/info_list.php' => '事務局からのお知らせ一覧'
        ),
        'id'        => $id,
        'info'      => $info,
        'groupList' => $groupList,
        
        'targetList' => $targetList,
        'groupList' => $groupList,
    ))->display("system/info_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $id ? 'お知らせ変更' : 'お知らせ新規登録',
        'pankuzu'   => array(
            '/system/' => '管理者ページ',
            '/system/info_list.php' => 'お知らせ一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
