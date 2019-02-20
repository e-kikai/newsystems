{extends file='companysite/layout.tpl'}

{block 'header'}
<meta name="description" content="" />
<meta name="keywords" content="中古機械" />

{literal}
<script type="text/javascript">
</script>
<style type="text/css">

</style>
{/literal}
{/block}

{block 'main'}

<h1>会社情報</h1>

<div class="company_area">
{if !empty($site.company_configs.company_top_title)}
  <h2>{$site.company_configs.company_top_title}</h2>
{/if}

{if !empty($site.company_configs.company_top_contents)}
  <div class='greetng_area'>
    {if !empty($company.top_img)}
      <img src='{$_conf.media_dir}company/{$company.top_img}'
        alt="中古機械 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}" />
    {/if}
    
    {$site.company_configs.company_top_contents|escape|nl2br nofilter}
    <br style="clear:both;" />
  </div>
{/if}

<h2>会社概要</h2>
{if !empty($company.infos.pr)}
  <p class="pr">{$company.infos.pr|escape|nl2br nofilter}</p>
{/if}

<table class="mysite company">
  <tr>
    <th>会社名</th>
    <td>{$company.company}</td>
  </tr>
  
  <tr class="company_kana">
    <th>会社名(カナ)</th>
    <td>{$company.company_kana}</td>
  </tr>
  
  <tr class='address'>
    <th>住所</th>
    <td>
      〒{if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}　
      <span class="pure_address">{$company.addr1} {$company.addr2} {$company.addr3}</span>
      <a href="map.php">[アクセスMAP]</a>
    </td>
  </tr>
  <tr class='contact'>
    <th>TEL</th>
    <td>{$site.contact_tel}</td>
  </tr>
  <tr>
    <th>FAX</th>
    <td>{$company.contact_fax}</td>
  </tr>
  <tr class='officer'>
    <th>代表者</th>
    <td>{$company.representative}</td>
  </tr>
  
  <tr class='officer'>
    <th>担当者</th>
    <td>{$company.officer}</td>
  </tr>
  
  <tr class='infos opening'>
    <th>営業時間</th>
    <td>{$company.infos.opening}</td>
  </tr>
  
  <tr class='infos holiday'>
    <th>定休日</th>
    <td>{$company.infos.holiday}</td>
  </tr>
    
  <tr class='infos license'>
    <th>古物免許</th>
    <td>{$company.infos.license}</td>
  </tr>
  
  <tr class='infos complex'>
    <th>所属団体</th>
    <td>{$company.treenames}</td>
  </tr>
  {if !empty($site.offices)}
  <tr class="offices">
    <th>営業所・倉庫</th>
    <td>
        {foreach $company.offices as $o}
          <div class="office">
            <div class="office_name">{$o.name}</div>
            <div class="office_address">{$o.addr1} {$o.addr2} {$o.addr3}</div>
            <a href="map.php#{$o.name}">(アクセスMAP)</a>
          </div>
        {/foreach}
    </td>
  </tr>
  {/if}
  
  {if !empty($company.website)}
  <tr class='officer'>
    <th>ウェブサイト</th>
    <td><a href="{$company.website}" target="_blank">{$company.website}</a></td>
  </tr>
  {/if}
</table>

{if !empty($site.company_configs.makers_name)}
  <h2>取り扱いメーカー</h2>
  <ul class="maker_area">
    {foreach $site.company_configs.makers_name as $m}
      {if !empty($m)}
        {if !empty($site.company_configs.makers_url[$m@key])}
          <li><a href="{$site.company_configs.makers_url[$m@key]}" target="_blank">{$m}</a></li>
        {else}
          <li>{$m}</li>
        {/if}
      {/if}
    {/foreach}
  </ul>
{/if}

{if !empty($site.company_configs.histories_contents)}
    <h2>沿革</h2>
    <table class="mysite company">
    {foreach $site.company_configs.histories_contents as $h}
      {if !empty($h)}
        <tr>
          <th>{$site.company_configs.histories_date[$h@key]}</th>
          <td>{$h}</td>
        </tr>
      {/if}
    {/foreach}
  </table>
{/if}

</div>
<br style="clear:both;" />
{/block}
