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
  <link href="{$_conf.site_uri}{$_conf.css_dir}bid_door.css" rel="stylesheet" type="text/css" />

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

    {*
    <a class="bid_help" href="bid_help_01.php?o={$bidOpenId}">入札方法のご依頼方法<br />解説はこちら</a>
    *}

    <a class="help_link" href="bid_help.php?o={$bidOpenId}" style="">
      <i class="fas fa-circle-question"></i> よくある質問
    </a>
  </div>

  <div>
    <a class="bid_help" href="bid_help_01.php?o={$bidOpenId}" style="">
      <i class="fas fa-circle-question"></i> 商品のさがし方
    </a>

    <a class="bid_help" href="bid_help_02.php?o={$bidOpenId}" style="">
      <i class="fas fa-circle-question"></i> 入札方法について
    </a>

    <a class="bid_terms" href="./imgs/terms_2023.pdf" style="" target="_blank">
      <i class="fas fa-file-pdf"></i> 利用規約
    </a>

    <a class="bid_terms" href="./imgs/machinelife_privacy_2023.pdf" style="" target="_blank">
      <i class="fas fa-file-pdf"></i> プライバシーポリシー
    </a>
  </div>

  {include "./include/bid_login_area.tpl"}

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
            {include file='include/bid_samecard.tpl' machine=$sm label='door_rec'}
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
            {include file='include/bid_samecard.tpl' machine=$sm label='door_favorite'}
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
            {include file='include/bid_samecard.tpl' machine=$sm label='door_checked'}
          {/foreach}
        </div>
      </div>
      {if $sm@total > 6}
        <div class="scrollRight"></div>
        <div class="scrollLeft"></div>
      {/if}
    </div>
  {/if}

  {include "./include/bid_login_area.tpl"}

  {assign "keywords" ""}
  {include file="include/mnok_ads.tpl"}

{/block}