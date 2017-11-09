{extends file='companysite/layout.tpl'}

{block 'header'}
<meta name="description" content="" />
<meta name="keywords" content="中古機械" />

{literal}
<script type="text/javascript">
</script>
<style type="text/css">
/*** MAP ***/
.gmap2 {
  display : block;
  width   : 800px;
  height  : 450px;
  border  : 1px solid #AAA;
  margin  : 16px auto 4px auto;
}

</style>
{/literal}
{/block}

{block 'main'}

<h1>{$site.company}　 アクセスMAP</h1>

<iframe class="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
  src="http://maps.google.co.jp/maps?f=q&amp;q={$site.addr1} {$site.addr2} {$site.addr3}+({$site.company})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
 

<table class="mysite map">
  <tr>
    <th>住所</th>
    <td>
      〒{$site.zip}
      <span class="pure_address">{$site.addr1} {$site.addr2} {$site.addr3}</span><br />
      <a href="https://maps.google.co.jp/maps?f=q&amp;q={$site.addr1} {$site.addr2} {$site.addr3}+({$site.company})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m" style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
    </td>
  </tr>
    <th>交通機関：最寄り駅</th>
    <td>
      {if !empty($site.infos.access_train)}
        {$site.infos.access_train|escape|default:""|nl2br nofilter}<br />
      {/if}
      <a href='http://www.google.co.jp/maps?daddr={$site.addr1|urlencode}{$site.addr2|urlencode}{$site.addr3|urlencode}+({$site.company})&hl=ja&ie=UTF8' target='_blank'>Google乗換案内</a>
    </td>
  </tr>
  </tr>
    <th>交通機関：車</th>
    <td>
      {if !empty($site.infos.access_train)}
        {$site.infos.access_car|escape|default:""|nl2br nofilter}<br />
      {/if}
      <a href='http://www.google.co.jp/maps?daddr={$site.addr1|urlencode}{$site.addr2|urlencode}{$site.addr3|urlencode}+({$site.company})&hl=ja&ie=UTF8&dirflg=d' target='_blank'>Googleルート案内</a>
    </td>
  </tr>
</table>

{if !empty($site.offices)}
  {foreach $site.offices as $o}
    <h2 id="{$o.name}">{$o.name}</h2>
    <iframe class="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
      src="http://maps.google.co.jp/maps?f=q&amp;q={$o.addr1} {$o.addr2} {$o.addr3}+({$o.name})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />

    <table class="mysite map">
      <tr>
        <th>住所</th>
        <td>
          〒{$site.zip}
          <span class="pure_address">{$site.addr1} {$site.addr2} {$site.addr3}</span><br />
          <a href="https://maps.google.co.jp/maps?f=q&amp;q={$o.addr1} {$o.addr2} {$o.addr3}+({$o.name})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m" style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
        </td>
      </tr>
        <th>交通機関：最寄り駅</th>
        <td>
          <a href='http://www.google.co.jp/maps?daddr={$o.addr1|urlencode}{$o.addr2|urlencode}{$o.addr3|urlencode}+({$o.name})&hl=ja&ie=UTF8' target='_blank'>Google乗換案内</a>
        </td>
        </td>
      </tr>
      </tr>
        <th>交通機関：車</th>
        <td>
          <a href='http://www.google.co.jp/maps?daddr={$o.addr1|urlencode}{$o.addr2|urlencode}{$o.addr3|urlencode}+({$o.name})&hl=ja&ie=UTF8&dirflg=d' target='_blank'>Googleルート案内</a>        
        </td>
      </tr>
    </table>
  {/foreach}
{/if}
<br style="clear:both;" />
{/block}
