{extends file='include/toppage_layout.tpl'}

{block 'header'}
{*
<meta name="description" content="中古機械情報のサイト。半世紀の歴史を持つ、全国唯一の機械商社の全国組織「全機連」会員の信頼と安心の中古機械情報をお届け致します" />
<meta name="keywords" content="中古機械,全機連,全日本機械業連合会,used machine,中古旋盤,中古鍛圧" />
*}

{*
<meta name="description" content="マシンライフは、全国機械業連合会(全機連)が運営する中古機械のインターネット情報サイトです。中古機械のスペシャリスト同士が利用、非会員の方には会員による仲介も可能です。また購入後もサポートが受けられ、万が一の場合も全機連が仲介いたします。" />

<meta name="description"
  content="全国機械業連合会が運営する中古機械の情報サイト。中古機械のスペシャリスト全機連会員が、購入・販売をご支援します。" />
*}
<meta name="description"
  content="全機連会員100社以上の中古機械検索を中心に、電子カタログ、Web入札会など工作機械に関する様々な情報を掲載。" />

<meta name="keywords" content="中古機械,全機連,中古旋盤,中古フライス,マシンライフ" />

<link href="{$_conf.site_uri}{$_conf.css_dir}toppage.css?20150811" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/javascript">
$(function() {
    $('.xl_area .xl_genre').click(function() {
        var $_self = $(this);
        var xl = $_self.data('xl');
        var $_disp = $('.xl_large_genre_area.xl_' + xl);

        if ($_disp.css('display') == 'block') {
            $_disp.slideUp('fast');
        } else {
            $('.xl_large_genre_area').hide();
            $_disp.css({'top': $_self.position().top + 48, 'left': $_self.position().left + 16}).slideDown('fast');
        }
    });

    //// move banner ////
    /*
    $('.sp_area .banner').hide();
    $('.sp_area .banner:first').show();
    var spTimer = setInterval(function() {
        var $_now = $('.sp_area .banner:visible');

        if ($_now.next('.banner').size()) {
            $_now.next('.banner').show();
        } else {
            $('.sp_area .banner:first').show();
        }
        $_now.hide();
    }, 4500);
*/

    //// Optimizely ////
/*
    window['optimizely'] = window['optimizely'] || [];

    $(document).on('submit', '.keyword > form, toppage-keyword_area > fomr', function() {
        window.optimizely.push(["trackEvent", "searcn"]);
    });

    $(document).on('submit', '.keyword_area > form', function() {
        window.optimizely.push(["trackEvent", "right_searcn"]);
    });
*/
});
</script>
<style>
</style>
{/literal}
{/block}

{block 'main'}

