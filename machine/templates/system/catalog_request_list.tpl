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
  {*
  {include file="include/pager.tpl"}
  
  <div><a href="/system/actionlog_csv.php?t={$t}">CSVファイル出力</a></div>
  *}
  <table class='list'>
    <thead>
      <tr>
        <th class='id'>ID</th>
        
        <th class=''>送信元</th>
        <th class='maker'>メーカー</th>
        <th class='model'>型式</th>
        <th class='comment'>コメント</th>
        <th class='send_count'>送信数</th>
        <th class='created_at'>送信日時</th>
      </tr>
    </thead>
    
    {foreach $requestList as $r}
      <tr class='{cycle values='even, odd'}'>
        <td class='id'>{$r.request_id}</td>
        <td class=''>{$r.company}<br />{$r.user_name}</td>
        <td class='maker'>{$r.maker}</td>
        <td class='model'>{$r.model}</td>
        <td class='comment'>{$r.comment|escape|auto_link|nl2br nofilter}</td>
        <td class='send_count'>{$r.send_count}件</td>
        <td class='created_at'>{$r.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
      </tr>
    {/foreach}
  </table>
  
  {*
  {include file="include/pager.tpl"}
  *}
  
{/block}
