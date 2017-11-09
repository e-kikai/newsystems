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
    
    $list = array();
    
    // トップページほか
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/',
        'priority'   => '1.0',
        'changefreq' => 'hourly',
    );
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/bid_lp.php',
        'priority'   => '0.9',
        'changefreq' => 'hourly',
    );
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/bid_schedule.php',
        'priority'   => '0.8',
        'changefreq' => 'hourly',
    );
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/news.php?pe=3',
        'priority'   => '0.4',
        'changefreq' => 'hourly',
    );
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/company_list.php',
        'priority'   => '0.4',
        'changefreq' => 'hourly',
    );
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/sitemap.php',
        'priority'   => '0.7',
        'changefreq' => 'hourly',
    );
    $list[] = array(
        'loc'        => 'http://www.zenkiren.net/help_banner.php',
        'priority'   => '0.2',
        'changefreq' => 'hourly',
    );

    //// 大ジャンル一覧を取得 ////
    $largeGenreTable = new LargeGenres();
    $largeGenreList  = $largeGenreTable->getList();
    foreach ($largeGenreList as $l) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/search.php?l=' . $l['id'],
            'priority'   => '0.9',
            'changefreq' => 'daily',
        );
    }
    
    //// ジャンル一覧を取得 ////
    $genreTable = new Genres();
    $genreList  = $genreTable->getList();
    foreach ($genreList as $g) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/search.php?g=' . $g['id'],
            'priority'   => '0.9',
            'changefreq' => 'daily',
        );
    }
    
    //// 会社一覧を取得 ////
    $companyTable = new Companies();
    $companyList  = $companyTable->getList(array('notnull' => true));
    foreach ($companyList as $c) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/company_detail.php?c=' . $c['id'],
            'priority'   => '0.6',
            'changefreq' => 'daily',
        );
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/search.php?c=' . $c['id'],
            'priority'   => '0.7',
            'changefreq' => 'daily',
        );
    }
    
    //// 機械詳細 ////
    $sql = "SELECT id FROM machines WHERE deleted_at IS NULL AND (view_option IS NULL OR view_option <> 1);";
    $res = $_db->fetchAll($sql);
    foreach ($res as $m) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/machine_detail.php?m=' . $m['id'],
            'priority'   => '1.0',
            'changefreq' => 'daily',
        );
    }

    //// 20150219@ba-ta 特大ジャンル ////
    $xlGenreTable = new XlGenres();
    $xlGenreList  = $xlGenreTable->getList();
    foreach ($xlGenreList as $x) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/search.php?x=' . $x['id'],
            'priority'   => '0.7',
            'changefreq' => 'daily',
        );
    }

    //// 20150219@ba-ta メーカー ////
    $machineTable = new Machine();
    $makerList    = $machineTable->getMakerList(array('notnull' => true, 'sort' => 'maker'));
    foreach ($makerList as $ma) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/search.php?ma=' . str_replace('&', '&amp;', $ma['maker']),
            'priority'   => '0.8',
            'changefreq' => 'daily',
        );
    }

    //// 20150310@ba-ta ジャンル/メーカー ////
    $largeMakerList = $machineTable->getDoubleSearchList('', 5);
    foreach ($largeMakerList as $lma) {
        $list[] = array(
            'loc'        => 'http://www.zenkiren.net/search.php?l=' . $lma['large_genre_id'] . '&amp;ma=' . str_replace('&', '&amp;', $lma['maker_master']),
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
            'loc'        => 'http://www.zenkiren.net/search.php?k=' . $a['state'],
            'priority'   => '0.8',
            'changefreq' => 'daily',
        );
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
	$buf  = '';
	$buf .= '<?xml version="1.0" encoding="UTF-8"?>'."\n";
	$buf .= '<urlset'."\n";
	$buf .= '      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"'."\n";
	$buf .= '      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'."\n";
	$buf .= '      xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9'."\n";
	$buf .= '            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">'."\n";
	$buf .= '<!-- created with Free Online Sitemap Generator www.xml-sitemaps.com -->'."\n";
	
	if (isset($sitemap_list) and is_array($sitemap_list))
	{
		foreach($sitemap_list as $val)
		{
			$buf .= '<url>'."\n";
			$buf .= '  <loc>'.$val['loc'].'</loc>'."\n";
			$buf .= '  <priority>'.$val['priority'].'</priority>'."\n";
			$buf .= '  <changefreq>'.$val['changefreq'].'</changefreq>'."\n";
			$buf .= '</url>'."\n";
		}
	}
	$buf .= '</urlset>'."\n";
	
	header('Content-type: application/xml; charset="utf-8"',true);
	echo $buf;
}