<div class="bg_margin"></div>
<div class="sp_area">
  {*
  <a class="banner" href="bid_door.php?o=2" target="_blank" style="display:block;"
    onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'bid_02', 1, true]);"
    ><img src="imgs/top_banner_bid_02.jpg" alt="" /></a>
  <a class="banner" href="http://www.omdc.or.jp/?page_id=434" target="_blank" style="display:block;"
    onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'omdc_165', 1, true]);"
    ><img src="imgs/top_banner_omdc_02.jpg" alt="" /></a>
  <a class="banner" href="http://www.umc.gr.jp/" style="display:none;" target="_blank"
    onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'spotsale_01', 1, true]);"
    ><img src="imgs/top_banner_spotsale_02.jpg" alt="" /></a>

  <img class="banner" src="imgs/top_banner_mix_02_04.jpg" usemap="#top_banner_mix_02" style="display:block;" />
  <map name="top_banner_mix_02">
    <area shape="rect" coords="0,0,320,147" href="http://www.omdc.or.jp/?page_id=434" target="_blank"
      onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'mix_bid_02', 1, true]);" />
    <area shape="rect" coords="320,0,640,147" href="bid_door.php?o=2" target="_blank"
      onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'mix_omdc_165', 1, true]);" />
    <area shape="rect" coords="640,0,960,147" href="http://www.umc.gr.jp/" target="_blank"
      onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'mix_spotsale_01', 1, true]);" />
  </map>

  <a class="banner" href="http://www.omdc.or.jp/?page_id=434" target="_blank" onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'omdc_168', 1, true]);">
    <img src="media/banner/omdc_168.png" alt="" />
  </a>
  <a class="banner" href="http://www.umc.gr.jp/" target="_blank" onClick="_gaq.push(['_trackEvent', 'banner', 'sp', 'spotsale_03', 1, true]);">
    <img src="media/banner/spotsale_03.png" alt="" />
  </a>
  *}

  {if empty($bidOpenList)}
    {*
    <a href="bid_lp.php" onclick="ga('send', 'event','banner', 'sp', 'bid_schedule_2015', 1, true);">
      <img src="imgs/banner_tender_schedule_2015.png" alt="マシンライフWeb入札会 2015年度 開催日程" />
    </a>
    *}

    {*
    <div class="bid_auto_banner">
      <div class="bid_banner_title_02">
        <span class="bid_banner_title_mini">全機連主催</span>
        {$bidYear}年度<br />Web入札会 日程
      </div>
      <div class="bid_lp">
        {foreach $bidOpenYearList as $bo}
          {if $bo.user_bid_date|date_format:"%Y%m%d" > date('Ymd')}
            <a class="bid_lp_link" href="/bid_lp.php?o={$bo.id}" onclick="ga('send', 'event','banner', 'sp', 'bid_lp_{$bo.id}', 1, true);">
          {else}
            <span class="bid_lp_end">
          {/if}
            {$bo.title|regex_replace:'/Web入札会/':''}
            {$bo.preview_start_date|date_format:"%m/%d"}({B::strtoweek($bo.preview_start_date)}) 〜

            {if $bo.user_bid_date|date_format:"%Y" != $bidYear}
              {$bo.user_bid_date|date_format:"%Y/%m/%d"}({B::strtoweek($bo.user_bid_date)})
            {else}
              {$bo.user_bid_date|date_format:"%m/%d"}({B::strtoweek($bo.user_bid_date)})
            {/if}
            {$bo.user_bid_date|date_format:"%k:%M"}
          {if $bo.user_bid_date|date_format:"%Y%m%d" > date('Ymd')}
            </a>
          {else}
            </span>
          {/if}

          <br />
        {/foreach}
      </div>
    </div>
    *}

  {else}
    {foreach $bidOpenList as $b}
      <a class="bid_auto_banner" href="bid_{if strtotime($b.preview_start_date) >= time()}lp{else}door{/if}.php?o={$b.id}"
        target="_blank" onclick="ga('send', 'event','banner', 'sp', 'bid_{$b.id}', 1, true);">
        <div class="bid_banner_title">{$b.title|escape|regex_replace:'/(Web入札会|([a-zA-Z])+|([^a-zA-Z])+)/':'<span>$1</span>' nofilter}</div>
        <div class="bid_banner_info">
          下見期間 : {$b.preview_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($b.preview_start_date)}) ～
           {$b.preview_end_date|date_format:'%m月%d日'}({B::strtoweek($b.preview_end_date)})<br />
          入札締切 : {$b.user_bid_date|date_format:'%Y年%m月%d日'}({B::strtoweek($b.user_bid_date)})
          {$b.user_bid_date|date_format:'%H:%M'}
        </div>
        {if strtotime($b.preview_start_date) < time() && strtotime($b.user_bid_date) >= time()}}
          <div class="bid_banner_now"><span>ただいま開催中！ Click▶</span></div>
        {/if}
        {if strtotime($b.user_bid_date) < time()}
          <div class="bid_banner_end"><span>終了致しました</span></div>
        {/if}
      </a>
    {/foreach}
  {/if}

  {*
  <a href="http://www.xn--4bswgw9cs82at4b485i.jp/?machinelife=1" target="_blank" onclick="ga('send', 'event','banner', 'sp', 'omdc2_01', 1, true);">
    <img src="imgs/omdc2_01.png" alt="大阪機械卸業団地組合 機械工具入札会" style="width:100%;"/>
  </a>
  *}

  {*
  <a href="https://www.deadstocktool.com/" target="_blank" onclick="ga('send', 'event','banner', 'sp', 'dst_01', 1, true);">
    <img src="imgs/dst_01.jpg" alt="大阪機械卸業団地組合 デッドストックツール.com" style="width:100%;"/>
  </a>
  *}
</div>

{*
<div style="border:1px solid #ebccd1;background:#f2dede;color:#a94442;font-size:15px;padding:4px 32px;">
  <div style="font-weight:bold;text-align:center;"><<重要なお知らせ>></div>
  <p>
9/19(土)サーバメンテナンスのため下記サイトが使えなくなります。<br />
 <li><a href="http://www.zenkiren.net/" target="_blank">マシンライフ</a></li>
 <li><a href="http://catalog.zenkiren.net/" target="_blank">電子カタログ</a></li>
 <li><a href="http://www.zenkiren.org/" target="_blank">全機連ウェブサイト</a></li>
大変ご迷惑をお掛けしますが、ご了承ください。<br />
  </p>
</div>
*}

