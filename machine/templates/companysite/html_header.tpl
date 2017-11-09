<!DOCTYPE html>
{**
 * 自社サイト共通HTMLヘッダ部分 
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/04/11
 *}
<html lang='ja'>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  
  {if !empty($pageDescription)}  
    <meta name="description" content="{$pageDescription}" />
  {/if}
  
  <base href="{$site.site_uri}" />
  
  <title>{if !empty($pageTitle)}{$pageTitle}{else}{$site.company}{/if}
  </title>
  
{* for IE8－ IE9.js *}
<!--[if lt IE 9]>
  <script src="{$_conf.libjs_uri}/IE/ie_speedup.js"></script>
  <script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js"></script>
<![endif]-->

{* for IE6－PNGアルファチャンネル *}
<!--[if lt IE 7]>
  <script src="http://ie7-js.googlecode.com/svn/trunk/lib/ie7-squish.js"></script>
  <script src="{$_conf.libjs_uri}/IE/DD_belatedPNG.js"></script>
  {literal}
    <script type="text/javascript">DD_belatedPNG.fix('img, .description');</script>
  {/literal}
<![endif]-->

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
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.lazyload.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/modernizr.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.cookie.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/mb_convert_kana.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/cjf.js"></script>

{* jquery UI *}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
<link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />

{* StyleSeet *}
<link href="{$_conf.libjs_uri}/css/html5reset.css" rel="stylesheet" type="text/css" />
<link href="/companysite/css/companysite_common.css" rel="stylesheet" type="text/css" />

{* デザインテンプレート *}
{if !empty($smarty.get.t)}
  <link href="/companysite/css/template_css.php?t={$smarty.get.t}" rel="stylesheet" type="text/css" />
{elseif !empty($site.template)}
  {*
  <link href="/companysite/css/{$site.template}.css" rel="stylesheet" type="text/css" />
  *}
  <link href="/companysite/css/template_css.php?t={$site.template}" rel="stylesheet" type="text/css" />
{/if}

{* Google Analytics *}
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}google_analytics.js"></script>
