{include "include/html_header.tpl"}

<meta name="description" content="
{if !empty({$machine.capacity}) && !empty({$machine.capacity_label})}{$machine.capacity_label}:{$machine.capacity}{$machine.capacity_unit} | {/if}
" />
<meta name="keywords" content="{$machine.name},{$machine.hint},{$machine.maker},{$machine.model},中古機械,全機連,マシンライフ" />

<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}detail.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}detail.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
<link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 印刷ボタン ////
    $('<button class="print"><img src="./imgs/print_icon3.png" />ページを印刷</button>')
        .appendTo('.center_container');
    
    $('button.print').click(function() {
        $('img.lazy').each(function() {
            $(this).attr('src', $(this).data('original'));
        });
        window.print();
        _gaq.push(['_trackEvent', 'common', 'print', 'button', 1, true]);
    });
    
    // foe IE
    document.body.onbeforeprint = function() {
        $('img.lazy').each(function() {
            $(this).attr('src', $(this).data('original'));
        });
        _gaq.push(['_trackEvent', 'common', 'print', 'IE', 1, true]);
    };
});
</script>
<style type="text/css">
button.mylist {
  width: 100px;
  height: 48px;
  top: 8px;
  right: 8px;
}

button.mylist:active {
  box-shadow: none;
  top: 9px;
}

.spec_area {
  width: 100%;
}

table.spec {
  float: left;
  margin-right: 8px;
}

.large_img_area img {
  width: 100%;
  margin-bottom: 8px;
}

/*** companybid ***/
.companybid-area {
  width: auto;
  border: 1px dotted #147543;
  padding: 4px;
  margin: 1px auto;
}

.companybid-area .companybid-title {
  font-weight: bold;
  font-size: 19px;
  margin-bottom: 12px;
  text-align: left;
}

.companybid-strong {
  font-size: 15px;
  margin: 6px 0 3px 0;
}

body.mini {
  background: #FFF;
}
</style>
{/literal}
</head>
<body class="mini">
<div class="main_container">
  <div class="center_container">

  {*** パンくず ***}
  {if !isset($pankuzu) || $pankuzu !== false}
    <div class="pankuzu">
      {if !empty($pankuzu)}
        {foreach from=$pankuzu key=k item=p name='pun'}
          <a href="{$k}" onClick="_gaq.push(['_trackEvent', 'pankuzu', 'other', '{$k}', 1, true])">{$p}</a> &gt;
        {/foreach}
      {/if}
      
      {if !empty($pankuzuTitle)}
        <strong>{$pankuzuTitle|truncate:50:" ほか"}</strong>
      {elseif !empty($pageTitle)}
        <strong>{$pageTitle|truncate:50:" ほか"}</strong>
      {/if}
    </div>
    
    {if !empty($h1Title)}
      <h1>{$h1Title|truncate:50:" ほか"}</h1>
    {elseif !empty($pageTitle)}
      <h1>{$pageTitle|truncate:50:" ほか"}</h1>
    {/if}
    
    {if isset($pageDescription)}
      <div class="description">{$pageDescription}</div>
    {/if}
  {/if}

<div class="companybid-area">
  <div class="companybid-strong">
    下見期間 : 
    {$companybidOpen.preview_start_date|date_format:'%Y年%m月%d日'} ({B::strtoweek($companybidOpen.preview_start_date)})
     ～
    {$companybidOpen.preview_end_date|date_format:'%m月%d日'} ({B::strtoweek($companybidOpen.preview_end_date)})
  </div>
  {$companybidOpen.preview_date_comment}

  <div class="companybid-strong">
    入札日時 : 
    {$companybidOpen.bid_date|date_format:'%Y年%m月%d日'} ({B::strtoweek($companybidOpen.bid_date)})
    {$companybidOpen.bid_date|date_format:'%H:%M'}
  </div>
  {$companybidOpen.bid_date_comment}

  <div class="companybid-strong">入札会場 : {$companybidOpen.bid_location}</div>
  {if !empty($companybidOpen.bid_address)}
    {$companybidOpen.bid_address} 
    <a class="accessmap" href="https://maps.google.co.jp/maps?f=q&amp;q={$companybidOpen.bid_address|escape:"url"}+({$companybidOpen.bid_location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14" target="_blank">MAPはこちら</a>
  {/if}
</div>

{if !empty($machine)}

