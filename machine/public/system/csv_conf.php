<?php
/**
 * CSV一括登録確認画面
 *
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2012/04/13
 */
require_once '../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('system');

    //// 会社情報を取得 ////
    $cModel      = new Company();
    $companyList = $cModel->getList();

    // データをクリア
    unset($_SESSION['system_csv_data'], $_SESSION['system_csv_company_id']);
    $nowCount    = 0;
    $createCount = 0;
    $updateCount = 0;

    /// CSVファイルを処理する ///
    if (empty($_FILES['csv'])) {
        throw new Exception('ファイルがアップロードされていません');
    } else if (!is_uploaded_file($_FILES['csv']['tmp_name'])) {
        throw new Exception('ファイルがありません');
    } else if (($f = file2utf($_FILES['csv']['tmp_name'])) === FALSE) {
        throw new Exception('ファイルが開けませんでした');
    }

    //// 在庫場所の初期化のため、会社情報を取得 ////
    // $companyId = 2; // 楠本機械様(from 百貨店)テスト
    $companyId     = Req::post('company');
    $usedCompanyId = null;
    $company       = $cModel->get($companyId);

    //// 会社情報から、機械情報を取得 ////
    $mModel = new Machine();
    $mlTemp = $mModel->getList(array('company_id' => $companyId));

    $machineList = array();
    foreach ($mlTemp as $m) {
        if (!empty($m['used_id'])) { $machineList[$m['used_id']] = $m; }
    }
    $nowCount = count($machineList);

    //// ジャンル情報 ////
    // // 百貨店CSVを取得
    // if (($ugf = file2utf('./csv/used_genres.csv')) === FALSE) {
    //     throw new Exception('百貨店CSVファイルが開けませんでした');
    // }
    //
    // $uGenreList = array();
    // while (($ug = fgetcsv($ugf, 10000, ',')) !== FALSE) {
    //     $uGenreList[B::f($ug[3])] = array(
    //         'used_code'  => B::f($ug[3]),
    //         'used_genre' => B::f($ug[2]) . ' ' . B::f($ug[4]),
    //         'genre_id'   => B::f($ug[5]),
    //         'genre'      => B::f($ug[6]),
    //     );
    // }

    //// ジャンル情報(機械名マッチング) ////
    // CSVを取得
    if (($ugf = B::file2utf('./csv/crawl_genres.csv')) === FALSE) {
        throw new Exception('ジャンル変換表CSVファイルが開けませんでした');
    }

    $uGList = array();
    while (($ug = fgetcsv($ugf, 10000, ',')) !== FALSE) {
        $uGList[strtoupper(B::f($ug[0]))] = B::f($ug[1]);
    }

    // ジャル一覧を取得とIDをキーにするように整形
    $gModel    = new Genre();
    $glTemp    = $gModel->getList(array());
    $genreList = array();
    foreach ($glTemp as $g) {
        $genreList[$g['id']]             = $g;
        $uGList[strtoupper($g['genre'])] = $g['id'];
    }

    //// CSVファイル解析 ////
    $output = array();
    while (($data = fgetcsv($f, 10000, ',')) !== FALSE) {
        // インデックス行（1行目）はとばす
        // if (!$data[0] || !$data[3])         { continue; }
        if (!$data[0] || !$data[4])         { continue; }
        if (B::f($data[1]) == '在庫コード') { continue; }

        // データの整形
        /*
        $usedName = B::f($data[3]);
        $temp = array(
            'used_id'   => B::f($data[0]), // 百貨店ID
            'no'        => $data[1] != '-' ? B::f($data[1]) : '',
            'hint'      => $usedName,
            'maker'     => $data[4] != '-' ? B::f($data[4]) : '',
            'model'     => $data[5] != '-' ? B::f($data[5]) : '',

            'spec'      => $data[7] != '-' ? B::f($data[7]) : '',
            'accessory' => $data[8] != '-' ? B::f($data[8]) : '',
            'comment'   => $data[9] != '-' ? B::f($data[9]) : '',
            'year'      => ($data[6] != '-' && $data[6] != '0') ? intval(B::f($data[6])) : '',
            'price'     => !empty($data[14]) ? intval(B::f($data[14])  * 10000) : null,
        );
        */

        $usedName = B::f($data[4]);
        $temp = array(
            'used_id'    => B::f($data[0]), // 百貨店ID
            'no'         => $data[1] != '-' ? B::f($data[1]) : '',
            'hint'       => $usedName,
            'maker'      => $data[5] != '-' ? B::f($data[5]) : '',
            'model'      => $data[6] != '-' ? B::f($data[6]) : '',

            'spec'       => $data[8] != '-' ? B::f($data[8]) : '',
            'accessory'  => $data[9] != '-' ? B::f($data[9]) : '',
            'comment'    => $data[10] != '-' ? B::f($data[10]) : '',
            'year'       => ($data[7] != '-' && $data[7] != '0') ? intval(B::f($data[7])) : '',
            'price'      => !empty($data[15]) ? intval(B::f($data[15])  * 10000) : null,

            'youtube'    => !empty($data[29]) ? B::f($data[29]) : '',
            'commission' => !empty($data[31]) ? 1 : 0,
        );
        //// 画像ファイルの処理 ////
        $imgs = array();

        //// 画像ファイル名から、百貨店の会社IDを取得する処理 ////
        // URLからHTMLデータを取得
        if (empty($usedCompanyId)) {
            // if (!empty($data[19])) {
            if (!empty($data[20])) {
                // $uri    = 'http://www.jp.usedmachinery.bz/machines/show_images/' . $data[0];
                $uri    = 'https://www.jp.usedmachinery.bz/machines/general_view/' . $data[0];
                $client = new Zend_Http_Client($uri);
                $doc    = $client->request()->getBody();
            }

            if (!empty($doc)) {
                $zdq = new Zend_Dom_Query();
                $zdq->setDocument($doc);

                // 画像ファイル名を取得するクエリ
                // foreach ($zdq->query('img') as $i) {
                foreach ($zdq->query('.mod-pict__src') as $i) {
                    $s = $i->getAttribute('data-src');
                    if (!empty($s)) { $src = $s; break; }
                }

                // 取得した画像ファイル名から、百貨店の会社IDを取得
                // preg_match("/jpmachines.([0-9]+)/", $src, $matches);
                if (preg_match("/jpmachines.([0-9]+)/", $src, $matches)) {
                    $usedCompanyId = $matches[1];
                }
            }
        }

        //// 画像URI生成(4カラム) ////
        // foreach (array(19,20, 21, 22) as $v) {
        foreach (array(20, 21, 22, 23, 24, 25, 26, 27) as $v) {
        	if (!empty($data[$v]) && $data[$v] != '0' && $data[$v] != '-') {
                $imgs[] = "{$usedCompanyId}/{$data[0]}/{$data[$v]}";
            }
        }
        $temp['used_imgs'] = $imgs;

        //// ジャンル ////
        $usedCode = B::f($data[2]);
        $usedCode = str_replace('C', "'", B::f($data[2]));

        $sUsedName = preg_replace('/^[0-9.,a-zA-Z]*/', '', $usedName);
        if (!empty($uGenreList[$usedCode]['genre_id'])) {
            // 百貨店の機種コードから取得
            $temp['genre_id'] = $uGenreList[$usedCode]['genre_id'];
            $temp['genre']    = $uGenreList[$usedCode]['genre'];
        } else if (!empty($uGList[$sUsedName])) {
            // 20171031 機械名(頭の英数字を除外したもの)を機械名(ヒント)テーブルから取得
            $temp['genre_id'] = $uGList[$sUsedName];
            $temp['genre']    = $genreList[$temp['genre_id']]['genre'];
        } else if (!empty($uGList[$usedName])) {
           // 機械名(ヒント)テーブルから取得
           $temp['genre_id'] = $uGList[$usedName];
           $temp['genre']    = $genreList[$temp['genre_id']]['genre'];
        } else {
            // すべてマッチしなかった場合、その他機械にアサイン
            $temp['genre_id'] = 390;
            $temp['genre']    = 'その他機械';
        }

        //// 名前・主能力 ////
        $temp['capacity'] = null;
        if (!empty($genreList[$temp['genre_id']])) {
            $g = $genreList[$temp['genre_id']];

            // 命名規則
            $name = $g['naming'];

            // 入力された機械名から主能力を取得
            if (!empty($g['capacity_unit'])) {
                // 尺のもの(旋盤専用)
                if (preg_match('/(%lather%)/', $name)) {
                    if (preg_match('/^([0-9.]+)尺/i', $usedName, $mt)) {
                        if ($mt[1] == 3)      { $temp['capacity'] = 240; }
                        else if ($mt[1] == 4) { $temp['capacity'] = 360; }
                        else if ($mt[1] == 5) { $temp['capacity'] = 600; }
                        else if ($mt[1] == 6) { $temp['capacity'] = 800; }
                        else if ($mt[1] == 7) { $temp['capacity'] = 1000; }
                        else if ($mt[1] == 8) { $temp['capacity'] = 1200; }
                        else if ($mt[1] == 9) { $temp['capacity'] = 1500; }

                        $name = preg_replace('/(%lather%)/', $mt[1] . '尺', $name);
                    } else if (preg_match('/^([0-9.]+)m[^m]/i', $usedName, $mt)) {
                        $temp['capacity'] = $mt[1] * 1000; // m => mm変換
                        $name = preg_replace('/(%lather%)/', ($temp['capacity'] / 1000) . 'm', $name);
                    }

                } else if ($g['capacity_unit'] == 'mm' && preg_match('/^([0-9.]+)m[^m]/i', $usedName, $mt)) {
                    $temp['capacity'] = $mt[1] * 1000; // m => mm変換が必要なもの
                } else if (preg_match('/^([0-9.]+)'. $g['capacity_unit'] . '/i', $usedName, $mt)) {
                    $temp['capacity'] = $mt[1];
                }

                // 能力を名前に結合
                if (!empty($temp['capacity'])) {
                    $temp['capacity_unit'] = $g['capacity_unit'];
                    $name = preg_replace('/(%capacity%)/', $temp['capacity'], $name);
                    $name = preg_replace('/(%unit%)/', $g['capacity_unit'], $name);
                }
            }

            // 選択・自由記入(入力されたものそのまま)
            // $name = preg_replace('/(%free%|%select.*%)/', $usedName, $name);
            // $temp['name'] = preg_replace('/(%.*%)/', '', $name);
            $temp['name'] = $usedName;
        } else {
            $temp['name'] = $usedName;
        }

        //// 新規・変更 ////
        // if (!empty($temp['no']) && !empty($machineList[$temp['no']])) {
        if (!empty($temp['used_id']) && !empty($machineList[$temp['used_id']])) {
            // 変更の場合は、IDを取得
            $now = $machineList[$temp['used_id']];
            $temp['id'] = $now['id'];
            $temp += array(
                'top_img'    => $now['top_img'],
                'imgs'       => array(),
                'pdfs'       => $now['pdfs'],
                'catalog_id' => $now['catalog_id'],
                'others'     => $now['others'],
                'lat'        => $now['lat'],
                'lng'        => $now['lng'],
            );
            $updateCount++;
        } else {
            // 新規の場合は、変更しない項目の初期値を入力
            $temp += array(
                // 'commission'  => '0',
                'top_img'     => null,
                'imgs'        => array(),
                'pdfs'        => array(),
                'view_option' => null,
                'catalog_id'  => null,
                'others'      => array(),
            );

            // 在庫場所が空白(0,-の場合含む)の場合、空白にする
            if (!empty($data[9]) && !preg_match('/[-0]/', $data[9])) {
                $temp += array(
                    'location' => '本社',
                    'addr1'    => $company['addr1'],
                    'addr2'    => $company['addr2'],
                    'addr3'    => $company['addr3'],
                    'lat'      => $company['lat'],
                    'lng'      => $company['lng'],
                );
            } else {
                $temp += array(
                    'location' => null,
                    'addr1'    => null,
                    'addr2'    => null,
                    'addr3'    => null,
                    'lat'      => null,
                    'lng'      => null,
                );
            }
            $createCount++;
        }
        $output[] = $temp;
    }

    if (empty($output)) {
        throw new Exception('機械データが取得できませんでした');
    }
    // データをSESSIONに格納
    $_SESSION['system_csv_data']       = $output;
    $_SESSION['system_csv_company_id'] = $companyId;

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'   => 'CSV一括登録確認',
        'pankuzu'     => array(
            '/system/'             => '管理者ページ',
            '/system/csv_form.php' => 'CSV一括登録(百貨店汎用)',
        ),
        'machineList' => $output,
        'companyList' => $companyList,
        'company'     => $company,

        'nowCount'    => $nowCount,
        'createCount' => $createCount,
        'updateCount' => $updateCount,
        'deleteCount' => ($nowCount - $updateCount),
    ))->display("system/csv_conf.tpl");
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle'   => 'CSV一括登録',
        'pankuzu'     => array('/system/' => '管理者ページ',),
        'companyList' => $companyList,
        'errorMes'    => $e->getMessage()
    ))->display("system/csv_form.tpl");
}

