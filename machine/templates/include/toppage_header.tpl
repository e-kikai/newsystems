{**
 * 共通ヘッダ部分
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/03
 *}

{literal}
  <script type="text/javascript">
  </script>
  <style>
  </style>
{/literal}

</head>

<body ontouchstart="">

  {*
<!-- ClickTale Top part -->
<script type="text/javascript">
var WRInitTime=(new Date()).getTime();
</script>
<!-- ClickTale end of Top part -->
*}

  <div class="main_container">
    <header>
      <strong class="headcopy">
        中古機械のスペシャリスト、全機連会員の中古機械在庫情報を掲載しています<br />
        登録会社数<span class="count_no">{$cCountByEntry|number_format}</span>社、
        <span class="count_no">{$mCountAll|number_format}</span>件の中古機械が登録されています
      </strong>
      <h1>
        <a href='' class='header_title'>
          <img src='imgs/logo_machinelife.png' alt="中古機械情報 マシンライフ マシンライフは、全機連が運営する中古機械情報サイトです" />
        </a>
      </h1>

      <a href="{$_conf.website_uri}" class="header_zenkiren" target="_blank">
        <img src='imgs/logo_zenkiren_02.png' alt="信頼と実績 全機連 マシンライフは全日本機械業連合会(全機連)の公式ウェブサイトです" />
      </a>

      {*** キーワード検索 ***}
      <div class="keyword">
        <form action='/search.php' method='get'
          {* onSubmit="_gaq.push(['_trackEvent', 'search', 'toppage_header', $('input.keyword_search.toppage_header').val(), 1, true]);" *}
          onSubmit="ga('send', 'event', 'search', 'toppage_header', $('input.keyword_search.toppage_header').val(), 1, true);">
          <span>中古機械キーワード検索</span>
          <input type="text" class="keyword_search toppage_header" name="k" value="" placeholder="キーワード検索" />
          <button type="submit" class="keyword_submit">検索</button>
        </form>
      </div>

      {*** textsizer ***}
      {*
    <div id="textsizer">
      <span>画面サイズ</span>
      <ul class="textresizer">
        <li><a href="#nogo" class="small-text textresizer-active" title="画面サイズ変更：標準" data-ratio="1">小</a></li>
        <li><a href="#nogo" class="medium-text" title="画面サイズ変更：×1.2" data-ratio="1.2">中</a></li>
        <li><a href="#nogo" class="large-text" title="画面サイズ変更：×1.4" data-ratio="1.4">大</a></li>
        <li><a href="#nogo" class="larger-text" title="画面サイズ変更：×1.6" data-ratio="1.6">特</a></li>
      </ul>
    </div>
    *}
    </header>

    {include file="include/header_menu.tpl"}

    {include file="include/header_ads.tpl"}
    {*** メッセージ枠 ***}
    {if isset($message)}
      <div class="message">
        {if is_array($message)}
          {foreach $message as $m}
            <div>{$m}</div>
          {/foreach}
        {else}
          <div>{$message}</div>
        {/if}
      </div>
    {/if}

    {*** エラーメッセージ枠 ***}
    {if isset($errorMes)}
      <div class="error_mes">
        {if is_array($errorMes)}
          {foreach $errorMes as $m}
            <div>{$m}</div>
          {/foreach}
        {else}
          <div>{$errorMes|escape|default:""|nl2br nofilter}</div>
        {/if}
      </div>
    {/if}

<div class="center_container">