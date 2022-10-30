<?php
/**
 * サイトマップ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/11/08
 */
require_once '../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');

    //// パラメータ取得 ////
    $m   = Req::query('m');

    $list    = array();
    $lg_1    = "61, 62";
    $lg_2    = "63, 64";
    $sepa_lg = "61, 62, 63, 64";

    if ($m == 1) {
        //// 機械詳細 ////
        $sql = "SELECT id FROM view_machines WHERE deleted_at IS NULL AND (view_option IS NULL OR view_option <> 1) AND large_genre_id IN (${lg_1});";
        $res = $_db->fetchAll($sql);
        foreach ($res as $m) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/machine_detail.php?m=' . $m['id'],
                'priority'   => '1.0',
                'changefreq' => 'daily',
            );
        }
    } else if ($m == 2) {
        //// 機械詳細 ////
        $sql = "SELECT id FROM view_machines WHERE deleted_at IS NULL AND (view_option IS NULL OR view_option <> 1) AND large_genre_id IN (${lg_2});";
        $res = $_db->fetchAll($sql);
        foreach ($res as $m) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/machine_detail.php?m=' . $m['id'],
                'priority'   => '1.0',
                'changefreq' => 'daily',
            );
        }
    } else if ($m == 999) {
        //// 機械詳細 ////
        $sql = "SELECT id FROM view_machines WHERE deleted_at IS NULL AND (view_option IS NULL OR view_option <> 1) AND large_genre_id NOT IN (${sepa_lg});";
        $res = $_db->fetchAll($sql);
        foreach ($res as $m) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/machine_detail.php?m=' . $m['id'],
                'priority'   => '1.0',
                'changefreq' => 'daily',
            );
        }
    } else {
        // トップページほか
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/',
            'priority'   => '1.0',
            'changefreq' => 'hourly',
        );
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/bid_lp.php',
            'priority'   => '0.9',
            'changefreq' => 'hourly',
        );
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/bid_schedule.php',
            'priority'   => '0.8',
            'changefreq' => 'hourly',
        );
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/news.php?pe=3',
            'priority'   => '0.4',
            'changefreq' => 'hourly',
        );
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/company_list.php',
            'priority'   => '0.4',
            'changefreq' => 'hourly',
        );
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/sitemap.php',
            'priority'   => '0.7',
            'changefreq' => 'hourly',
        );
        $list[] = array(
            'loc'        => 'https://www.zenkiren.net/help_banner.php',
            'priority'   => '0.2',
            'changefreq' => 'hourly',
        );

        //// 大ジャンル一覧を取得 ////
        $largeGenreTable = new LargeGenres();
        $largeGenreList  = $largeGenreTable->getList();
        foreach ($largeGenreList as $l) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?l=' . $l['id'],
                'priority'   => '0.9',
                'changefreq' => 'daily',
            );
        }

        //// ジャンル一覧を取得 ////
        $genreTable = new Genres();
        $genreList  = $genreTable->getList();
        foreach ($genreList as $g) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?g=' . $g['id'],
                'priority'   => '0.9',
                'changefreq' => 'daily',
            );
        }

        //// 会社一覧を取得 ////
        $companyTable = new Companies();
        $companyList  = $companyTable->getList(array('notnull' => true));
        foreach ($companyList as $c) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/company_detail.php?c=' . $c['id'],
                'priority'   => '0.6',
                'changefreq' => 'daily',
            );
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?c=' . $c['id'],
                'priority'   => '0.7',
                'changefreq' => 'daily',
            );
        }

        // //// 機械詳細 ////
        // $sql = "SELECT id FROM machines WHERE deleted_at IS NULL AND (view_option IS NULL OR view_option <> 1);";
        // $res = $_db->fetchAll($sql);
        // foreach ($res as $m) {
        //     $list[] = array(
        //         'loc'        => 'https://www.zenkiren.net/machine_detail.php?m=' . $m['id'],
        //         'priority'   => '1.0',
        //         'changefreq' => 'daily',
        //     );
        // }

        //// 20150219@ba-ta 特大ジャンル ////
        $xlGenreTable = new XlGenres();
        $xlGenreList  = $xlGenreTable->getList();
        foreach ($xlGenreList as $x) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?x=' . $x['id'],
                'priority'   => '0.7',
                'changefreq' => 'daily',
            );
        }

        //// 20150219@ba-ta メーカー ////
        $machineTable = new Machine();
        $makerList    = $machineTable->getMakerList(array('notnull' => true, 'sort' => 'maker'));
        foreach ($makerList as $ma) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?ma=' . str_replace('&', '&amp;', $ma['maker']),
                'priority'   => '0.8',
                'changefreq' => 'daily',
            );
        }

        //// 20150310@ba-ta ジャンル/メーカー ////
        $largeMakerList = $machineTable->getDoubleSearchList('', 5);
        foreach ($largeMakerList as $lma) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?l=' . $lma['large_genre_id'] . '&amp;ma=' . str_replace('&', '&amp;', $lma['maker_master']),
                'priority'   => '0.8',
                'changefreq' => 'daily',
            );
        }

        //// 20150219@ba-ta 都道府県 ////
        $stateTable  = new States();
        $addr1List   = $stateTable->getListByTop();
        foreach ($addr1List as $a) {
            if (empty($a['count'])) { continue; }
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/search.php?k=' . $a['state'],
                'priority'   => '0.8',
                'changefreq' => 'daily',
            );
        }

        //// web入札会情報 ////
        $cModel  = new BidOpen();
        $bmModel = new BidMachine();
        $bidOpenList = $cModel->getList(array('isopen' => true));
        foreach ($bidOpenList as $bo) {
            $list[] = array(
                'loc'        => 'https://www.zenkiren.net/bid_door.php?o='. $bo["id"],
                'priority'   => '0.95',
                'changefreq' => 'daily',
            );

            $q = array('bid_open_id' => $bo["id"]);
            $bidMachineList = $bmModel->getList($q);

            foreach ($bidMachineList as $bm) {
                $list[] = array(
                    'loc'        => 'https://www.zenkiren.net/bid_detail.php?m='. $bm["id"],
                    'priority'   => '0.95',
                    'changefreq' => 'daily',
                );
            }
        }
    }

    get_google_sitemap($list);

    exit;
} catch (Exception $e) {
    exit($e->getMessage());
}

