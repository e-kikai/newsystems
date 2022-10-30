{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
      .user {
        width: 150px;
      }

      .target {
        width: 80px;
      }

      .action {
        width: 100px;
      }

      .action_id {
        width: 50px;
      }

      table.list td.action_id {
        text-align: right;
      }

      .contents {
        width: 20px;
      }

      .created_at {
        width: 120px;
      }

      div.actionlog.odd {
        background: #DFD;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  {*
  {include file="include/pager.tpl"}
  *}

  <form action="system/actionlog_list.php" method=="get">
    <input type="hidden" name="t" value="{$t}">
    表示月 :
    {html_select_date prefix='month' time=$month end_year='2013'
        display_days=false field_separator=' / ' month_format='%m' reverse_years=true field_order="YMD"}
    <input type="submit" value="表示月変更" />

    {if !empty($month)}
      <a href="system/actionlog_list.php">表示月をリセット</a>
    {else}
      本日から7日前まで表示
    {/if}
  </form>

  <div><a href="/system/actionlog_csv.php?t={$t}&m={$month}">CSVファイル出力</a></div>
  {*
  <table class='list'>
    <thead>
      <tr>
        <th class='id'>ID</th>
        <th class='user'>user</th>
        <th class='ip'>IP/hostname</th>
        <th class='target'>target</th>
        <th class='action'>action</th>
        <th class='action_id'>ID</th>
        <th class='contents'> </th>
        <th class='created_at'>created_at</th>
      </tr>
    </thead>
  </table>
  *}
  {foreach $logList as $l}
    <div class="actionlog {cycle values='even, odd'}">
      [{$l.id} {$l.created_at|date_format:'%m/%d %H:%M:%S'}]
      {if !empty($l.user_name)}＜{'/(株式|有限|合.)会社/'|preg_replace:'':$l.user_name}＞{/if}
      {$l.ip}{if $l.ip != $l.hostname}({$l.hostname}){/if} -
      {$l.action}
      {if !empty($l.action_id)}({$l.action_id}){/if}
      {$l.contents}
    </div>
    {*
      <tr class='{cycle values='even, odd'}'>
        <td class='id'>{$l.id}</td>
        <td class='user'>{'/(株式|有限|合.)会社/'|preg_replace:'':$l.user_name}</td>
        <td class='ip'>{$l.ip}{if $l.ip != $l.hostname}<br />{$l.hostname}{/if}</td>
        <td class='target'>{$l.target}</td>
        <td class='action'>{$l.action}</td>
        <td class='action_id'>{$l.action_id}</td>
        <td class='contents'>{$l.contents}</td>
        <td class='created_at'>{$l.created_at|date_format:'%m/%d %H:%M:%S'}</td>
      </tr>
      *}
  {/foreach}
  </table>

  {*
  {include file="include/pager.tpl"}
  *}

{/block}