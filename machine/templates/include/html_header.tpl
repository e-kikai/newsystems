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
  <meta http-equiv="Expires" content="0">

  <meta name="theme-color" content="#27367B">
  {if !empty($pageDescription)}
    <meta name="description" content="{$pageDescription}" />
  {/if}

  <base href="{$_conf.site_uri}" />
  {*
  <title>{if !empty($pageTitle)}{$pageTitle} - {$_conf.site_name}{else}{$_conf.site_name} - 信頼と安心の中古機械情報{/if}
  </title>
  *}
  <title>
    {if !empty($pageTitle)}
      {*
      {$pageTitle} | {$_conf.site_name}
      *}
      {$pageTitle}｜中古機械ならマシンライフ
    {else}
      {*
      {$_conf.site_name} | 中古機械の購入・販売をご支援します
      中古機械情報サイト マシンライフ(全機連)
      *}
      {*
      マシンライフ | 中古機械検索・情報サイト
      *}
      全機連の中古機械・工具の在庫情報｜マシンライフ
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
  <!--[if lte IE 7]>
  <script src="/libjs/ie6/warning.js"></script>
  {literal}
    <script>window.onload=function(){e("/libjs/ie6/")}</script>
  {/literal}
<![endif]-->

  {* common Javascript *}
  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.js"></script>
  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.lazyload.js"></script>
  <script type="text/javascript" src="{$_conf.libjs_uri}/modernizr.js"></script>

  <script type="text/javascript" src="{$_conf.libjs_uri}/mb_convert_kana.js"></script>
  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <script type="text/javascript" src="{$_conf.libjs_uri}/cjf.js"></script>

  {* jquery UI *}
  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
  <link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />

  {*
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.mapbox.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jcarousel.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.fancybox.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.ah-placeholder.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.textresizer.js"></script>
*}

  {* StyleSeet *}
  <link href="{$_conf.libjs_uri}/css/html5reset.css" rel="stylesheet" type="text/css" />

  {* bootstrap *}
  {if empty($no_bootstrap)}
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
  {/if}

  <link href="{$_conf.libjs_uri}/css/common.css?20230308" rel="stylesheet" type="text/css" />

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
    <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}google_analytics.js"></script>
  {*
{/if}
*}

  {*
<script src="//cdn.optimizely.com/js/2382360201.js"></script>
*}

  {* fontawesome *}
<script src="https://kit.fontawesome.com/083f5541f5.js" crossorigin="anonymous"></script>