// Googleのサイトマップ(XML)を生成関数
/*
 * @ param   sitemap_list : array
 * @ retrun  string
 */
function get_google_sitemap($sitemap_list = array())
{
  $buf = '<?xml version="1.0" encoding="UTF-8"?>'."\n";
  // $buf .= '<urlset'."\n";
  // $buf .= '      xmlns="https://www.sitemaps.org/schemas/sitemap/0.9"'."\n";
  // $buf .= '      xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"'."\n";
  // $buf .= '      xsi:schemaLocation="https://www.sitemaps.org/schemas/sitemap/0.9'."\n";
  // $buf .= '            https://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">'."\n";
  // $buf .= '<!-- created with Free Online Sitemap Generator www.xml-sitemaps.com -->'."\n";

  $buf .= '<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1" xmlns:video="http://www.google.com/schemas/sitemap-video/1.1" xmlns:news="http://www.google.com/schemas/sitemap-news/0.9" xmlns:mobile="http://www.google.com/schemas/sitemap-mobile/1.0" xmlns:pagemap="http://www.google.com/schemas/sitemap-pagemap/1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml">';

  if (isset($sitemap_list) and is_array($sitemap_list)) {
    foreach($sitemap_list as $val) {
      $buf .= '<url>'."\n";
      $buf .= '  <loc>'.$val['loc'].'</loc>'."\n";
      $buf .= '  <priority>'.$val['priority'].'</priority>'."\n";
      $buf .= '  <changefreq>'.$val['changefreq'].'</changefreq>'."\n";
      $buf .= '</url>'."\n";
    }
  }
  $buf .= "</urlset>";

  header('Content-type: application/xml; charset="utf-8"', true);
  echo $buf;
}
