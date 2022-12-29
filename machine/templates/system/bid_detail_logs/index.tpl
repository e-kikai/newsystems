{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  {if empty(count($bid_detail_logs))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-pen-to-square"></i> ウォッチリストは、まだありません。
    </div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  <div class="table_area">
    <table class="machines list">
      {foreach $bid_detail_logs as $dl}
        {if $dl@first}
          <tr>
            <th class="id">ID</th>
            <th class="company">utag</th>
            <th class="company">ユーザ</th>
            <th class="created_at">登録日時</th>
            <th class="id sepa2">出品番号</th>
            <th class="name">商品名</th>
            <th class="min_price">最低入札金額</th>
            <th class="company">出品会社</th>
          </tr>
        {/if}

        <tr {if !empty($dl.deleted_at)} class="deleted" {/if}>
          <td class="id text-right">{$dl.id}</td>
          <td class="company">{$dl.utag}</td>
          <td class="company">{$dl.my_user_id} : {$dl.user_name} {$dl.user_company}</td>
          <td class="created_at">{$dl.created_at|date_format:'%m/%d %H:%M:%S'}</td>
          <td class="id text-right sepa2">{$dl.list_no}</td>
          <td class="name">
            <a href="/bid_detail.php?m={$dl.bid_machine_id}" target="_blank">{$dl.name} {$dl.maker} {$dl.model}</a>
          </td>
          <td class="min_price">{$dl.min_price|number_format}円</td>
          <td class='company'>{'/(株式|有限|合.)会社/u'|preg_replace:' ':$dl.company|trim}</td>
        </tr>
      {/foreach}
    </table>
  </div>

  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}