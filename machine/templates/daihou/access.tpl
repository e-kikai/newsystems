{extends file='daihou/layout/layout.tpl'}

{block 'header'}
  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div>
    <div class="zip" itemprop="postalCode">
      〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}
    </div>
    <div class="addr">
      <span itemprop="region">{$company.addr1}</span>
      <span itemprop="locality">{$company.addr2}</span>
      <span itemprop="street-address">{$company.addr3}</span>
    </div>
  </div>

  <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
    src="https://maps.google.co.jp/maps?f=q&amp;q={$company.addr1}{$company.addr2}{$company.addr3}&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe>
  <div class="row">
    <div class="col-lg-offset-3 col-lg-6 col-md-offset-3 col-md-6 col-sm-12">
      <div>
        <a target="_blank" href="https://www.google.co.jp/maps/place/{$company.addr1}{$company.addr2}{$company.addr3}">
          <span class="glyphicon glyphicon-globe"></span>
          <span class="btn-content">大きな地図を表示</span>
        </a>
      </div>
    </div>
  </div>

{/block}