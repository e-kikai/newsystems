{extends file='companysite/layout.tpl'}

{block 'header'}
<meta name="description" content="" />
<meta name="keywords" content="中古機械" />

{literal}
<script type="text/javascript">
</script>
<style type="text/css">
.center_container {
  padding: 0;
}
</style>
{/literal}
{/block}

{block 'main'}

{if !empty($site.company_configs.top_img)}
  <div class="top_img_area">
    <img class="toppage_img" src='/media/companysite/{$site.company_configs.top_img}' />
    <div class="top_img_contents_area">
    {if !empty($site.company_configs.top_img_title)}
      <p class="top_img_title">{$site.company_configs.top_img_title}</p>
    {/if}
    
    {if !empty($site.company_configs.top_img_contents)}
      <p class="top_img_contents">{$site.company_configs.top_img_contents|escape|nl2br nofilter}</p>
    {/if}
    </div>
  </div>
{/if}
  
<div class="left_area">
  {if !empty($site.company_configs.top_summary_title)}
    <p class="pr">{$site.company_configs.top_summary_title}</p>
  {/if}
  
  {if !empty($site.company_configs.top_summary_contents)}
    <p class="comment">{$site.company_configs.top_summary_contents|escape|nl2br nofilter}</p>
  {/if}
  
  <a class="button" href="machine_list.php">中古機械 在庫一覧</a>
  
  <div class="top_zenkiren">
    <div class="top_zenkiren_inner">
    
      <a class="top_zenkiren_link" href="http://www.zenkiren.org/" target="_blank">
        <img class="toppage_zenkiren" src="./imgs/logo_zenkiren.png" />
      </a>
      {$site.company}は、全日本機械業連合会(全機連)の正規会員です。<br />
      全日本機械業連合会は、日本全国において工作機械、鍛圧機械を取り扱う事業者、
      および事業法人によって運営されている非営利団体です。<br /><br />
      ＞＞ <a href="http://www.zenkiren.org/" target="_blank">全日本機械業連合会</a>
      <br style="clear:both;" />
    </div>
  </div>
</div>

<div class="right_area">
  <h2>{$site.company}について</h2>
  {if !empty($company.top_img)}
    <img src='{$_conf.media_dir}/company/{$company.top_img}'
      alt="中古機械 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}"class="top_img" />
  {/if}
  <div>
    {$company.company}<br />
    〒{if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}<br />
    {$company.addr1} {$company.addr2} {$company.addr3}<br />
    TEL : {$company.contact_tel}<br />
    FAX : {$company.contact_fax}<br />
    古物免許 {$company.infos.license}
  </div>
  
  <div style="text-align:center;margin: 16px 0;">
    <a class="button" href="company.php">会社情報</a>
    <a class="button" href="map.php">アクセスMAP</a>
  </div>
</div>
<br style="clear:both;" />
{/block}
