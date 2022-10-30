{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="description" content="信頼と安心の全機連が年4回主催する中古機械・工具のWeb入札会開催中!下見期間
    {$bidOpen.preview_start_date|date_format:'%Y/%m/%d'}({B::strtoweek($bidOpen.preview_start_date)})～
    {$bidOpen.preview_end_date|date_format:'%m/%d'}({B::strtoweek($bidOpen.preview_end_date)})。
    アッと驚く、こんな値段で!!入札をするのはあなたです。是非お見逃しなく！" />

  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        $('.xl_area .xl_genre, .xl_area .region').click(function() {
          var $_self = $(this);
          var xl = $_self.data('xl');
          var $_disp = $('.xl_large_genre_area.xl_' + xl);

          if ($_disp.css('display') == 'block') {
            $_disp.slideUp('fast');
          } else {
            $('.xl_large_genre_area').hide();
            $_disp
              .css({'top': $_self.position().top + $_self.outerHeight() + 10, 'left': $_self.position().left + 16})
              .slideDown('fast');
          }
        });

        //// サムネイル画像の遅延読み込み（Lazyload） ////
        $('img.lazy').css('display', 'block').lazyload({
          effect: "fadeIn",
          threshold: 200
        });

        setTimeout(function() {
          $(window).triggerHandler('scroll');
        }, 100);

        $('#region_tab').tabs({
          activate: function(event, ui) { $(window).triggerHandler('scroll'); }
        });
      });
    </script>
    <style type="text/css">
      /*** 特大ジャンル ***/
      .xl_area {
        position: relative;
        width: 100%;
        margin-right: 6px;
        margin-bottom: 10px;
      }

      .xl_area .xl_genre,
      .xl_area .region,
      .xl_area a.all_list {
        display: inline-block;
        position: relative;
        z-index: 100;

        width: 226px;
        height: 36px;
        line-height: 36px;
        margin: 4px 3px;
        border: 1px solid #CCC;
        background: #EEE;
        text-align: center;
        cursor: pointer;
        font-size: 15px;

        text-decoration: none;
        color: #333;
      }

      .xl_area .xl_genre {
        height: 136px;
      }

      .xl_area .xl_genre img {
        display: block;
        margin: auto;
        max-width: 120px;
        max-height: 90px;
      }

      .xl_area .xl_genre:hover,
      .xl_area .region:hover,
      .xl_area a.all_list:hover {
        background: #FFFFCC;
        color: #FF6633;
        border-color: #FF9933;
      }

      .xl_area .xl_large_genre_area {
        position: absolute;
        z-index: 3000;

        top: 48px;
        left: 0;

        width: 220px;
        border: 1px solid #FF6633;
        background: #FFFFCC;
        display: none;
      }

      .xl_area .xl_large_genre_area:after {
        content: '';
        position: absolute;
        border-bottom: 10px solid #FFFF99;
        border-right: 5px solid transparent;
        border-left: 5px solid transparent;
        top: -9px;
        left: 5px;
      }

      .xl_area .xl_large_genre_area:before {
        content: '';
        position: absolute;
        border-bottom: 10px solid #FF6633;
        border-right: 5px solid transparent;
        border-left: 5px solid transparent;
        top: -11px;
        left: 5px;
      }

      .xl_area .xl_large_genre_area a {
        display: block;
        width: 200px;
        margin: 4px 12px;
        text-align: left;
        text-decoration: none;
        height: 22px;
        line-height: 22px;
        font-size: 14px;
      }

      .xl_area .xl_large_genre_area a.all_genre {
        border-bottom: 1px #FF6633 dotted;
      }

      .bid_search_comment {
        position: relative;
        font-size: 25px;
        font-weight: bold;
        color: #004675;
        text-align: center;
        width: 700px;
        margin: 0 auto 0 50px;
      }

      /*** 地域タブ ***/
      .xl_area .xl_large_genre_area a {
        color: #076AB6;
      }

      .xl_area .xl_large_genre_area a:hover {
        color: #F60;
      }

      .ui-tabs .ui-tabs-panel.tab_area {
        background: #FFF;
        padding: 0;
        height: 438px;
      }

      .ui-tabs .ui-tabs-nav {
        background: #FFF;
        border-width: 0;
        border-bottom: 1px solid #CCC;
        border-radius: 0;
      }

      .ui-tabs .ui-tabs-nav li.ui-tabs-active {
        border-color: #CCC;
      }


      a.ui-tabs-anchor:focus {
        outline: 0;
      }

      .ui-tabs .ui-tabs-nav li {
        font-size: 17px;
        font-weight: normal;
        border: 1px solid #62A21D;
        background: #62A21D;
        color: #FFF;
      }

      .ui-tabs .ui-tabs-nav li a {
        color: #FFF;
        padding: .5em .5em;
      }

      .ui-tabs .ui-tabs-nav li.ui-tabs-active {
        background: #FFF;
        color: #62A21D;
        border: 1px solid #CCC;
        border-bottom: 1px solid #FFF;
      }

      .ui-tabs .ui-tabs-nav li.ui-tabs-active a {
        color: #62A21D;
      }

      a.list_pdf {
        display: block;
        position: absolute;
        left: 730px;
        top: 0;
        width: 178px;
        height: 36px;
        line-height: 36px;
        font-size: 13px;
        font-weight: normal;
        background: #CCC;
        color: #333;
        text-align: left;
        text-indent: 36px;
        border-radius: 0.3em;
        text-decoration: none;
      }

      a.list_pdf:hover {
        background: #F60;
        color: #FFF;
      }

      a.list_pdf:hover img {
        opacity: 1;
      }

      a.list_pdf img {
        position: absolute;
        left: 2px;
        top: 2px;
      }

      .all_img {
        position: absolute;
        top: 36px;
        left: 53px;
        font-size: 34px;
        font-family: "ヒラギノ明朝 Pro W6", "Hiragino Mincho Pro", "HGS明朝E", "ＭＳ Ｐ明朝", serif;
        font-weight: bold;
        text-align: center;
        color: #333;
        width: 118px;
        border: 1px solid #CCC;
        height: 88px;
        line-height: 90px;
        background: #FFF;
        overflow: hidden;
        margin: auto;
      }

      /*** ヘッダ ***/
      .bid_door_main {
        position: relative;
        background-image: url('/imgs/bid_door.png');
        height: 206px;
      }

      .bid_door_main .bid_door_title {
        position: absolute;
        color: #FFF;
        font-size: 58px;
        font-weight: bold;
        text-shadow: 4px 4px 4px #000;
        width: 510px;
        top: 46px;
        left: 12px;
        line-height: 1.1;
      }

      .bid_door_main .bid_door_info {
        position: absolute;
        color: #FFFF00;
        font-size: 18px;
        top: 46px;
        left: 520px;
      }

      /*****/
      .door_infos {
        text-align: center;
        margin: 4px auto 16px auto;

        position: absolute;
        top: 238px;
        left: 236px;
      }

      .door_infos a.bid_help,
      .door_infos button.mylist_movie,
      .door_infos a.help_link {
        display: inline-block;
        position: static;
        margin: 0 8px;
        box-shadow: none;
        vertical-align: bottom;
      }

      h1,
      .header_preview_date {
        display: none;
      }

      h3.bid_open_title {
        position: absolute;
        top: -12px;
        width: 560px;
      }

      .bid_open {
        border: 1px dotted #147543;
        margin: 6px auto;
        padding: 3px;
        width: 555px;
        position: absolute;
        top: 15px;
        background: #FFF;
        height: 68px;
        overflow: auto;
      }

      .bid_door_main_container {
        overflow: hidden;
        height: 220px;
        margin-top: 52px;
      }

      .bid_head a.mylist_link,
      .bid_head a.mylist_link:active {
        top: 0;
      }

      .bid_head .head_search_no {
        bottom: -30px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  {include "include/bid_timer.tpl"}

  <div class="bid_door_main_container">
    <div class="bid_door_main">
      <div class="bid_door_title">{$bidOpen.title} 会場</div>
      <div class="bid_door_info">
        下見期間 : {$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.preview_start_date)}) ～
        {$bidOpen.preview_end_date|date_format:'%m月%d日'}({B::strtoweek($bidOpen.preview_end_date)})<br />
        入札締切 : {$bidOpen.user_bid_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.user_bid_date)})
        {$bidOpen.user_bid_date|date_format:'%H:%M'}
      </div>
    </div>
  </div>

  {*
{include "include/bid_announce.tpl"}
*}

  {if !empty($bidOpen.announce_list)}
    <h3 class="bid_open_title">事務局からのお知らせ</h3>
    <div class="bid_open">
      <p>{$bidOpen.announce_list|escape|auto_link|nl2br nofilter}</p>
    </div>
  {/if}

  <div class="door_infos">
    {*
    <button class="bid_help">入札方法のご依頼方法<br />解説はこちら</button>
    <button class="mylist_movie movie" data-youtubeid="PaZiV_OA7io"
      title="クリックで動画再生します">お気に入り使い方動画</button>
    *}
    <a class="bid_help" href="bid_help_01.php?o={$bidOpenId}">入札方法のご依頼方法<br />解説はこちら</a>
    <a class="help_link" href="bid_help.php?o={$bidOpenId}">入札会よくある質問</a>
  </div>

  <div class="bid_search_comment">さあ、お気に入りの中古機械を探しだしてみてください！！
    {if !empty($bidOpen.list_pdf)}
      <a class="list_pdf" href="{$_conf.media_dir}pdf/{$bidOpen.list_pdf}" target=="_blank"><img
          src="./imgs/pdficon_large.png">商品リスト印刷用PDF</a>
    {/if}
  </div>

  {*** 大ジャンル一覧 ***}

  <div class="xl_area">
    <h2>地域会場とジャンルからさがす</h2>
    <div id="region_tab">
      <ul>
        <li><a href="{$smarty.server.REQUEST_URI}#tab_all">全国 ({$count})</a></li>
        {foreach $regionList as $r}
          <li><a href="{$smarty.server.REQUEST_URI}#tab_{$r@key}">{$r.region}会場 ({$r.count})</a></li>
        {/foreach}
      </ul>

      <div id="tab_all" class="tab_area">
        <a class="xl_genre" href="bid_list.php?o={$bidOpenId}">
          すべての商品 ({$count})
          <div class="all_img">全表示</div>
        </a>

        {foreach $xlGenreList as $x}
          <div class="xl_genre xl_{$x.id}" data-xl="{$x.id}">
            {$x.xl_genre} ({$x.count})
            <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$x.top_img}" alt='' />
          </div>
          <div class="xl_large_genre_area xl_{$x.id}">
            <a href="bid_list.php?o={$bidOpenId}&x={$x.id}" class="genre all_genre">
              <span class="check_label">すべての{$x.xl_genre}</span><span class="count">({$x.count})</span>
            </a>
            {foreach $largeGenreList as $l}
              {if $l.xl_genre_id == $x.id}
                <a href="bid_list.php?o={$bidOpenId}&l={$l.id}" class="genre xl_{$l.xl_genre_id}">
                  <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
                </a>
              {/if}
            {/foreach}
          </div>
        {/foreach}

      </div>

      {foreach $regionList as $r}
        <div id="tab_{$r@key}" class="tab_area">
          <a class="xl_genre" href="bid_list.php?o={$bidOpenId}&r={$r.region}">
            すべての商品 ({$r.count})
            <div class="all_img">全表示</div>
          </a>
          {foreach $r.xl_genre_list as $x}
            <div class="xl_genre xl_{$r@key}_{$x.id}" data-xl="{$r@key}_{$x.id}">
              {$x.xl_genre} ({$x.count})
              <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$x.top_img}" alt='' />
            </div>
            <div class="xl_large_genre_area xl_{$r@key}_{$x.id}">
              <a href="bid_list.php?o={$bidOpenId}&r={$r.region}&x={$x.id}" class="genre all_genre">
                <span class="check_label">すべての{$x.xl_genre}</span><span class="count">({$x.count})</span>
              </a>
              {foreach $r.large_genre_list as $l}
                {if $l.xl_genre_id == $x.id}
                  <a href="bid_list.php?o={$bidOpenId}&r={$r.region}&l={$l.id}" class="genre xl_{$l.xl_genre_id}">
                    <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
                  </a>
                {/if}
              {/foreach}
            </div>
          {/foreach}

        </div>
      {/foreach}
    </div>

    {*
<div class="xl_area">
  <h2>出品番号でさがす</h2>
  <form method="GET" id="company_list_form" action="bid_list.php">
    <input type="hidden" name="o" value="{$bidOpenId}" />
    <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
    <button type="submit" class="company_list_submit">検索</button>
  </form>
</div>
*}

    {*** レコメンド ***}
    {if !empty($recommends)}
      <h2 class="same_machine_label">おすすめ商品</h2>
      <div class="same_area">
        <div class='image_carousel'>
          <div class='carousel_products'>
            {foreach $recommends as $sm}
              <div class="same_machine bid">
                <a href="bid_detail.php?m={$sm.id}&rec=user"
                  onClick="ga('send', 'event', 'log_bid', 'rec_user', '{$sm.id}', 1, true);">
                  {if !empty($sm.top_img)}
                    <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                  {else}
                    <img class='noimage' src='./imgs/noimage.png' alt="" />
                  {/if}
                  <div class="names">
                    {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
                    {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
                    {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>{/if}
                    {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>{/if}
                  </div>
                  <div class="min_price">{$sm.min_price|number_format}円</div>
                </a>
              </div>
            {/foreach}
          </div>
        </div>
        {if $sm@total > 6}
          <div class="scrollRight"></div>
          <div class="scrollLeft"></div>
        {/if}
      </div>
    {/if}

    {if !empty($FaviMachineList)}
      <h2 class="same_machine_label">人気商品</h2>
      <div class="same_area">
        <div class='image_carousel'>
          <div class='carousel_products'>
            {foreach $FaviMachineList as $sm}
              <div class="same_machine bid">
                <a href="bid_detail.php?m={$sm.id}&favorite=1"
                  onClick="ga('send', 'event', 'log_bid', 'favorite', '{$sm.id}', 1, true);">
                  {if !empty($sm.top_img)}
                    <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                  {else}
                    <img class='noimage' src='./imgs/noimage.png' alt="" />
                  {/if}
                  <div class="names">
                    {if !empty($sm.name)}<div class="name">{$sm.name}</div>{/if}
                    {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
                    {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
                    {if !empty($sm.year)}<div class="company">{$sm.year}年式</div>{/if}
                    {if !empty($sm.addr1)}<div class="company">{$sm.addr1}</div>{/if}
                  </div>
                  <div class="min_price">{$sm.min_price|number_format}円</div>
                </a>
              </div>
            {/foreach}
          </div>
        </div>
        {if $sm@total > 6}
          <div class="scrollRight"></div>
          <div class="scrollLeft"></div>
        {/if}
      </div>
    {/if}

    {if !empty($IPLogMachineList)}
      <h2 class="same_machine_label">最近チェックした商品</h2>
      <div class="same_area">
        <div class='image_carousel'>
          <div class='carousel_products'>
            {foreach $IPLogMachineList as $sm}
              <div class="same_machine bid">
                <a href="bid_detail.php?m={$sm.id}&check=1"
                  onClick="ga('send', 'event', 'log_bid', 'checked', '{$sm.id}', 1, true]);">
                  {if !empty($sm.top_img)}
                    <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                  {else}
                    <img class='noimage' src='./imgs/noimage.png' alt="" />
                  {/if}
                  <div class="names">
                    {if !empty($sm.name)}<div class="name">{$sm.name}</div>{/if}
                    {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
                    {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
                    {if !empty($sm.year)}<div class="company">{$sm.year}年式</div>{/if}
                    {if !empty($sm.addr1)}<div class="company">{$sm.addr1}</div>{/if}
                  </div>
                  <div class="min_price">{$sm.min_price|number_format}円</div>
                </a>
              </div>
            {/foreach}
          </div>
        </div>
        {if $sm@total > 6}
          <div class="scrollRight"></div>
          <div class="scrollLeft"></div>
        {/if}
      </div>
    {/if}

    {assign "keywords" ""}
    {include file="include/mnok_ads.tpl"}

{/block}