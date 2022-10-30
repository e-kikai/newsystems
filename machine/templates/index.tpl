{extends file='include/toppage_layout.tpl'}

{block 'header'}
  <meta name="description" content="全機連会員120社以上の中古機械・工具検索を中心に、電子カタログ、Web入札会など工作機械に関する様々な情報を掲載。" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}toppage.css?20190919" rel="stylesheet" type="text/css" />
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
      });
    </script>
    <style>
    </style>
  {/literal}

  <meta name="twitter:card" content="summary" />
  <meta name="twitter:site" content="@zenkiren" />
  <meta name="twitter:title" content="マシンライフ - 全機連の中古機械・工具情報" />
  <meta name="twitter:description" content="全機連会員120社以上の中古機械・工具検索を中心に、電子カタログ、Web入札会など工作機械に関する様々な情報を掲載。" />
  <meta name="twitter:image" content="https://www.zenkiren.net/imgs/logo_machinelife.png" />
{/block}

{block 'main'}

  <div class="bg_margin"></div>
  <div class="sp_area">
    {if !empty($bidOpenList)}
      {foreach $bidOpenList as $b}
        <a class="bid_auto_banner" href="bid_{if strtotime($b.preview_start_date) >= time()}lp{else}door{/if}.php?o={$b.id}"
          target="_blank" onclick="ga('send', 'event','banner', 'sp', 'bid_{$b.id}', 1, true);">
          <div class="bid_banner_title">
            {$b.title|escape|regex_replace:'/(Web入札会|([a-zA-Z])+|([^a-zA-Z])+)/':'<span>$1</span>' nofilter}</div>
          <div class="bid_banner_info">
            下見期間 : {$b.preview_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($b.preview_start_date)}) ～
            {$b.preview_end_date|date_format:'%m月%d日'}({B::strtoweek($b.preview_end_date)})<br />
            入札締切 : {$b.user_bid_date|date_format:'%Y年%m月%d日'}({B::strtoweek($b.user_bid_date)})
            {$b.user_bid_date|date_format:'%H:%M'}
          </div>
          {if strtotime($b.preview_start_date) < time() && strtotime($b.user_bid_date) >= time()}
            <div class="bid_banner_now"><span>ただいま開催中！ Click▶</span></div>
          {/if}
          {if strtotime($b.user_bid_date) < time()}
            <div class="bid_banner_end"><span>終了致しました</span></div>
          {/if}
        </a>
      {/foreach}
    {/if}
  </div>

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
      onsubmit="ga('send', 'event', 'search', 'location', $('select.addr1').val(), 1, true);">
      <select name="k" class="addr1">
        <option value="">▼選択▼</option>
        {foreach $addr1List as $a}
          <option value="{$a.state}" {if empty($a.count)}class="empty" {/if}>{$a.state}
            {if !empty($a.count)}({$a.count}){/if}</option>
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
          <a href="{$b.uri}" target="_blank" onClick="ga('send', 'event', 'banner', 'bid', 'bidinfo_{$b.id}', 1, true);">
            <img src="{$_conf.media_dir}banner/{$b.banner_file}" alt="{$b.bid_name}" />
          </a>
        {/if}
      {/foreach}
    {/if}

    <a href="./bid_schedule.php" target="_blank" onClick="ga('send', 'event', 'banner', 'bid', 'bid_schedule', 1, true);">
      <img src="./imgs/2022bid.png" alt="2022年度Web入札会スケジュール" />
    </a>

    <a href="./help_banner.php" target="_blank" onClick="ga('send', 'event', 'banner', 'bid', 'ad_rec', 1, true);">
      <img src="./imgs/rec_02.gif" alt="広告バナー募集中" />
    </a>

    <a href="https://twitter.com/zenkiren" target="_blank"
      onClick="ga('send', 'event', 'banner', 'bid', 'twitter', 1, true);">
      <img src="./imgs/twitter.png" alt="マシンライフ公式Twitter" />
    </a>

    <br style="clear:both;">
  </div>

  <div class="left_area">
    <h2>
      <div>新着中古機械</div>
    </h2>

    <a onclick="ga('send', 'event','toppage', 'news', 'machine', 1, true);" class="news_link" href="news.php">>>
      新着中古機械一覧</a>
    <a onclick="ga('send', 'event','toppage', 'news', 'tool', 1, true);" class="news_link tool" href="news.php?b=1">>>
      新着中古工具一覧</a>
    <a onclick="ga('send', 'event','toppage', 'news', 'rss', 1, true);" class="news_link rss" href="rss.php">新着RSS</a>

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
  ><img class="banner" src="{$_conf.media_dir}banner/ad_gdj_h_02.gif" /></a>
  *}

    {assign "pAds" array(
                        array('大阪機械団地組合', 'ad_omdc.png', 'http://www.omdc.or.jp/'),
                        array('大阪機械業連合会', 'ad_daikiren.png', 'http://www.zenkiren.org/index.php?%E5%A4%A7%E9%98%AA%E6%A9%9F%E6%A2%B0%E6%A5%AD%E9%80%A3%E5%90%88%E4%BC%9A'),
                        array('中部機械業連合会', 'ad_chukiren.png', 'http://www.zenkiren.org/index.php?%E4%B8%AD%E9%83%A8%E6%A9%9F%E6%A2%B0%E6%A5%AD%E9%80%A3%E5%90%88%E4%BC%9A'),
                        array('東京機械業連合会', 'ad_toukiren.png', 'http://www.zenkiren.org/index.php?%E6%9D%B1%E4%BA%AC%E6%A9%9F%E6%A2%B0%E6%A5%AD%E9%80%A3%E5%90%88%E4%BC%9A')
                    )}
    {if (shuffle($pAds))}
      {foreach array_rand($pAds, 4) as $key}
        <a href="{$pAds[$key][2]}" target="_blank" {if $key@first} class="first" {/if}
          onClick="ga('send', 'event', 'banner', 'half', '{$pAds[$key][0]}', 1, true);"><img class="banner"
            src="{$_conf.media_dir}banner/{$pAds[$key][1]}" alt="{$pAds[0]}" /></a>
      {/foreach}
    {/if}
    <br class="clear" />
  </div>

  <br class="clear" />
{/block}