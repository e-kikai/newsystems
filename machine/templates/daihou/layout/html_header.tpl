{**
 * 共通HTMLヘッダ部分
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 *}
<html lang='ja'>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  {*
  <meta name="robots" content="noindex, nofollow" />
  *}

  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="no-cache">
  <meta http-equiv="Expires" content="0">

  <meta name="viewport" content="width=device-width, initial-scale=1">

  <meta name="theme-color" content="rgb(0,60,100)">
  {if !empty($pageDescription)}
    <meta name="description" content="{$pageDescription}" />
  {/if}

  {*
  <base href="{$_conf.site_uri}/system/playground/daihou/" />
  <base href="https://test-daihou.zenkiren.net" />
  *}
  <base href="https://www.daihou.co.jp" />
  {*
  <title>{if !empty($pageTitle)}{$pageTitle} - {$_conf.site_name}{else}{$_conf.site_name} - 信頼と安心の中古機械情報{/if}
  </title>
  *}
  <title>
    {if !empty($pageTitle)}
      {$pageTitle}｜大宝機械株式会社
    {else}
      大宝機械株式会社 - お客様のもの創りをサポートする機械商社
    {/if}
  </title>

{* for IE8－ IE9.js *}
<!--[if lt IE 9]>
  <script src="{$_conf.libjs_uri}/IE/ie_speedup.js"></script>
  <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js"></script>
<![endif]-->

{* for IE6－PNGアルファチャンネル *}
{*
<!--[if lt IE 7]>
  <script src="http://ie7-js.googlecode.com/svn/trunk/lib/ie7-squish.js"></script>
  <script src="{$_conf.libjs_uri}/IE/DD_belatedPNG.js"></script>
  {literal}
    <script type="text/javascript">DD_belatedPNG.fix('img, .description');</script>
  {/literal}
<![endif]-->
*}

{* for IE6,7 警告 *}
{*
<!--[if lte IE 7]>
  <script src="/libjs/ie6/warning.js"></script>
  {literal}
    <script>window.onload=function(){e("/libjs/ie6/")}</script>
  {/literal}
<![endif]-->
*}

{* common Javascript *}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.js"></script>
{*
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.lazyload.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/modernizr.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/mb_convert_kana.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
*}

{*
<script type="text/javascript" src="{$_conf.libjs_uri}/cjf.js?201811231"></script>
*}

{* jquery UI *}
{*
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
<link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
*}

{*
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.mapbox.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jcarousel.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.fancybox.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.ah-placeholder.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.textresizer.js"></script>
*}

{* StyleSeet *}
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

<script src="https://kit.fontawesome.com/083f5541f5.js" crossorigin="anonymous"></script>

{*
<link href="{$_conf.libjs_uri}/css/html5reset.css" rel="stylesheet" type="text/css" />
*}

{*
<link href="{$_conf.libjs_uri}/css/common.css?2021051007" rel="stylesheet" type="text/css" />
*}

{*
<link href="{$_conf.site_uri}/system/playground/daihou/css/daihou.css?{date("YmdHis")}" rel="stylesheet" type="text/css" />
*}
<link href="./css/daihou.css?{date("YmdHis")}" rel="stylesheet" type="text/css" />

{* 印刷用CSS *}
<link href="{$_conf.libjs_uri}/css/print.css?20180717" rel="stylesheet" type="text/css" media="print" />

{*
<link href="{$_conf.libjs_uri}/css/cjf.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.libjs_uri}/css/tango/skin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.libjs_uri}/css/mycarousel.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.libjs_uri}/jquery.fancybox.css" rel="stylesheet" type="text/css" />
*}

{* Google Analytics *}

{* ABテスト用にお問い合せのみAlalyticsコードをハードコーディング *}
{*
{if !preg_match('/contact.php/', $smarty.server.REQUEST_URI)}
*}

{*
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}google_analytics.js"></script>
*}

