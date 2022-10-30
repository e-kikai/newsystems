<?php
/**
 * 在庫一覧ページ
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

    $q = array(
      'xl_genre_id'    => Req::query('x'),
      'large_genre_id' => Req::query('l'),
      'genre_id'       => Req::query('g'),
      // 'company_id'     => Req::query('c'),
      'company_id'     => 320,
      'keyword'        => Req::query('k'),
      'maker'          => Req::query('ma'),

      'period'         => Req::query('pe'),
      'start_date'     => Req::query('start_date'),
      'end_date'       => Req::query('end_date'),
      'is_youtube'     => Req::query('youtube'),

      'limit'          => Req::query('limit', 99999999),
      'page'           => Req::query('page', 1),

      'sort'           => 'no_int',
    );

    $fq = array(
      'company_id'     => 320,
      'limit'          => Req::query('limit', 99999999),
      'page'           => Req::query('page', 1),

      'sort'           => 'no_int',
    );

    //// 会社情報を取得 ////
    $companyTable = new Companies();
    $company      = $companyTable->get($companyId);

    /// 商品情報 ///
    $mModel = new Machine();

    // 検索条件
    $filters = $mModel->search($fq);

    // 検索結果
    $machineList = $mModel->getList($q);

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => '在庫機械一覧',
        'company'     => $company,
        // 'companysite' => $companysite,
        'genreList'    => $filters['genreList'],
        'makerList'    => $filters['makerList'],
        'machineList'  => $machineList,
        // 'companyList'  => $result['companyList'],
        // 'addr1List'    => $result['addr1List'],
        // 'capacityList' => $result['capacityList'],
        // 'queryDetail'  => $result['queryDetail'],
    ))->display('daihou/machines.tpl');
    } catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
      'pageTitle'   => '在庫機械一覧',
      'company'     => $company,
      'errorMes'  => $e->getMessage()
    ))->display('daihou/error.tpl');
}
