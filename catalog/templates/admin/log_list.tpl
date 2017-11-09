{extends file='include/layout.tpl'}

{block 'header'}
{literal}
<script type="text/JavaScript"><!--
//--></script>
<style type="text/css"><!--
table.list {
  width: 900px;
  margin: 8px auto;
}

table.list td,
table.list th {
  padding: 2px;
  border: 1px dotted #BBB;
  vertical-align: middle;
  background: #FFF;
}

table.list th {
  text-align: center;
  color: #EFE;
  background: #040;
}

table.list tr:nth-child(even) td {
  background: #EFE
}

table.list .id {
  width: 30px;
}

table.list .target,
table.list .action,
table.list .action_id {
  width: 60px;
}

table.list td.id,
table.list td.action_id {
  text-align: right;
}

table.list .ip {
  width: 120px;
}

table.list .contents {
  width: 20px;
}

table.list .user,
table.list .created_at {
  width: 150px;
}
--></style>
{/literal}
{/block}

{block 'main'}
  {*
  {include file="include/pager.tpl"}
  *}
  
  <div><a href="/admin/log_csv.php">CSVファイル出力</a></div>    
  <table class='list'>
    <thead>
      <tr>
        <th class='id'>ID</th>
        <th class='user'>user</th>
        <th class='ip'>IP</th>
        <th class='hostname'>hostname</th>
        <th class='target'>target</th>
        <th class='action'>action</th>
        <th class='action_id'>action_id</th>
        <th class='contents'> </th>
        <th class='created_at'>created_at</th>
      </tr>
    </thead>
    
    {foreach $logList as $l}
      <tr class='{cycle values='even, odd'}'>
        <td class='id'>{$l.id}</td>
        <td class='user'>{$l.user_name}</td>
        <td class='ip'>{$l.ip}</td>
        <td class='hostname'>{$l.hostname}</td>
        <td class='target'>{$l.target}</td>
        <td class='action'>{$l.action}</td>
        <td class='action_id'>{$l.action_id}</td>
        <td class='contents'>{$l.contents}</td>
        <td class='created_at'>{$l.created_at|date_format:'%Y/%m/%d %H:%M:%S'}</td>
      </tr>
    {/foreach}
  </table>
  
  {*
  {include file="include/pager.tpl"}
  *}
  
{/block}
