{**
 * 自社サイト共通フッタ部分 
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/04/11
 *}

{* Biz訪問企業解析 *}
{if $smarty.server.SERVER_NAME == 'www.zenkiren.net' && !preg_match("/contact_fin\.php/", $smarty.server.REQUEST_URI)}
<!-- 基本サイト 通常ページ用 -->
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

  </div>
</div>
<footer>
  <p class="copyright">
    Copyright &copy; {$smarty.now|date_format:"%Y"} <a href="{$siteConf.site_uri}">{$site.company}</a> All Rights Reserved.<br />
    Powerd by <a href="{$_conf.site_uri}" target="_blank">{$_conf.site_name}</a>.
  </p>
</footer>

</body> 
</html>
