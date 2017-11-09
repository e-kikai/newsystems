{**
 * 共通フッタ部分 
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 *}
  </div>
</div>

{* Biz訪問企業解析 *}
{*
{if $smarty.server.SERVER_NAME == 'www.zenkiren.net' && !preg_match("/contact_fin\.php/", $smarty.server.REQUEST_URI)}
*}
{*
<script type="text/javascript"><!--
var site = 'zenkirennet';
var contact;
//--></script>
<script type="text/javascript" src="https://www.biz-access.jp/a.js"></script>
<noscript>
<img src="https://www.biz-access.jp/access.cgi?ref=unknown&site=zenkirennet"
border="0">
</noscript>
*}

{*
<script type='text/javascript'><!--//<![CDATA[
document.write('<scr'+'ipt type="text/javascript" language="javascript" src="http://customerbank.jp/login/access.php');
document.write('?cd_id=zenkiren2&'+(new Date().getTime())+'"><\/script>');
//]]>--></script>
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 977898861;
var google_custom_params = window.google_tag_params;
var google_remarketing_only = true;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/977898861/?value=0&guid=ON&script=0"/>
</div>
</noscript>
*}

<!-- 基本サイト 通常ページ用 -->
{*
<script type='text/javascript'><!--//<![CDATA[
var analysis_ref = escape(document.referrer)+'';
document.write('<scr'+'ipt type="text/javascript" language="javascript" src="//cbank.jp/access.php');
document.write('?cd_id=zenkiren2&ref='+analysis_ref+'&'+(new Date().getTime())+'"><\/script>');
//]]>--></script>
<script type="text/javascript">
/* <![CDATA[ */
var google_conversion_id = 977898861;
var google_custom_params = window.google_tag_params;
var google_remarketing_only = true;
/* ]]> */
</script>
<script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
</script>
<noscript>
<div style="display:inline;">
<img height="1" width="1" style="border-style:none;" alt="" src="//googleads.g.doubleclick.net/pagead/viewthroughconversion/977898861/?value=0&guid=ON&script=0"/>
</div>
</noscript>
{/if}
*}

{*** clicky ***}
{if $smarty.server.SERVER_NAME == 'www.zenkiren.net'}
<a title="Web Analytics" href="http://clicky.com/100784739"><img alt="Web Analytics" src="//static.getclicky.com/media/links/badge.gif" border="0" /></a>
<script src="//static.getclicky.com/js" type="text/javascript"></script>
<script type="text/javascript">try{ clicky.init(100784739); }catch(e){}</script>
<noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/100784739ns.gif" /></p></noscript>

{*** Lucky Orange ***}
<script type='text/javascript'>
window.__wtw_lucky_site_id = 32662;

    (function() {
        var wa = document.createElement('script'); wa.type = 'text/javascript'; wa.async = true;
        wa.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://cdn') + '.luckyorange.com/w.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(wa, s);
      })();
    </script>
{/if}

<div class="footer_menu">
  {include file="include/header_menu.tpl"}
</div>

<footer>
  <p class="copyright">
    {*
    <img class='footer_title' src='img/footer_title.png' alt='COPYRIGHT {$_conf.copyright} {$smarty.now|date_format:"%Y"} {$_conf.copyright}'/>
    *}   
    Copyright &copy; {$smarty.now|date_format:"%Y"}
    <a href="{$_conf.website_uri}" target="_blank">{$_conf.copyright}</a>
    All Rights Reserved.
  </p>
</footer>

{*
{if $smarty.server.SERVER_NAME == 'www.zenkiren.net'}
<!-- ClickTale Bottom part -->

<script type='text/javascript'>
// The ClickTale Balkan Tracking Code may be programmatically customized using hooks:
// 
 function ClickTalePreRecordingHook() {
window.ClickTaleFetchFrom = document.location.href;
window.ClickTaleFetchFrom+="#CTFetchUserAgent=VisitorUserAgent";
}
//
// For details about ClickTale hooks, please consult the wiki page http://wiki.clicktale.com/Article/Customizing_code_version_2

document.write(unescape("%3Cscript%20src='"+
(document.location.protocol=='https:'?
"https://cdnssl.clicktale.net/www02/ptc/2db3dc43-5dcc-48a6-b63c-5990cce1e8e4.js":
"http://cdn.clicktale.net/www02/ptc/2db3dc43-5dcc-48a6-b63c-5990cce1e8e4.js")+"'%20type='text/javascript'%3E%3C/script%3E"));
</script>

<!-- ClickTale end of Bottom part -->
{/if}
*}

</body> 
</html>
