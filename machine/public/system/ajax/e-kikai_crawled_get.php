<?php
/**
 * 新e-kikai被クロールページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.2
 * @since   2015/05/08
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('system');

    // タイムアウトを長く設定
    set_time_limit(3000);

    //// パラメータ取得 ////
    $table     = Req::query('t');
    $companyId = Req::query('c');

    $res = null;
    if ($table == 'large_genres') {
        $xlGenreTable = new XlGenres();
        $res          = $xlGenreTable->getMachineList();
    } else if ($table == 'middle_genres') {
        $largeGenreTable = new LargeGenres();
        $res             = $largeGenreTable->getMachineList();
    } else if ($table == 'genres') {
        $genreTable = new Genres();
        $res        = $genreTable->getMachineList();
    } else if ($table == 'companies') {
        $companyTable = new Companies();
        $res          = $companyTable->get($companyId);
    } else if ($table == 'machines') {
        $machineTable = new Machine();
        $machines     = $machineTable->getList(array('company_id' => $companyId, 'is_ospec' => true));

        $res = array();
        foreach ($machines as $key => $ma) {
          $temp = array(
            'id'         => $ma['id'],
            'no'         => $ma['no'],
            'name'       => $ma['name'],
            'maker'      => $ma['maker'],
            'maker_master'      => $ma['maker_master'],
            'maker_master_kana' => $ma['maker_master_kana'],
            'model'      => $ma['model'],
            'year'       => $ma['year'],
            'capacity'   => $ma['capacity'],
            'location'   => $ma['location'],
            'addr1'      => $ma['addr1'],
            'addr2'      => $ma['addr2'],
            'addr3'      => $ma['addr3'],
            'spec'       => $ma['spec'],
            'accessory'  => $ma['accessory'],
            'comment'    => $ma['comment'],
            'commission' => $ma['commission'],
            'top_img'    => $ma['top_img'],
            'imgs'       => $ma['imgs'],
            'capacity'   => $ma['capacity'],
            'capacity_uxit' => $ma['capacity_unit'],
            'genre_id'   => $ma['genre_id'],
          );

          $res[] = $temp;
        }
    } else if ($table == 'auction_machines') {
        $machineTable = new Machine();
        // $machines     = $machineTable->getList(array('company_id' => $companyId, 'start_date' => Req::query('start_date'), 'end_date' => Req::query('end_date'), 'is_ospec' => true, 'sort' => "created_at"));
        $machines     = $machineTable->getList(array('company_id' => $companyId, 'large_genre_id' => Req::query('large_genre_id'), 'start_date' => Req::query('start_date'), 'end_date' => Req::query('end_date'), 'is_ospec' => true, 'sort' => "created_at"));

        $res = array();
        foreach ($machines as $key => $ma) {
          $temp = array(
            'id'         => $ma['id'],
            'no'         => $ma['no'],
            'created_at' => $ma['created_at'],
            'top_img'    => $ma['top_img'],
          );

          $temp['name'] = trim($ma['name'] . " " . $ma['maker'] . " " . $ma['model']);
          if (!empty($ma['year'])) { $temp['name'] .= " " . $ma['year'] . "年式"; }

          // $temp['spec']   = trim($ma['spec'] . "\n\n" . $ma['accessory'] . "\n\n" . $ma['comment']);
          // $temp['images'] = $ma['top_img'] . " " . implode(' ', $ma['imgs']);

          $res[] = $temp;
        }
    } else if ($table == 'auction_machine') {
        $machineTable = new Machine();
        $machine      = $machineTable->get(Req::query('id'));

        $res = array(
          'id'         => $machine['id'],
          'no'         => $machine['no'],
          // 'created_at' => $machine['created_at'],
          'top_img'    => $machine['top_img'],
          'youtube'    => $machine['youtube'],
        );

        $res['name']  = trim($machine['name'] . " " . $machine['maker'] . " " . $machine['model']);
        if (!empty($machine['year'])) { $res['name'] .= " " . $machine['year'] . "年式"; }

        $res['spec']   = trim($machine['spec'] . "\n\n" . $machine['accessory'] . "\n\n" . $machine['comment']);
        $res['images'] = $machine['top_img'] . " " . implode(' ', $machine['imgs']);
    } else if ($table == 'auction_genres') {
        $machineTable = new Machine();
        $largeGenres  = $machineTable->getLargeGenreList(array('company_id' => $companyId,));

        $res = array();
        foreach ($largeGenres as $key => $ge) {
          $res[] = array(
            'id'          => $ge['id'],
            'count'       => $ge['count'],
            'large_genre' => $ge['large_genre'],
          );
        }
    }

    // 結果をJSONに変換して出力
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}
