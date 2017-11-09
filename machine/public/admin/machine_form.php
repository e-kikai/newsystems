<?php
/**
 * 在庫機械情報フォーム
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('member');

    $id = Req::query('m');

    $baseBidMachineId = Req::query('bid_machine_id');

    //// 会社情報を取得 ////
    $cModel = new Company();
    $company = $cModel->get($_user['company_id']);
    if (empty($company)) { throw new Exception('会社情報が取得できませんでした'); }

    if (!Companies::checkRank($company['rank'], 'A会員')) {
        throw new Exception('このページの表示権限がありません');
    }

    //// 機械情報を取得 ////
    $mModel = new Machine();
    if ($id) {
        // 会社情報のチェック
        if (!$mModel->checkUser($id, $_user['company_id'])) {
            throw new Exception("この在庫機械はあなたの在庫ではありません id:{$id}");
        }

        $machine = $mModel->get($id);
    } else if (empty($id) && !empty($baseBidMachineId)) {
        // 入札会商品からの出品
        $bmModel = new BidMachine();
        $machine = $bmModel->get($baseBidMachineId);

        // 会社情報のチェック
        if ($machine['company_id'] != $_user['company_id']) {
            throw new Exception("この入札会商品はあなたの商品ではありません id:{$baseBidMachineId}");
        }

        // 不足情報の補完
        $machine['bid_machine_id'] = $machine['id'];
        $machine['price_tax']   = null;
        $machine['view_option'] = null;
    } else {
        // 新規作成デフォルトを設定
        $machine = array(
            'large_genre_id' => 1,
            'genre_id'       => 1,
            'year'           => '',
            'others'         => array(
            ),
            'commission'     => null,
            'imgs'           => null,
            'pdfs'           => null,
            'view_option'    => null,
            'price_tax'      => null,

            'location'       => '本社',
            'addr1'          => $company['addr1'],
            'addr2'          => $company['addr2'],
            'addr3'          => $company['addr3'],
            'lat'            => $company['lat'],
            'lng'            => $company['lng'],
        );
    }
    
    // 選択用ジャンル一覧
    // $gModel = new Genre();
    // $largeGenreList = $gModel->getLargeList(Genre::HIDE_CATALOG);
    // $genreList = $gModel->getList();
    $largeGenreTable = new LargeGenres();
    $largeGenreList  = $largeGenreTable->getMachineList();

    // 選択用年号一覧
    $yearList = $mModel->makeYearList();

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'        => $id ? '在庫機械の変更' : '在庫機械 新規登録',
        'pageDescription'  => '在庫機械情報の' . ($id ? '変更' : '新規登録') . 'を行うフォームです。',
        'pankuzu'          => array(
            '/admin/'                 => '会員ページ',
            '/admin/machine_list.php' => '在庫機械一覧'
        ),
        'id'               => $id,
        'machine'          => $machine,
        'largeGenreList'   => $largeGenreList,
        // 'genreList'       => $genreList,
        'yearList'         => $yearList,
    ))->display("admin/machine_form.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => $id ? '在庫機械の変更' : '在庫機械 新規登録',
        'pankuzu'   => array(
            '/admin/'                 => '会員ページ',
            '/admin/machine_list.php' => '在庫機械一覧'
        ),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
