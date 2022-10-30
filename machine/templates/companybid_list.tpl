{include "include/html_header.tpl"}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
  {literal}
    $(function() {
      //// サムネイル画像の遅延読み込み（Lazyload） ////
      $('img.lazy').css('display', 'block').lazyload({
        effect: "fadeIn",
        threshold: 200
      });

      $('select.order').change(function() { $('#sort_form').submit(); });

      setTimeout(function() {
        $(window).triggerHandler('scroll');
      }, 100);
    });
  </script>
  <style type="text/css">
    .search form {
      display: inline-block;
      margin-right: 32px;
    }

    /*** product_line ***/
    div.machine_label {
      position: relative;
      width: 100%;
      height: 30px;
      line-height: 30px;
      margin: 1px 0;
      background: #E3E3E3;
    }

    div.machine_label div {
      position: absolute;
      height: 30px;
      line-height: 30px;
      border-right: 1px dotted #666;
      text-align: center;
    }

    div.machine_label .id {
      left: 122px;
      width: 55px;
      border-left: 1px dotted #666;
    }

    div.machine_label .name {
      left: 177px;
      width: 387px;
    }

    div.machine_label .year {
      left: 564px;
      width: 72px;
    }

    div.machine_label .location {
      left: 636px;
      width: 71px;
    }

    div.machine_label .company {
      left: 707px;
      width: 257px;
      border: 0;
    }

    /*** 入札出品商品ライン ***/
    div.product_line {
      width: 100%;
      height: 92px;
      float: none;
      position: relative;
      margin: 0;
      padding: 0;
      display: block;
      border-bottom: 1px dotted #666;
      padding-bottom: 2px;
      margin-bottom: 2px;
    }

    div.product_line:nth-child(odd) {
      background: #EFE;
    }

    div.product_line .img_area {
      display: block;
      position: absolute;
      vertical-align: top;
      width: 120px;
      height: 90px;
      margin: 1px 0;
      left: 0;
      top: 0;
      background: #EEE;
    }

    div.product_line:nth-child(odd) .img_area {
      background: #BBB;
    }

    div.product_line .img_area img {
      margin: auto;
    }

    div.product_line .info_area {
      position: absolute;
      background: #E3E3E3;
      width: 840px;
      height: 30px;
      line-height: 30px;
      top: 1px;
      left: 121px;
      font-size: 16px;
      margin: 0;
      text-indent: 8px;
    }

    div.product_line a.bid {
      display: block;
      position: absolute;
      left: 250px;
      top: 6px;
      max-width: 450px;
      height: 25px;
      line-height: 25px;
      font-size: 16px;
      margin: 0;
    }

    div.product_line a {
      text-decoration: none;
    }

    .product_line a.contact {
      display: block;
      position: absolute;
      right: 10px;
      top: 58px;
      width: 120px;
    }

    .product_line a.contact:active {
      top: 59px;
    }

    .product_line a.companybid_detail {
      text-decoration: none;
      text-align: center;
      background: #3D4EC0;
      background: -webkit-gradient(linear, left top, left bottom, from(#7F93DC), to(#3D4EC0));
      background: -moz-linear-gradient(-90deg, #7F93DC, #3D4EC0);
      background: -o-linear-gradient(-90deg, #7F93DC, #3D4EC0);
      background: linear-gradient(to bottom, #7F93DC, #3D4EC0);
      filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#7F93DC', endColorstr='#3D4EC0');
      color: #FFF;
      font-weight: normal;
      padding: 0;
      height: 23px;
      line-height: 23px;
      border: 1px solid #3D4EC0;
      text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.2);
      box-shadow: 1px 1px 0.2em rgba(0, 0, 0, 0.4);
      border-radius: 0.3em;

      display: block;
      position: absolute;
      right: 140px;
      top: 58px;
      width: 120px;
    }

    .product_line a.detail:active {
      top: 59px;
    }

    .product_line .company {
      display: block;
      position: absolute;
      left: 280px;
      top: 35px;
      width: auto;
      text-align: left;
      height: 25px;
      line-height: 25px;
    }

    .product_line .region {
      display: block;
      position: absolute;
      left: 210px;
      top: 35px;
      width: 54px;
      text-align: left;
      height: 25px;
      line-height: 25px;
    }

    div.product_line .spec {
      display: block;
      position: absolute;
      top: 60px;
      left: 130px;
      width: 570px;
      height: 25px;
      line-height: 25px;
      color: #666;
      overflow: hidden;
    }

    div.product_line .price_label {
      display: block;
      position: absolute;
      top: 18px;
      right: 160px;
      width: 100px;
      height: 19px;
      line-height: 19px;
      color: #FFF;
      background: #E81F18;
      text-align: center;
      border-radius: 12px;
      font-size: 11px;
    }

    div.product_line .min_price {
      color: #E81F18;
      display: block;
      position: absolute;
      top: 15px;
      right: 10px;
      width: 140px;
      height: 25px;
      line-height: 25px;
      text-align: right;
      font-size: 19px;
      font-weight: normal;
    }

    div.product_line .year {
      display: block;
      position: absolute;
      left: 130px;
      top: 35px;
      width: 64px;
      text-align: left;
      height: 25px;
      line-height: 25px;
    }

    div.product_line .id {
      display: block;
      position: absolute;
      top: 6px;
      left: 130px;
      width: 120px;
      height: 25px;
      line-height: 25px;
      font-size: 16px;
    }

    /*** 並び替え枠 ***/
    div.search {
      border-radius: 4px;
      border: 1px solid #006600;
      padding: 12px 20px;
      margin: 16px 0;
      width: auto;
      font-size: 15px;
    }

    div.search a.order,
    div.search .order_selected {
      display: inline-block;
      margin: 0 4px;
    }

    div.search .order_selected {
      font-weight: bold;
    }

    /******************/
    div.product_line {
      width: 100%;
      height: 182px;
    }

    div.product_line:nth-child(odd) {
      background: #FFF;
    }

    div.product_line .img_area {
      width: 240px;
      height: 180px;
      margin: 1px 0;
      left: 0;
      top: 0;
    }

    div.product_line .img_area img {
      max-width: 240px;
      max-height: 180px;
    }

    div.product_line .id {
      top: 10px;
      left: 260px;
      width: 300px;
      font-size: 20px;
    }

    div.product_line a.bid {
      left: 260px;
      top: 40px;
      font-size: 20px;
      max-width: 600px;
    }

    div.product_line .min_price {
      color: #333;
      top: 22px;
      right: 20px;
      width: 200px;
      text-align: right;
      font-size: 25px;
      font-weight: bold;
    }

    div.product_line .spec {
      top: 70px;
      left: 260px;
      width: 576px;
      height: 70px;
      font-size: 20px;
      color: #333;
    }

    div.product_line .year {
      left: 260px;
      top: auto;
      bottom: 10px;
      width: 160px;
      font-size: 20px;
    }

    div.product_line .region {
      left: 410px;
      top: auto;
      bottom: 10px;
      width: 600px;
      font-size: 20px;
    }

    .product_line a.companybid_detail_02 {
      display: block;
      position: absolute;
      right: 20px;
      top: auto;
      bottom: 40px;
      width: auto;
      font-size: 20px;
      text-decoration: underline;
    }

    .imgs_num {
      display: block;
      position: absolute;
      bottom: 3px;
      left: 0;
      background: rgba(0, 0, 0, 0.6);
      color: #FFF;
      width: 72px;
      text-align: center;
      height: 23px;
      line-height: 23px;
    }

    /*** マイリスト ***/
    button.mylist,
    button.delete_mylist {
      font-size: 15px;
      font-weight: normal;
      width: 130px;
      margin: auto;

      display: block;
      position: absolute;
      top: 72px;
      right: 20px;

      width: 100px;
      height: 48px;
      padding: 0;
      vertical-align: middle;
      line-height: 1.3;
    }

    button.mylist {
      color: #EA570F;
      background: #FFF;
      background: #C5C5C5;
      background: -webkit-gradient(linear, left top, left bottom, from(#EAEAEA), to(#C5C5C5));
      background: -moz-linear-gradient(-90deg, #EAEAEA, #C5C5C5);
      background: -o-linear-gradient(-90deg, #EAEAEA, #C5C5C5);
      background: linear-gradient(to bottom, #EAEAEA, #C5C5C5);
      filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#EAEAEA', endColorstr='#C5C5C5');
      border: 1px solid #C5C5C5;
    }

    button.mylist:hover {
      background: #EAEAEA;
      background: -webkit-gradient(linear, left top, left bottom, from(#C5C5C5), to(#EAEAEA));
      background: -moz-linear-gradient(-90deg, #C5C5C5, #EAEAEA);
      background: -o-linear-gradient(-90deg, #C5C5C5, #EAEAEA);
      background: linear-gradient(to bottom, #C5C5C5, #EAEAEA);
      filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#C5C5C5', endColorstr='#EAEAEA');
    }

    button.delete_mylist:active,
    button.mylist:active {
      box-shadow: none;
      top: 73px;
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
          {$companybidOpen.preview_start_date|date_format:'%Y年%m月%d日'}
          ({B::strtoweek($companybidOpen.preview_start_date)})
          ～
          {$companybidOpen.preview_end_date|date_format:'%m月%d日'} ({B::strtoweek($companybidOpen.preview_end_date)})
        </div>
        {$companybidOpen.preview_date_comment}

        <div class="companybid-strong">
          入札日時 :
          {$companybidOpen.bid_date|date_format:'%Y年%m月%d日'}
          ({B::strtoweek($companybidOpen.bid_date)})
          {$companybidOpen.bid_date|date_format:'%H:%M'}
        </div>
        {$companybidOpen.bid_date_comment}

        <div class="companybid-strong">入札会場 : {$companybidOpen.bid_location}</div>
        {if !empty($companybidOpen.bid_address)}
          {$companybidOpen.bid_address}
          <a class="accessmap"
            href="https://maps.google.co.jp/maps?f=q&amp;q={$companybidOpen.bid_address|escape:"url"}+({$companybidOpen.bid_location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
            target="_blank">MAPはこちら</a>
        {/if}
      </div>

      {*
<div class="search">
  並び替え:
  {foreach ['name' => 'ジャンル・機械名', 'list_no' => '出品番号', 'model' => '型式',
  'year_desc' => '年式:新しい順', 'year' => '年式:古い順', 'location' => '都道府県',
  'min_price' => '最低入札金額:安い順', 'min_price_desc' => '最低入札金額:高い順'] as $key => $o}
    {if $key == $q.order || ($key == 'name' && empty($q.order))}
      <span class="order_selected">{$o}</span>
    {else}
      <a class="order" href="bid_list.php?o={$bidOpenId}{$siteUrl}&order={$key}">{$o}</a>
    {/if}
  {/foreach}
</div>
*}

      {if empty($companybidMachineList)}
        <div class="error_mes">条件に合う商品はありません</div>
      {/if}

      {*** ページャ ***}
      {include file="include/pager.tpl"}

      {foreach $companybidMachineList as $m}
        <div class="product_line">
          <div class="img_area">
            <a href="companybid_detail.php?m={$m.companybid_machine_id}">
              {if !empty($m.imgs)}
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}companybid/{$m.imgs[0]}" alt='' />
                <noscript><img src="{$_conf.media_dir}companybid/{$m.imgs[0]}" alt='' /></noscript>
              {/if}
            </a>
          </div>

          <a class="bid" href="companybid_detail.php?m={$m.companybid_machine_id}">
            {($m.name|cat:" "|cat:$m.maker|cat:" "|cat:$m.model)|mb_strimwidth :0:60:"..."}
          </a>

          <div class="id">出品番号 : {$m.list_no}</div>

          {if !empty($m.imgs) && count($m.imgs) > 1}
            <div class="imgs_num">{count($m.imgs)}photos</div>
          {/if}

          {*** 最低入札金額 ***}
          {*
    <div class="price_label">最低入札金額</div>
    *}
          <div class="min_price">{$m.min_price|number_format}円</div>

          <div class="spec">
            {$m.spec|escape|mb_strimwidth:0:200:"..."|regex_replace:"/alert\((.*)\)/":'<span style="color:red;">$1</span>' nofilter}
          </div>

          <div class="year">{if $m.year}年式 {$m.year}{/if}</div>

          <div class="region">{$m.location}</div>

          <a class="companybid_detail_02" href="companybid_detail.php?m={$m.companybid_machine_id}"
            target="_blank">商品詳細ページ</a>
        </div>
      {/foreach}

      {*** ページャ ***}
      {include file="include/pager.tpl"}

    </div>

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