<div class="xl_area">
  {*** キーワード検索 ***}
  <div id="keyword-search">
    <h2>中古機械キーワード検索</h2>
    <div class="toppage-keyword_area">
      <form action='/search.php' method='get' id="toppage_search"
        onsubmit="ga('send', 'event', 'search', 'toppage', $('input.keyword_search.toppage').val(), 1, true);">
        <input type="text" class="keyword_search toppage" name="k" value="" placeholder="例) 2SP-50H オークマ" />
        <button type="submit" class="keyword_submit">検索</button>
      </form>
    </div>
  </div>

  {*** 大ジャンル一覧 ***}
  <h2>中古機械ジャンル検索</h2>
  {*
  {foreach $xlGenreList as $x}
    <div class="xl_genre xl_{$x.id}" data-xl="{$x.id}">{$x.xl_genre} ({$x.count})</div>
    <div class="xl_large_genre_area xl_{$x.id}"></div>
  {/foreach}
  *}

  {foreach $xlGenreList as $x}
    <div class="xl_genre xl_{$x.id}" data-xl="{$x.id}">
      {$x.xl_genre} ({$x.count})
    </div>
    <div class="xl_large_genre_area xl_{$x.id}">
      {foreach $largeGenreList as $l}
        {if $l.xl_genre_id == $x.id}
           <a href="search.php?l={$l.id}" class="genre xl_{$l.xl_genre_id}">
             <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
           </a>
        {/if}
      {/foreach}
    </div>
  {/foreach}
</div>

{*** キーワード検索枠 ***}
<div class="keyword_area">
  <h2>在庫地域検索</h2>
  <form action='/search.php' method='get'
      onsubmit="ga('send', 'event', 'search', 'location', $('select.addr1').val(), 1, true);"
    >
    <select name="k" class="addr1">
      <option value="">▼選択▼</option>
      {foreach $addr1List as $a}
        <option value="{$a.state}" {if empty($a.count)}class="empty"{/if}>{$a.state} {if !empty($a.count)}({$a.count}){/if}</option>
      {/foreach}
    </select>
    <button type="submit" class="keyword_submit">検索</button>
  </form>
</div>

<div class="keyword_area">
  <h2>キーワード検索</h2>
  <form action='/search.php' method='get'
      onsubmit="ga('send', 'event', 'search', 'model', $('input.keyword_search.model').val(), 1, true);">
    <div class="keyword_label">型式から検索</div>
    <input type="text" class="keyword_search model" name="k" value="" placeholder="例) 2SP-150H" />
    <button type="submit" class="keyword_submit">検索</button>
  </form>

  <form action='/search.php' method='get'
      onsubmit="ga('send', 'event', 'search', 'maker', $('input.keyword_search.maker').val(), 1, true);">
    <div class="keyword_label">メーカー名から検索</div>
    <input type="text" class="keyword_search maker" name="k" value="" placeholder="例) オークマ" />
    <button type="submit" class="keyword_submit">検索</button>
  </form>
</div>

<br style="clear:both;" />

{*** ジャンル一覧選択用 ***}
<noscript>
{include file="include/genre_list_check.tpl"}
</noscript>

{*** 入札会 ***}
<div class="premium_bid">
  {*
  <a href="https://www.deadstocktool.com/"  target="_blank"
    onClick="ga('send', 'event', 'banner', 'bid', 'dst_01', 1, true);">
    <img src="./imgs/dst_02.jpg" alt="大阪機械団地協同組合 デッドストックツール.com" style="width:240px;height:60px;"/>
  </a>
  *}
{if !empty($bidinfoList)}
  {foreach $bidinfoList as $b}
    {if !empty($b.banner_file)}
      <a href="{$b.uri}"  target="_blank"
        onClick="ga('send', 'event', 'banner', 'bid', 'bidinfo_{$b.id}', 1, true);">
        <img src="./media/banner/{$b.banner_file}" alt="{$b.bid_name}" />
      </a>
    {/if}
  {/foreach}
{/if}
  <a href="./bid_schedule.php"  target="_blank"
    onClick="ga('send', 'event', 'banner', 'bid', 'bid_schedule', 1, true);">
    <img src="./media/banner/2018bid.png" alt="2018年度Web入札会スケジュール" />
  </a>

  <br style="clear:both;">
</div>

<div class="left_area">
  <h2><div>新着中古機械</div></h2>
  <a onclick="ga('send', 'event','toppage', 'news', 'machine', 1, true);" class="news_link" href="news.php">>> 新着中古機械一覧</a>
  <a onclick="ga('send', 'event','toppage', 'news', 'tool', 1, true);" class="news_link tool" href="news.php?b=1">>> 新着中古工具一覧</a>
  <ul class="news2_area resized">

  {foreach $newMachineList as $m}
    {include file="include/machine_news.tpl" m=$m baseKey="machine"}
  {/foreach}
    </ul>
</div>

{*
<div class="right_area">
  <h2><div>新着工具機械</div></h2>
  <a onclick="ga('send', 'event','toppage', 'news', 'tool', 1, true);" class="news_link" href="news.php?b=1">>> 新着中古工具一覧</a>
  <ul class="news2_area resized">

  {foreach $newToolList as $m}
    {include file="include/machine_news.tpl" m=$m baseKey="tool"}
  {/foreach}
    </ul>
</div>
*}

