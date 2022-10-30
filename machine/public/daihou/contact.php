<?php
/**
 * お問い合わせページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2021/11/29
 */
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('machine');

    //// 変数を取得 ////
    // $companyId = Req::query('c');
    $companyId = 320;

    //// 会社情報を取得 ////
    $companyTable = new Companies();
    $company      = $companyTable->get($companyId);

    //// 機械情報一覧を取得 ////
    if (Req::query('m')) {
        $mModel = new Machine();
        $machineList = $mModel->getList(array('id'  => (array)Req::query('m')));

        $pageTitle = '在庫機械への' . (count($machineList) > 1 ? '一括' : '') . '問い合わせ';
    } else {
        $machineList = array();
    }

    //// select選択肢都道府県一覧 ////
    $sModel    = new State();
    $addr1List = $sModel->getList();

    //// select選択肢項目 ////
    $select = array(
        1 => 'この機械の状態を知りたい',
        2 => 'この機械の価格を知りたい',
        3 => '送料を知りたい (↓に送付先住所を記入してください)',
        4 => '現物を見たい',
        5 => '試運転は可能ですか'
    );

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'お問い合わせ',
        'company'     => $company,
        'hideFooterbanner' => True,

        'machineList' => $machineList,
        'addr1List'   => $addr1List,
        'select'      => $select,
        // 'companysite' => $companysite,
    ))->display('daihou/contact.tpl');
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
      'pageTitle'   => 'お問い合わせ',
      'hideFooterbanner' => True,
      'company'     => $company,

      'addr1List'   => $addr1List,
      'select'      => $select,
      'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
