{**
 * 共通ヘッダ部分
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2011/10/03
 *}

 {*
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}print.js"></script>
*}
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

<div class="container-fluid">

  <header class="row">
    <a href="./" class='ps-4 pt-2 col-8 col-md-6'>
      <img src="./imgs/daihou_logo_02.png" class="header_logo" alt="{$company.company}" />
    </a>

    <div class="d-none d-md-block col-4 pt-2 text-end">
      <div class="header_contact_label">お問い合わせ</div>
      <div class="header_contact_tel"><i class="fas fa-phone-alt"></i>{$company.contact_tel}</div>
      <div class="header_contact_open">(受付時間 : 9:00 〜 17:00)</div>
    </div>
    <div class='d-none d-md-block col-2'>
      <a href="https://works.do/R/ti/p/sakai.takeapersonforgranted@daihou" target="_blank"  style="width:70%;display:block;margin:auto;">
        <img src="./imgs/line_01.jpeg" class="" style="width:100%;" alt="LINEWOKS" />
      </a>
    </div>
    <!-- ハンバーガーメニュー -->

    {*
    <div class="col-4 d-md-none pe-3 pt-3">
      <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#nav-bar" aria-controls="nav-bar" aria-expanded="false" aria-label="Toggle navigation">
        <i class="fas fa-bars"></i>
      </button>
    </div>
    *}
    <div class="col-4 d-md-none fs-2 d-flex align-items-center justify-content-center navbar-toggler" data-bs-toggle="collapse" data-bs-target="#nav-bar" aria-controls="nav-bar" aria-expanded="false" aria-label="Toggle navigation">
      <i class="fas fa-bars"></i>
    </div>
  </header>

  <nav class="navbar navbar-expand-sm pt-0">
    <div class="collapse navbar-collapse " id="nav-bar">
      <ul class="navbar-nav  header-menu ">
        <li class="nav-item"><a class="nav-link" href="./">
          <i class="fas fa-home"></i>TOP
        </a></li>
        <li class="nav-item"><a class="nav-link"  href="./machines.php">
          <i class="fas fa-cogs"></i>在庫機械一覧
        </a></li>
        <li class="nav-item"><a class="nav-link" href="./company.php">
          <i class="fas fa-building"></i>会社情報
        </a></li>
        <li class="nav-item"><a class="nav-link"  href="./access.php">
          <i class="fas fa-map-marked-alt"></i>アクセス
        </a></li>
        <li class="nav-item"><a class="nav-link"  href="./contact.php">
          <i class="fas fa-paper-plane"></i>お問い合わせ
        </a></li>
      </ul>
    </div>
  </nav>


  {*** パンくず ***}
  {*
  {if !isset($pankuzu) || $pankuzu !== false}
    <div class="pankuzu">
      <span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">
        <a href="./"
          onClick="ga('send', 'event', 'pankuzu', 'toppage', 'pankuzu', 1, true);"
          itemprop="url">
          <span itemprop="title">{$_conf.site_name}</span>
        </a>
      </span> &gt;

      {if !empty($pankuzu)}
        {foreach $pankuzu as $k => $p}
          <span itemscope itemtype="http://data-vocabulary.org/Breadcrumb">
            <a href="{$k}"
              onClick="ga('send', 'event', 'pankuzu', 'other', '{$k}', 1, true);"
              itemprop="url">
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
*}
  {*** メッセージ枠 ***}
{*
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
            onClick="ga('send', 'event', 'mes_link', 'message', 'topppage', 1, true);"
            >{$_conf.site_name}</a>
        {/if}
      {/if}
    </div>
  {/if}
*}
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
            {*
            onClick="ga('send', 'event', 'mes_link', 'error', 'topppage', 1, true]);"
            *}
            >{$company.contact_tel}</a>
        {/if}
      {/if}
    </div>
  {/if}

  {if !empty($pageTitle) && empty($hideTitle)}
    <h1 class="pagetitle">
      <div class="title_content">{$pageTitle}</div>
    </h1>
  {/if}

  <div class="center_container">
