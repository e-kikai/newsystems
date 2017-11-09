<?php

require_once '../../../lib-machine.php';
try {
    //// 認証処理 ////
    Auth::isAuth('machine');
    
    /*
    //// 変数を取得 ////
    $bidOpenId = Req::query('o');
    $site      = Req::query('site');
    
    if (empty($bidOpenId)) {
        throw new Exception('入札会情報が取得出来ません');
    }
    
    //// 入札会情報を取得 ////
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);
    */
    
    //// 出品商品情報一覧を取得 ////
    $bmModel = new BidMachine();
    $q = array(
        'bid_open_id' => 4,
        'limit'       => Req::query('limit', 40),
        'page'        => Req::query('page', 1),
        'order'       => 'random',
    );
    $bidMachineList = $bmModel->getList($q);
    
} catch (Exception $e) {
    //// エラー画面表示 ////
    $_smarty->assign(array(
        'pageTitle' => '商品リスト',
        'pankuzu'   => array(),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja"> 
<head> 
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
  <meta http-equiv="Content-Style-Type" content="text/css" /> 
  <meta http-equiv="Content-Script-Type" content="text/javascript" /> 
  <title>中古機械のWeb入札会｜中古機械情報 マシンライフ（全日本機械業連合会）</title> 
  <meta name="description" content="中古機械のWeb入札会のご案内｜中古機械情報 マシンライフ（全機連）" /> 
  <meta name="keywords" content="中古機械,Web,Web入札会,マシンライフ,全機連,全日本機械業連合会" /> 
  <meta name="ROBOTS" content="INDEX,FOLLOW" /> 
  <link rel="stylesheet" href="./default.css" type="text/css" />
    <script src="./js/jquery-1.7.2.min.js"></script>
    <script src="./js/lightbox.js"></script>
    <link rel="stylesheet" href="./lightbox.css"/>
  <script type="text/javascript" src="../../js/google_analytics.js"></script>
</head>

<body>
<div class="free_link"><a href="#"><img src="./img/pagetop.gif" width="50" height="200" alt=""></a></div>
<div id="wrapper">
<div id="white_bg">



<div><a href="../../bid201403.html"><img src="./img/c_00.png"　alt="第3回全機連Web入札会のご案内"></a></div>
<div id="cont_img">


<?php foreach($bidMachineList as $m): ?>
<div class="thumb_img"><a href="../../media/machine/<?=$m['top_img'];?>" rel="lightbox[thumbs]"><img  src="../../media/machine/<?=$m['top_img'];?>" style="max-height:147px;max-width:196px;" /></a></div>
<?php endforeach; ?>

</div>
<br clear=all>

<div id="cont">【　<a href="../../bid201403.html">前のページに戻る</a>　】</div>


<div><a href="/"><img src="./img/c_footer.png"　alt="中古機械のWeb入札会 マシンライフ 全機連"></a></div>
</div>
</div>
</body> 
</html>