<div class='detail_container'>    
  <div class="spec_area">
    <table class="spec">
      <tr class="" >
        <th>出品番号</th>
        <td class="bid_machine_id">{$machine.list_no}</td>
      </tr>
      <tr class="" >
        <th>機械名</th>
        <td>{$machine.name}</td>
      </tr>
      <tr class="" >
        <th>メーカー</th>
        <td>{$machine.maker}</td>
      </tr>
      <tr class="" >
        <th>型式</th>
        <td>{$machine.model}</td>
      </tr>
      <tr class="" >
        <th>年式</th>
        <td>{$machine.year}</td>
      </tr>
    </table>
        
    <table class="spec">
      <tr class="price">
        <th>最低入札金額</th>
        <td class="detail_min_price">{$machine.min_price|number_format}円</td>
      </tr>
    </table>
    
    <table class="spec">
      {if !empty($machine.capacity_label)}
        <tr class="capacity number" >
          <th>{$machine.capacity_label}</th>
          <td>{if empty($machine.capacity)}-{else}{$machine.capacity}{$machine.capacity_unit}{/if}</td>
        </tr>
      {/if}
      
      <tr class="spec">
        <th>仕様</th>
        <td>
          {if !empty($others)}
            <div class="others">{$others|escape|regex_replace:"/\s\|\s/":'</div> | <div class="others">'|regex_replace:"/alert\((.*)\)/":'<span style="color:red;">$1</span>' nofilter}</div> |
          {/if}
          {if !empty($machine.spec)}
            <div class="others">{$machine.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">'|regex_replace:"/alert\((.*)\)/":'<span style="color:red;">$1</span>' nofilter}</div>
          {/if}
        </td>
      </tr>
      <tr class="comment">
        <th>備考</th>
        <td>{$machine.comment}</td>
      </tr>
      <tr class="">
        <th>下見会場</th>
        <td class='location'>
          {$machine.location}
          {foreach $companybidOpen.preview_locations as $lo}
            {if $lo.location == $machine.location}
              <br />
              {$lo.address}
              <a class="accessmap" href="https://maps.google.co.jp/maps?f=q&amp;q={$lo.address|escape:"url"}&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14" target="_blank">MAPはこちら</a><br />
              {$lo.comment}
            {/if}
          {/foreach}
        </td>
      </tr>
    </table>
    <br class="clear" />
  </div>
  <br class="clear" />
  {*
  </div>
  <div class="spec_area">
    <h2 class="" id="company_area">出品会社情報</h2>
    <table class="spec">
      <tr class="">
        <th>会社名</th>
        <td>
          <a href='company_detail.php?c={$machine.company_id}'>{$company.company}</a>
          <a class="contact" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank">お問い合せ</a>
        </td>
      </tr>
      <tr class="">
        <th>住所</th>
        <td>
          〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}<br />
           {$company.addr1} {$company.addr2} {$company.addr3}
        </td>
      </tr>
      
      <tr class="">
        <th>お問い合せTEL</th>
        <td>{$company.contact_tel}</td>
      </tr>
      <tr class="">
        <th>お問い合せFAX</th>
        <td>{$company.contact_fax}</td>
      </tr>
      
      <tr class="">
        <th>担当者</th>
        <td>{$company.officer}</td>
      </tr>
  
      <tr class='infos opening'>
        <th>営業時間</th>
        <td>{$company.infos.opening}</td>
      </tr>
      
      <tr class='infos holiday'>
        <th>定休日</th>
        <td>{$company.infos.holiday}</td>
      </tr>
      
      <tr class='infos license'>
        <th>古物免許</th>
        <td>{$company.infos.license}</td>
      </tr>
      
      <tr class='infos complex'>
        <th>所属団体</th>
        <td>{$company.treenames}</td>
      </tr>
    </table>
  </div>
  *}
  <br class="clear" />
  

  {*** 画像 ***}
  <div class="large_img_area">
  {if empty($machine.imgs)}
    {*
    <img class='noimage' src='./imgs/noimage.png' alt="" />
    *}
  {else}
    {foreach $machine.imgs as $i}
      {*
      <img class="lazy" src='imgs/blank.png' data-original="/media/companybid/{$i}" alt='' />
      <noscript><img src="/media/companybid/{$i}" alt='' /></noscript>
      *}
      <img src="/media/companybid/{$i}" alt='' />
    {/foreach}
  {/if}
  </div>
</div>
{else}
  <div class="error_mes">
    指定された方法では、入札会商品情報の特定ができませんでした<br />
    誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
  </div>
{/if}

</div>

<a title="Web Analytics" href="http://clicky.com/100784739"><img alt="Web Analytics" src="//static.getclicky.com/media/links/badge.gif" border="0" /></a>
<script src="//static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init(100784739); }catch(e){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100784739ns.gif" /></p></noscript>

<footer>
  <p class="copyright">
    Copyright &copy; {$smarty.now|date_format:"%Y"}
    <a href="{$_conf.website_uri}" target="_blank">{$_conf.copyright}</a>
    All Rights Reserved.
  </p>
</footer>

</body> 
</html>
