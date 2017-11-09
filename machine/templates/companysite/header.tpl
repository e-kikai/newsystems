{**
 * 自社サイト共通ヘッダ部分 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/04/11
 *}
{literal}
<style>
</style>
{/literal}

</head>
<body>
<div class="main_container">
  <strong class="header_catchcopy">
    {if !empty($site.company_configs.headcopy)}
      {$site.company_configs.headcopy}
    {else}
      中古機械のスペシャリスト {$site.company} {$site.addr1}
    {/if}
  </strong>
  <header>
    <a href="./" class='header_title'>{$site.company}</a>
    
    <a href="contact.php" class='header_contact'>
      お気軽にお問い合せ下さい<br />
      TEL : <span class="contact_tel">{$site.contact_tel}</span><br />
      FAX : <span class="contact_fax">{$site.contact_fax}</span><br />
    </a>
  </header>

  <div class="header_menu">
    <a href="./" title="TOPに戻る">TOP</a>
    {if $site.rank >= Companies::RANK_A}
      <a href="machine_list.php" title="在庫一覧">在庫一覧</a>
    {/if}
    <a href="company.php" title="会社情報">会社情報</a>
    <a href="map.php" title="MAP">アクセスMAP</a>
    <a href="contact.php" title="お問い合わせ">お問い合わせ</a>
  </div>
    
  {*** パンくず ***}
  {if !isset($pankuzu) || $pankuzu !== false}
    <div class="pankuzu">
      <a href="./">{$_conf.site_name}</a> &gt;
      
      {if !empty($pankuzu)}
        {foreach from=$pankuzu key=k item=p name='pun'}
          <a href="{$k}">{$p}</a> &gt;
        {/foreach}
      {/if}
      
      {if isset($pageTitle)}
        <strong>{$pageTitle|truncate:50:" ほか"}</strong>
      {/if}
    </div>
    
    {if isset($pageTitle)}
      <h1>{$pageTitle|truncate:50:" ほか"}</h1>
    {/if}
    
    {if isset($pageDescription)}
      <div class="description">{$pageDescription}</div>
    {/if}
  {/if}
  
  {*** メッセージ枠 ***}
  {if isset($message)}
    <div class="message">
      {if is_array($message)}
        {foreach $message as $m}
          <div>{$m}</div>
        {/foreach}
      {else}
        <div>{$message}</div>
      {/if}
    </div>
  {/if}
  
  {*** エラーメッセージ枠 ***}
  {if isset($errorMes)}
    <div class="error_mes">
      {if is_array($errorMes)}
        {foreach $errorMes as $m}
          <div>{$m}</div>
        {/foreach}
      {else}
        <div>{$errorMes|escape|default:""|nl2br nofilter}</div>
      {/if}
    </div>
  {/if}
  
  <div class="center_container">
