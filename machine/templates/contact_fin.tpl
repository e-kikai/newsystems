{extends file='include/layout.tpl'}

{block name='header'}
<meta name="robots" content="noindex, nofollow" />

{literal}
{/literal}
{/block}

{block 'main'}
<div class='terms'>
  お問い合わせありがとうございました。<br />
  追ってシステムから、自動的にお問い合せ受け付け通知メールを送信いたします。<br /><br />

  <p style="color:#C00;">
    万が一、システムからの通知メールが届かなかった場合は、入力メールアドレスに誤りがあった可能性があります。<br />
    お手数ですがメールアドレスをご確認の上、再度お問い合わせをしていただきますようお願いいたします。
  </p>

  <br />
  今後とも、<a href="{$_conf.website_uri}" target="_blank">{$_conf.copyright}</a>および<a href="/">マシンライフ</a>をよろしくお願いいたします。<br /><br />
</div>

<a href="/">マシンライフ中古機械情報 トップページに戻る</a>

{if $smarty.server.SERVER_NAME == 'www.zenkiren.net'}
{*
<script type="text/javascript"><!--
var site = 'zenkirennet';
var contact = 'on';
//--></script>
<script type="text/javascript" src="https://www.biz-access.jp/a.js"></script>
<noscript>
<img src="https://www.biz-access.jp/access.cgi?ref=unknown&site=zenkirennet&contact=on"
border="0">
</noscript>
*}
<!-- 基本サイト コンバージョン用 -->
<script type='text/javascript'><!--//<![CDATA[
var analysis_ref = escape(document.referrer)+'';
document.write('<scr'+'ipt type="text/javascript" language="javascript" src="//cbank.jp/access.php');
document.write('?cd_id=zenkiren2&ref='+analysis_ref+'&cv=true&'+(new Date().getTime())+'"><\/script>');
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

{/block}