//// 共通CSVフィルタ ////
function f($data)
{
    return B::f(mb_convert_encoding($data, 'UTF-8', 'sjis-win'));
}

function csv2utf($data)
{
    $temp = mb_convert_encoding($data, 'UTF-8', 'sjis-win');
    $expr = "/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/";
    $pattern = '/(?:^|,)(?:"((?:[^"]|"")*)"|([^,"]*))/';
    return preg_split($pattern, $temp);
}

function file2utf($path)
{
    $buf = mb_convert_encoding(file_get_contents($path), 'utf-8', 'sjis-win');
    $fp = tmpfile();
    fwrite($fp, $buf);
    rewind($fp);

    return $fp;
}


/**
 * ２つのURL（パス）を結合するときにスラッシュがある場合でもない場合でも
 * うまいこと結合して結果を返す
 *
 * @access public
 * @param  string $base    結合文字列（前）
 * @param  string $rel_path    結合文字列（後）
 * @return string/boolean 2つのパスの結合結果（失敗時はfalse）
 */
function makeUri($base='', $rel_path='')
{
    $base = preg_replace('/\/[^\/]+$/','/',$base);
    $parse = parse_url($base);
    if (preg_match('/^https\:\/\//',$rel_path) ){
        return $rel_path;
    }
    elseif ( preg_match('/^\/.+/', $rel_path) ){
        $out = $parse['scheme'].'://'.$parse['host'].$rel_path;
        return $out;
    }
    $tmp = array();
    $a = array();
    $b = array();
    $tmp = split('/',$parse['path']);
    foreach ($tmp as $v){
        if ($v){  array_push($a,$v); }
    }
    $b = split('/',$rel_path);
    foreach ($b as $v){
        if ( strcmp($v,'')==0 ){ continue; }
        elseif ($v=='.'){}
        elseif($v=='..'){ array_pop($a); }
        else{ array_push($a,$v); }
    }
    $path = join('/',$a);
    $out = $parse['scheme'].'://'.$parse['host'].'/'.$path;
    return $out;
}