{*** favicons ***}
<meta name="msapplication-square70x70logo" content="./favicons/site-tile-70x70.png">
<meta name="msapplication-square150x150logo" content="./favicons/site-tile-150x150.png">
<meta name="msapplication-wide310x150logo" content="./favicons/site-tile-310x150.png">
<meta name="msapplication-square310x310logo" content="./favicons/site-tile-310x310.png">
<meta name="msapplication-TileColor" content="#0078d7">
<link rel="shortcut icon" type="image/vnd.microsoft.icon" href="./favicons/favicon.ico">
<link rel="icon" type="image/vnd.microsoft.icon" href="./favicons/favicon.ico">
<link rel="apple-touch-icon" sizes="57x57" href="./favicons/apple-touch-icon-57x57.png">
<link rel="apple-touch-icon" sizes="60x60" href="./favicons/apple-touch-icon-60x60.png">
<link rel="apple-touch-icon" sizes="72x72" href="./favicons/apple-touch-icon-72x72.png">
<link rel="apple-touch-icon" sizes="76x76" href="./favicons/apple-touch-icon-76x76.png">
<link rel="apple-touch-icon" sizes="114x114" href="./favicons/apple-touch-icon-114x114.png">
<link rel="apple-touch-icon" sizes="120x120" href="/./faviconsapple-touch-icon-120x120.png">
<link rel="apple-touch-icon" sizes="144x144" href="./favicons/apple-touch-icon-144x144.png">
<link rel="apple-touch-icon" sizes="152x152" href="./favicons/apple-touch-icon-152x152.png">
<link rel="apple-touch-icon" sizes="180x180" href="./favicons/apple-touch-icon-180x180.png">
<link rel="icon" type="image/png" sizes="36x36" href="./favicons/android-chrome-36x36.png">
<link rel="icon" type="image/png" sizes="48x48" href="./favicons/android-chrome-48x48.png">
<link rel="icon" type="image/png" sizes="72x72" href="./favicons/android-chrome-72x72.png">
<link rel="icon" type="image/png" sizes="96x96" href="./favicons/android-chrome-96x96.png">
<link rel="icon" type="image/png" sizes="128x128" href="./favicons/android-chrome-128x128.png">
<link rel="icon" type="image/png" sizes="144x144" href="./favicons/android-chrome-144x144.png">
<link rel="icon" type="image/png" sizes="152x152" href="./favicons/android-chrome-152x152.png">
<link rel="icon" type="image/png" sizes="192x192" href="./favicons/android-chrome-192x192.png">
<link rel="icon" type="image/png" sizes="256x256" href="./favicons/android-chrome-256x256.png">
<link rel="icon" type="image/png" sizes="384x384" href="./favicons/android-chrome-384x384.png">
<link rel="icon" type="image/png" sizes="512x512" href="./favicons/android-chrome-512x512.png">
<link rel="icon" type="image/png" sizes="36x36" href="./favicons/icon-36x36.png">
<link rel="icon" type="image/png" sizes="48x48" href="./favicons/icon-48x48.png">
<link rel="icon" type="image/png" sizes="72x72" href="./favicons/icon-72x72.png">
<link rel="icon" type="image/png" sizes="96x96" href="./favicons/icon-96x96.png">
<link rel="icon" type="image/png" sizes="128x128" href="./favicons/icon-128x128.png">
<link rel="icon" type="image/png" sizes="144x144" href="./favicons/icon-144x144.png">
<link rel="icon" type="image/png" sizes="152x152" href="./favicons/icon-152x152.png">
<link rel="icon" type="image/png" sizes="160x160" href="./favicons/icon-160x160.png">
<link rel="icon" type="image/png" sizes="192x192" href="./favicons/icon-192x192.png">
<link rel="icon" type="image/png" sizes="196x196" href="./favicons/icon-196x196.png">
<link rel="icon" type="image/png" sizes="256x256" href="./favicons/icon-256x256.png">
<link rel="icon" type="image/png" sizes="384x384" href="./favicons/icon-384x384.png">
<link rel="icon" type="image/png" sizes="512x512" href="./favicons/icon-512x512.png">
<link rel="icon" type="image/png" sizes="16x16" href="./favicons/icon-16x16.png">
<link rel="icon" type="image/png" sizes="24x24" href="./favicons/icon-24x24.png">
<link rel="icon" type="image/png" sizes="32x32" href="./favicons/icon-32x32.png">
<link rel="manifest" href="./favicons/manifest.json">

{*
{/if}
*}