{*** 大バナー枠 ***}
<div class="premium_banner_area">
  {*
  <a href="http://www.go-dove.com/ja/event-17965/" target="_blank" class="first"
  onClick="_gaq.push(['_trackEvent', 'banner', 'half', 'GoIndustry DoveBid Japan(half)_02', 1, true]);"
  ><img class="banner" src="media/banner/ad_gdj_h_02.gif" /></a>
  *}

  {assign "pAds" array(
      array('大阪機械団地組合', 'ad_omdc.png', 'http://www.omdc.or.jp/'),
      array('大阪機械業連合会', 'ad_daikiren.png', 'http://www.zenkiren.org/index.php?%E5%A4%A7%E9%98%AA%E6%A9%9F%E6%A2%B0%E6%A5%AD%E9%80%A3%E5%90%88%E4%BC%9A'),
      array('中部機械業連合会', 'ad_chukiren.png', 'http://www.zenkiren.org/index.php?%E4%B8%AD%E9%83%A8%E6%A9%9F%E6%A2%B0%E6%A5%AD%E9%80%A3%E5%90%88%E4%BC%9A'),
      array('東京機械業連合会', 'ad_toukiren.png', 'http://www.zenkiren.org/index.php?%E6%9D%B1%E4%BA%AC%E6%A9%9F%E6%A2%B0%E6%A5%AD%E9%80%A3%E5%90%88%E4%BC%9A')
  )}
  {if (shuffle($pAds))}
    {foreach array_rand($pAds, 4) as $key}
      <a href="{$pAds[$key][2]}" target="_blank"{if $key@first} class="first"{/if}
        onClick="ga('send', 'event', 'banner', 'half', '{$pAds[$key][0]}', 1, true);"
        ><img class="banner" src="media/banner/{$pAds[$key][1]}" alt="{$pAds[0]}" /></a>
    {/foreach}
  {/if}
  <br class="clear"/>
</div>

{*
<div class="right_area">
  <h2><div>全機連事務局からのお知らせ</div></h2>
  <div class="infomations">
    {if !empty($infoList)}
      {foreach $infoList as $i}
        <div class="info">
          {if strtotime($i.created_at) > strtotime('-1week')}
            <div class="cjf_new">NEW!</div>
          {/if}
          <div class="info_date">{$i.info_date|date_format:'%Y/%m/%d'}</div>
          <div class="info_contents">{$i.contents|escape|auto_link|nl2br nofilter}</div>
        </div>
      {/foreach}
    {else}
      書きこみはありません
    {/if}
  </div>
</div>
*}

{*
<div class="right_area" style="position:relative;">
  <h2><a href="https://twitter.com/zenkiren" target="_blank">Twitter</a></h2>
{literal}
<div style="text-align:right;position:absolute;right:8px;top:12px;">
<a href="https://twitter.com/zenkiren" class="twitter-follow-button" data-show-count="false" data-lang="ja" class="news_link">@zenkirenさんをフォロー</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</div>

<div class="twitter_area">
<a class="twitter-timeline"
  width="428" data-chrome="noheader nofooter noborders" data-tweet-limit="5"
  data-dnt="true" href="https://twitter.com/zenkiren" data-widget-id="567627474855407616">@zenkirenさんのツイート</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
{/literal}
</div>
</div>
*}

<br class="clear" />
{*
{if !empty($IPLogMachineList)}
  <h2 class="same_machine_label">最近チェックした機械</h2>
  <div class="same_area">
    <div class='image_carousel'>
    <div class='carousel_products'>
    {foreach $IPLogMachineList as $sm}
      <div class="same_machine">
        <a href="machine_detail.php?m={$sm.id}" target="_blank"
          onClick="ga('send', 'event', 'log_detail', 'checked', '{$sm.id}', 1, true);"
        >
          {if !empty($sm.top_img)}
            <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
          {else}
            <img class='noimage' src='./imgs/noimage.png' alt="" />
          {/if}
          <div class="names">
            {if !empty($sm.name)} <div class="name">{$sm.name}</div>{/if}
            {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
            {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
            {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>{/if}
            {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>{/if}
            {if !empty($sm.company)}<div class="name">{$sm.company|regex_replace:'/(株式|有限|合.)会社/u':''}</div>{/if}
            {if !empty($sm.no)}<div class="name">({$sm.no})</div>{/if}
          </div>
        </a>
      </div>
    {/foreach}
    </div>
    </div>
    {if $sm@total > 6}
      <div class="scrollRight"></div><div class="scrollLeft"></div>
    {/if}
  </div>
{/if}
*}

{/block}
