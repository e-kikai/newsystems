{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
<form action="system/contact_list_all.php" method=="get">
  表示月 : 
  {html_select_date prefix='month' time=$month end_year='2013'
    display_days=false field_separator=' / ' month_format='%m' reverse_years=true field_order="YMD"}
  <input type="submit" value="表示月変更" />
  
  {if !empty($month)}
    <a href="system/contact_list_all.php">表示月をリセット</a>
  {else}
    本日から1ヶ月前まで表示
  {/if}

   | <a href="system/contact_list_all.php?output=csv">メールアドレスCSV出力</a>
</form>

{if empty($contactList)}
  <div class="error_mes">期間内にお問い合せ情報がありませんでした。</div>
{else}
<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="company">送信先</th>
      <th class="name">お名前</th>
      <th class="mail">連絡先</th>
      <th class="contents">内容</th>
      <th class="created_at">登録日</th>
      <th class="id">メル<br />マガ</th>
    </tr>
  </thead>
  
  {foreach $contactList as $c}
    <tr class='{cycle values='even, odd'}'>
      <td class='id'>{$c.id}</td>
      <td class='company'>
        {if empty($c.company)}全機連事務局{else}{$c.company}{/if}
        {if !empty($c.machine_id)}<br />
          {$c.no}<br />
          {$c.name}<br />
          {$c.maker}<br />
          {$c.model}
        {/if}
      </td>
      <td class='name'>{$c.user_company}<br />{$c.user_name}</td>
      <td class='mail'>
        {mailto address=$c.mail encode="javascript"}<br />
        TEL : {$c.tel}<br />
        FAX : {$c.fax}<br />
        {$c.addr1}
        {if !empty($c.return_time)}<br />{$c.return_time|escape|nl2br nofilter}{/if}
      </td>
      <td class='contents'>{$c.message|escape|nl2br nofilter}</td>
      <td class='created_at'>{$c.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
      <td class='id'>{if !empty($c.mailuser_flag)}◯{/if}</td>
    </tr>
  {/foreach}
</table>
{/if}
{/block}
