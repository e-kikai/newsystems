<!DOCTYPE html>
{**
 * 電子カタログ：共通HTMLヘッダ部分 
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/04/19
 *}
<html lang='ja'>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />
  <meta name="robots" content="noindex, nofollow" />

  <meta name="description" content="{if isset($pageDescription)}{$pageDescription}{/if}" />
  <meta name="keywords" content="" />
  <base href="{$_conf.site_uri}" /> 
  
  <title>{if isset($pageTitle)}{$pageTitle} - {/if}{$_conf.site_name}</title>
  
{* for IE6 *}
<!--[if lt IE 9]>
  <script src="{$_conf.libjs_uri}/IE/ie_speedup.js"></script>
  <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js"></script>
<![endif]-->

<!--[if lt IE 7]>
  <script src="http://ie7-js.googlecode.com/svn/trunk/lib/ie7-squish.js"></script>
  <script src="{$_conf.libjs_uri}/IE/DD_belatedPNG.js"></script>
  {literal}
    <script type="text/javascript">DD_belatedPNG.fix('img, .description');</script>
  {/literal}
<![endif]-->

{* common Javascript *}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.lazyload.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/modernizr.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.cookie.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/cjf.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
<link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />

{* StyleSeet *}
<link href="{$_conf.libjs_uri}/css/html5reset.css" rel="stylesheet" type="text/css" />

<link href="{$_conf.libjs_uri}/css/cjf.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}/common.css" rel="stylesheet" type="text/css" />

{* ミニブログ *}
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}/miniblog.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}/miniblog.css" rel="stylesheet" type="text/css" />

{* textresizer *}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.textresizer.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/mb_convert_kana.js"></script>
  
{* Google Analytics *}
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}/google_analytics.js"></script>
