<?php
/**
 * AJAXでデータの取得
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.1
 * @since   2012/08/10
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';

//// 認証 ////
Auth::isAuth('machine');

//// 在庫情報を検索 ////
$q = array(
    'xl_genre_id'    => Req::query('x'),
    'large_genre_id' => Req::query('l'),
    'genre_id'       => Req::query('g'),
    'company_id'     => Req::query('c'),
    'keyword'        => Req::query('k'),
    'maker'          => Req::query('ma'),

    'period'         => Req::query('pe'),
    'start_date'     => Req::query('start_date'),
    'end_date'       => Req::query('end_date'),

    'date'           => Req::query('date'),

    'is_youtube'     => Req::query('youtube'),

    // 'limit'          => Req::query('limit', 50),
    // 'page'           => Req::query('page', 1),

    'onlyList'       => true,
);

// マイリスト対策
if (Req::query('mylist')) {
    //// 在庫情報を検索 ////
    $myModel = new Mylist();
    $idList = $myModel->getArray($_user['id'], 'machine');

    $q['id'] = $idList;
}

$mModel = new Machine();
$result = $mModel->search($q);
$os     = $mModel->getOtherSpecs();

// 現在既に登録されている機械IDを取得
$bmModel       = new BidMachine();
$bidMachineIds = $bmModel->getMachineIds();

//// 表示変数アサイン ////
/*
$assign = array(
    // 'pageTitle'   => implode(' /', $pageTitle) . ' :: 検索結果',
    // 'pankuzu'     => $pankuzu,
    // 'cUri'        => 'search.php?' . implode('&', $cUri),
    'genreList'   => $result['genreList'],
    'makerList'   => $result['makerList'],
    'machineList' => $result['machineList'],
    'companyList' => $result['companyList'],
    'addr1List'   => $result['addr1List'],
    'queryDetail' => $result['queryDetail'],
    'largeGenreList' => $largeGenreList,
    'largeGenreId' => Req::query('l'),
    'noCompanyFlag' => Req::query('c') ? true : false,
    'tp'            => 'list',
);

$display = $_smarty->assign($assign)->fetch('include/order.tpl');
$display.= $_smarty->assign($assign)->fetch('include/machine_header.tpl');
*/
// データ整形
$mTemp = array();
foreach($result['machineList'] as $key => $m) {
    // その他能力を仕様に連結
    $spec = (String)$m['spec'];
    $others = array();
    if (!empty($m['spec_labels'])) {
        $oSpec  = $mModel->makerOthers($m['spec_labels'], $m['others']);
        if (!empty($oSpec) && !empty($spec)) {
            $spec = $oSpec . ' | ' . $spec;
        } else {
            $spec.= $oSpec;
        }
    }

    // その他の項目値の処理
    // $model2 = preg_replace('/[^A-Z0-9]/', '', strtoupper(mb_convert_kana($m['model'], 'KVrn')));
    // if (!Auth::check('member')) { unset($m['catalog_id'], $m['price']); }

    // 名前整形
    $name = $m['name'];
    if (!empty($m['capacity_label']) && !empty($m['capacity']) && !preg_match('/^[0-9]/', $m['name'])) {
         $name = $m['capacity'] . $m['capacity_unit'] . $name;
    }

    $temp = array(
        'id'             => $m['id'],
        // 'name'           => $m['name'],
        'name'           => $name,
        'maker'          => $m['maker'],
        'model'          => $m['model'],
        // 'model2'         => $model2,
        'model2'         => !empty($m['model2']) ? $m['model2'] : '',
        'year'           => !empty($m['year']) ? $m['year'] : '',
        'spec'           => mb_strimwidth($spec, 0, 120, '…'),

        'company_id'     => $m['company_id'],
        'company'        => preg_replace('/(株式|有限|合.)会社/u', '', $m['company']),
        // 'contact_tel'    => $m['contact_tel'],
        // 'contact_fax'    => $m['contact_fax'],
        'contact_mail'   => !empty($m['contact_mail']) ? 1 : '',

        'capacity'       => $m['capacity'],
        'capacity_unit'  => $m['capacity_unit'],
        'capacity_label' => $m['capacity_label'],

        'top_img'        =>  $m['top_img'],
        // 'imgs'           =>  $m['imgs'],
        'pdfs'           =>  $m['pdfs'],
        'youtube'        => $m['youtube'],

        'commission'     => $m['commission'],
        'view_option'    => $m['view_option'],

        'genre_id'       =>  $m['genre_id'],
        'location'       =>  $m['location'],
        'addr1'          =>  $m['addr1'],
        // 'addr2'          =>  $m['addr2'],
        // 'addr3'          =>  $m['addr3'],
        'region'         =>  $m['region'],

        // 'lat'            =>  $m['lat'],
        // 'lng'            =>  $m['lng'],

        'created_at'     =>  strtotime($m['created_at']),
        // 'deleted_at'     =>  strtotime($m['deleted_at']),

        'catalog_id' => $m['catalog_id'],
    );

    // Web入札会商品
    if (!empty($bidMachineIds[$m['id']])) {
        $temp += $bidMachineIds[$m['id']];
        $temp['min_price_label'] = number_format($temp['min_price']);
    }

    // $temp['bid_open_id'] = !empty($bidMachineIdList[$temp['id']]) ? $bidMachineIdList[$temp['id']] : '';

    // if (Auth::check('member')) {
    //    $temp['catalog_id'] = $m['catalog_id'];
    // }
    $mTemp[] = $temp;
}

$res = array(
  'machineList' => $mTemp,
  // 'display'     => $display,
);

echo json_encode($res);
