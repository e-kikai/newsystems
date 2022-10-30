{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
      table.list tr .subject {
        width: 160px;
      }

      table.list tr .created_at {
        width: 120px;
      }
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
        <th class='subject'>タイトル<br />送信対象</th>
        <th class='contents'>内容</th>
        <th class='created_at'>送信日時</th>
      </tr>
    </thead>

    {foreach $mailList as $m}
      <tr class='{cycle values='even, odd'}'>
        <td class='id'>{$m.id}</td>
        <td class='subject'>
          {$m.subject}<br /><br />
          {if !empty($m.file)}＜＜{$m.file}＞＞<br /><br />{/if}
          {if !empty($m.val)}{$m.val_label}{else}すべての全機連メンバー{/if}<br />
          ({$m.send_count}件)
        </td>
        <td class='contents'>{$m.message|escape|auto_link|nl2br nofilter}</td>
        <td class='created_at'>{$m.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
      </tr>
    {/foreach}
  </table>

  {*
  {include file="include/pager.tpl"}
  *}

{/block}