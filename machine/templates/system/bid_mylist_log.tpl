{extends file='include/layout.tpl'}

{block 'header'}

  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {});
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  {if empty($mylistLogList)}
    <div class="error_mes">条件に合うログはありません</div>
  {/if}

  {foreach $mylistLogList as $l}
    {if $l@first}
      <table class="machines list">
        <tr>
          <th class="created_at">日時</th>
          <th class="ip">IP</th>
          <th class="hostname">ホスト名</th>
          <th class="min_price">登録件数</th>
        </tr>
      {/if}

      <tr>
        <td class="created_at">{$l.date|date_format:'%Y/%m/%d'}</td>
        <td class="ip">{$l.ip}</td>
        <td class="hostname">{$l.hostname}</td>
        <td class="min_price">{$l.count}</td>
      </tr>

      {if $l@last}
      </table>
    {/if}
  {/foreach}

{/block}