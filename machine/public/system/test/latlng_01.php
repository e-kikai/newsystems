<?php
/**
 * latlng test
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('system');
    
    //// パラメータ取得 ////


    $res = $_db->fetchAll('SELECT * FROM companies WHERE lat IS NULL;');
    
    foreach ($res as $c) {
        
        
        $address = $c['addr1'] . $c['addr2'] . $c['addr3'];
        $req = 'http://maps.google.com/maps/api/geocode/xml';
        $req .= '?address='.urlencode($address);
        $req .= '&sensor=false';
        
        $xml = simplexml_load_file($req) or die('XML parsing error');
        if ($xml->status == 'OK') {
            $location = $xml->result->geometry->location;
            $lat = $location->lat;
            $lng = $location->lng;
            
            $f = $_db->update('companies', array(
                    'lat' => $location->lat,
                    'lng' => $location->lng,
                ), $_db->quoteInto(' id = ? ', $c['id']));
            echo "{$f} {$c['company']} : {$address} >> {$lat}, {$lng}<br />";
            sleep(0.1);
        } else {
            echo $xml->status . "<br />";
        }
    }
    

} catch (Exception $e) {
    //// 表示変数アサイン ////
    echo 'システムエラー';
    echo '<pre>';
    echo $e->getMessage();
    echo '</pre>';
}
