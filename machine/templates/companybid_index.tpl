{include "include/html_header.tpl"}

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

      width: 240px;
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
      width: 220px;
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

    .ui-tabs .ui-tabs-nav li {
      font-size: 17px;
      font-weight: normal;
    }

    a.ui-tabs-anchor:focus {
      outline: 0;
    }

    .ui-tabs .ui-tabs-nav li {
      border: 1px solid #62A21D;
      background: #8aac52;
      background: -webkit-gradient(linear, left top, left bottom, color-stop(1.00, #69ac52), color-stop(0.50, #62A21D), color-stop(0.50, #82AC52), color-stop(0.00, #8aac52));
      background: -webkit-linear-gradient(top, #8aac52 0%, #82AC52 50%, #62A21D 50%, #69ac52 100%);
      background: -moz-linear-gradient(top, #8aac52 0%, #82AC52 50%, #62A21D 50%, #69ac52 100%);
      background: -o-linear-gradient(top, #8aac52 0%, #82AC52 50%, #62A21D 50%, #69ac52 100%);
      background: -ms-linear-gradient(top, #8aac52 0%, #82AC52 50%, #62A21D 50%, #69ac52 100%);
      background: linear-gradient(top, #8aac52 0%, #82AC52 50%, #62A21D 50%, #69ac52 100%);

      color: #FFF;
    }

    .ui-tabs .ui-tabs-nav li a {
      color: #FFF;
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
      right: 2px;
      top: 218px;
      width: 178px;
      height: 36px;
      line-height: 38px;
      background: #EAEAEA;
      background: -webkit-gradient(linear, left top, left bottom, from(#EAEAEA), to(#C5C5C5));
      background: -moz-linear-gradient(-90deg, #EAEAEA, #C5C5C5);
      background: -o-linear-gradient(-90deg, #EAEAEA, #C5C5C5);
      background: linear-gradient(to bottom, #EAEAEA, #C5C5C5);
      filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#EAEAEA', endColorstr='#C5C5C5');
      color: #33F;
      border: 1px solid #C5C5C5;
      text-align: left;
      text-indent: 36px;
      border-radius: 0.3em;
      text-decoration: none;
      box-shadow: 1px 1px 0.2em rgba(0, 0, 0, 0.4);
    }

    a.list_pdf:hover {
      background: #EAEAEA;
      background: -webkit-gradient(linear, left top, left bottom, from(#C5C5C5), to(#EAEAEA));
      background: -moz-linear-gradient(-90deg, #C5C5C5, #EAEAEA);
      background: -o-linear-gradient(-90deg, #C5C5C5, #EAEAEA);
      background: linear-gradient(to bottom, #C5C5C5, #EAEAEA);
      filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#C5C5C5', endColorstr='#EAEAEA');
      color: #F60;
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
      width: 500px;
      top: 46px;
      left: 18px;
      line-height: 1.1;
    }

    .bid_door_main .bid_door_info {
      position: absolute;
      color: #FFFF00;
      font-size: 18px;
      top: 46px;
      left: 520px;
    }

    /*** companybid ***/
    .companybid-title {
      font-weight: bold;
      font-size: 33px;
      margin-bottom: 33px;
      text-align: center;
    }

    .companybid-strong {
      font-size: 19px;
      margin: 8px 0 4px 0;
    }

    .companybid-img {
      display: block;
      margin: 4px auto;
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

      <div class="companybid">

        <div class="companybid-title">{$companybidOpen.title}</div>

        {if !empty($companybidOpen.img_file)}
          <img class="companybid-img" src="{$_conf.media_dir}companybid/{$companybidOpen.img_file}" />
        {/if}

        <h2>機械展示会場</h2>
        {foreach $companybidOpen.preview_locations as $lo}
          <div class="companybid-strong">
            {if count($companybidOpen.preview_locations) > 1}
              第{$lo@key+1}会場
            {/if}
            {$lo.location}
          </div>
          {$lo.address}
          <a class="accessmap"
            href="https://maps.google.co.jp/maps?f=q&amp;q={$lo.address|escape:"url"}&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
            target="_blank">MAPはこちら</a><br />
          <div class="companybid-comment">
            {$lo.comment|escape|auto_link|nl2br nofilter}
          </div>
        {/foreach}

        <h2>下見期間</h2>
        <div class="companybid-strong">
          {$companybidOpen.preview_start_date|date_format:'%Y年%m月%d日'}
          ({B::strtoweek($companybidOpen.preview_start_date)}) ～
          {$companybidOpen.preview_end_date|date_format:'%m月%d日'} ({B::strtoweek($companybidOpen.preview_end_date)})
        </div>
        <div class="companybid-comment">
          {$companybidOpen.preview_date_comment|escape|auto_link|nl2br nofilter}
        </div>

        <h2>入札日時</h2>
        <div class="companybid-strong">
          {$companybidOpen.bid_date|date_format:'%Y年%m月%d日'} ({B::strtoweek($companybidOpen.bid_date)})
          {$companybidOpen.bid_date|date_format:'%H:%M'}
        </div>

        <div class="companybid-comment">
          {$companybidOpen.bid_date_comment|escape|auto_link|nl2br nofilter}
        </div>

        <h2>入札会場</h2>
        <div class="companybid-strong">{$companybidOpen.bid_location}</div>
        {if !empty($companybidOpen.bid_address)}
          {$companybidOpen.bid_address}
          <a class="accessmap"
            href="https://maps.google.co.jp/maps?f=q&amp;q={$companybidOpen.bid_address|escape:"url"}+({$companybidOpen.bid_location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
            target="_blank">MAPはこちら</a>
        {/if}

        {if !empty($companybidOpen.pdf_files)}
          <div class="pdf-area">
            {foreach $companybidOpen.pdf_files as $p}
              <div class="companybid-strong">
                <a class="pdf_download" href="{$_conf.media_dir}companybid/{$p}" target="_blank">{$p@key}</a>
              </div>
            {/foreach}
          </div>
        {/if}

        <div class="companybid-comment">
          {$companybidOpen.comment|escape|auto_link|nl2br|regex_replace:"/(\(\((.*)\)\))/":'<span class="companybid-strong">$2</span>'|regex_replace:"/(\{\{(.*)\}\})/":'$2
          <a class="accessmap"
            href="https://maps.google.co.jp/maps?f=q&amp;q=$2&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
            target="_blank">MAPはこちら</a>' nofilter}
        </div>
      </div>

      {if $companybidOpen.companybid_open_id != 10}
        <div class="xl_area">
          <h2>下見会場とジャンルからさがす</h2>
          <div id="region_tab">
            <ul>
              <li><a href="{$smarty.server.REQUEST_URI}#tab_all">すべて ({$count})</a></li>
              {foreach $locationList as $lo}
                <li><a href="{$smarty.server.REQUEST_URI}#tab_{$lo@key}">{$lo.location} ({$lo.count})</a></li>
              {/foreach}
            </ul>

            <div id="tab_all" class="tab_area">
              {foreach $xlGenreList as $x}
                <div class="xl_genre xl_{$x.xl_genre_id}" data-xl="{$x.xl_genre_id}">
                  {$x.xl_genre} ({$x.count})
                  <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}companybid/{$x.imgs[0]}" alt='' />
                </div>
                <div class="xl_large_genre_area xl_{$x.xl_genre_id}">
                  <a href="companybid_list.php?o={$companybidOpenId}&x={$x.xl_genre_id}" class="genre all_genre">
                    <span class="check_label">すべての{$x.xl_genre}</span><span class="count">({$x.count})</span>
                  </a>
                  {foreach $largeGenreList as $l}
                    {if $l.xl_genre_id == $x.xl_genre_id}
                      <a href="companybid_list.php?o={$companybidOpenId}&l={$l.large_genre_id}"
                        class="genre xl_{$l.xl_genre_id}">
                        <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
                      </a>
                    {/if}
                  {/foreach}
                </div>
              {/foreach}

              <a class="xl_genre" href="companybid_list.php?o={$companybidOpenId}">
                すべての商品 ({$count})
                <div class="all_img">全表示</div>
              </a>
            </div>

            {foreach $locationList as $lo}
              <div id="tab_{$lo@key}" class="tab_area">
                {foreach $lo.xl_genre_list as $x}
                  <div class="xl_genre xl_{$lo@key}_{$x.xl_genre_id}" data-xl="{$lo@key}_{$x.xl_genre_id}">
                    {$x.xl_genre} ({$x.count})
                    <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}companybid/{$x.imgs[0]}" alt='' />
                  </div>
                  <div class="xl_large_genre_area xl_{$lo@key}_{$x.xl_genre_id}">
                    <a href="companybid_list.php?o={$companybidOpenId}&lo={$lo.location}&x={$x.xl_genre_id}"
                      class="genre all_genre">
                      <span class="check_label">すべての{$x.xl_genre}</span><span class="count">({$x.count})</span>
                    </a>
                    {foreach $lo.large_genre_list as $l}
                      {if $l.xl_genre_id == $x.xl_genre_id}
                        <a href="companybid_list.php?o={$companybidOpenId}&lo={$lo.location}&l={$l.large_genre_id}"
                          class="genre xl_{$l.xl_genre_id}">
                          <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
                        </a>
                      {/if}
                    {/foreach}
                  </div>
                {/foreach}

                <a class="xl_genre" href="companybid_list.php?o={$companybidOpenId}&lo={$lo.location}">
                  すべての商品 ({$lo.count})
                  <div class="all_img">全表示</div>
                </a>
              </div>
            {/foreach}
          </div>
        </div>

        <div class="xl_area">
          <h2>出品番号でさがす</h2>
          <form method="GET" id="company_list_form" action="companybid_list.php">
            <input type="hidden" name="o" value="{$companybidOpenId}" />
            <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
            <button type="submit" class="company_list_submit">検索</button>
          </form>
        </div>
      {/if}

      <a title="Web Analytics" href="https://clicky.com/100784739"><img alt="Web Analytics"
          src="//static.getclicky.com/media/links/badge.gif" border="0" /></a>
      <script src="//static.getclicky.com/js" type="text/javascript"></script>
      <script type="text/javascript">
        try { clicky.init(100784739); } catch (e) {}
      </script>
      <noscript>
        <p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100784739ns.gif" /></p>
      </noscript>

      <footer>
        <p class="copyright">
          Copyright &copy; {$smarty.now|date_format:"%Y"}
          <a href="{$_conf.website_uri}" target="_blank">{$_conf.copyright}</a>
          All Rights Reserved.
        </p>
      </footer>
</body>

</html>