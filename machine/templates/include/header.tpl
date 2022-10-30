{**
 * 共通ヘッダ部分
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/03
 *}
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}print.js"></script>
{literal}
  <style>
  </style>
{/literal}

</head>

<body class="mini" ontouchstart="">

  {*
<!-- ClickTale Top part -->
<script type="text/javascript">
var WRInitTime=(new Date()).getTime();
</script>
<!-- ClickTale end of Top part -->
*}

  <div class="main_container">
    <header class="mini">
      <a href="" class='header_title'
        {* onClick="_gaq.push(['_trackEvent', 'pankuzu', 'toppage', 'heder_logo', 1, true]);" *}
        onClick="ga('send', 'event', 'pankuzu', 'toppage', 'heder_logo', 1, true);">
        <img src='imgs/logo_machinelife_mini.png' alt="中古機械情報 マシンライフ 中古旋盤,中古フライス等の中古機械情報をご提供" title="全機連 中古機械情報" />
      </a>

      {*** キーワード検索 ***}
      {if !preg_match('/(system|bid|contact\.)/', $smarty.server.REQUEST_URI)}
        <div class="keyword">
          <form action='/search.php' method='get'
            {* onSubmit="_gaq.push(['_trackEvent', 'search', 'header', $('input.keyword_search.header').val(), 1, true]);" *}
            onSubmit="ga('send', 'event', 'search', 'header', $('input.keyword_search.header').val(), 1, true);">
            <span>中古機械キーワード検索</span>
            <input type="text" class="keyword_search header" name="k" value="{$k}" placeholder="キーワード検索" />
            <button type="submit" class="keyword_submit">検索</button>
          </form>
        </div>
      {/if}
    </header>

    {include file="include/header_menu.tpl"}

    {*** ads ***}
    {if !preg_match('/(system|bid)/', $smarty.server.REQUEST_URI)}
      {include file="include/header_ads.tpl"}
    {/if}

    {if $smarty.now < strtotime('2013/07/18 12:00') && !preg_match('/bid_/', $smarty.server.REQUEST_URI)}
      <img class="sp_bid_banner" src="imgs/sp_bid_banner.gif" usemap="#sp_bid_banner" />
      <map name="sp_bid_banner">
        <area shape="rect" coords="430,0,690,48" href="bid201307.html?r=i" target="_blank" alt="マシンライフ第1回Web入札会">
        <area shape="rect" coords="690,0,960,48" href="bid_list.php?o=1" alt="マシンライフ第1回Web入札会:商品リスト">
      </map>
    {/if}

    {if $smarty.now < strtotime('2013/12/05 23:59:59') && !preg_match('/(system|contact.php|bid)/', $smarty.server.REQUEST_URI)}
      <img class="banner_half" src="imgs/mix_banner_half_02_03.jpg" usemap="#mix_banner_half_02" />
      <map name="mix_banner_half_02">
        <area shape="rect" coords="0,0,320,75" href="http://www.omdc.or.jp/?page_id=434" target="_blank">
        <area shape="rect" coords="320,0,640,75" href="bid_door.php?o=2">
        <area shape="rect" coords="640,0,960,75" href="http://www.umc.gr.jp/" target="_blank">
      </map>
    {/if}


    {*** パンくず ***}
    {if !isset($pankuzu) || $pankuzu !== false}
      <div class="pankuzu">
        <span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">
          <a href="./" {* onClick="_gaq.push(['_trackEvent', 'pankuzu', 'toppage', 'pankuzu', 1, true]);" *}
            onClick="ga('send', 'event', 'pankuzu', 'toppage', 'pankuzu', 1, true);" itemprop="url">
            <span itemprop="title">{$_conf.site_name}</span>
          </a>
        </span> &gt;

        {if !empty($pankuzu)}
          {foreach $pankuzu as $k => $p}
            <span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">
              <a href="{$k}" {* onClick="_gaq.push(['_trackEvent', 'pankuzu', 'other', '{$k}', 1, true]);" *}
                onClick="ga('send', 'event', 'pankuzu', 'other', '{$k}', 1, true);" itemprop="url">
                <span itemprop="title">{$p}</span>
              </a>
            </span>
            &gt;
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

    {*** メッセージ枠 ***}
    {if !empty($message)}
      <div class="message">
        {if is_array($message)}
          {foreach $message as $m}
            <div>{$m|replace:"#topppage":""|escape|default:""|nl2br nofilter}</div>
          {/foreach}
        {else}
          <div>{$message|replace:"#topppage":""|escape|default:""|nl2br nofilter}</div>
          {if preg_match('/#topppage/', $message)}
            <a href="./" class="mes_link"
              {* onClick="_gaq.push(['_trackEvent', 'mes_link', 'message', 'topppage', 1, true]);" *}
              onClick="ga('send', 'event', 'mes_link', 'message', 'topppage', 1, true);">{$_conf.site_name}</a>
          {/if}
        {/if}
      </div>
    {/if}

    {*** エラーメッセージ枠 ***}
    {if !empty($errorMes)}
      <div class="error_mes">
        {if is_array($errorMes)}
          {foreach $errorMes as $m}
            <div>{$m|replace:"#topppage":""|escape|default:""|nl2br nofilter}</div>
          {/foreach}
        {else}
          <div>{$errorMes|replace:"#topppage":""|escape|default:""|nl2br nofilter}</div>
          {if preg_match('/#topppage/', $errorMes)}
            <a href="./" class="mes_link"
              {* onClick="_gaq.push(['_trackEvent', 'mes_link', 'error', 'topppage', 1, true]);" *}
              onClick="ga('send', 'event', 'mes_link', 'error', 'topppage', 1, true]);">{$_conf.site_name}</a>
          {/if}
        {/if}
      </div>
    {/if}

<div class="center_container">