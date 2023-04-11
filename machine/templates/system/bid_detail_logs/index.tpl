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
      <i class="fas fa-pen-to-square"></i> 詳細ログは、まだありません。
    </div>
  {/if}

  <a href="{$smarty.server.REQUEST_URI}&output=csv" class="btn btn-primary"
    style="position: absolute; right: 8px; top: -46px;">
    <i class="fas fa-file-csv"></i> CSV出力
  </a>

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  <div class="table_area max_area">
    <table class="machines list">
      {foreach $bid_detail_logs as $dl}
        {if $dl@first}
          <tr>
            <th class="id">ID</th>
            <th class="uniq_account">utag</th>
            <th class="login_user">ログインユーザ</th>
            <th class="created_at">登録日時</th>
            <th class="id sepa2">出品番号</th>
            <th class="max-name">商品名</th>
            <th class="min_price">最低入札金額</th>
            <th class="company">出品会社</th>
            <th class="referer">リファラ</th>
          </tr>
        {/if}

        <tr {if !empty($dl.deleted_at)} class="deleted" {/if}>
          <td class="id text-right">{$dl.id}</td>
          <td class="uniq_account">{$dl.utag}</td>
          <td class="login_user">{if !empty($dl.my_user_id)}{$dl.my_user_id} : {$dl.user_name} {$dl.user_company}{/if}</td>
          <td class="created_at">{$dl.created_at|date_format:'%m/%d %H:%M:%S'}</td>
          <td class="id text-right sepa2">{$dl.list_no}</td>
          <td class="max-name">
            <a href="/bid_detail.php?m={$dl.bid_machine_id}" target="_blank">{$dl.name} {$dl.maker} {$dl.model}</a>
          </td>
          <td class="min_price">{$dl.min_price|number_format}円</td>
          <td class='company'>{'/(株式|有限|合.)会社/u'|preg_replace:' ':$dl.company|trim}</td>

          <td class="referer">
            {if !empty($dl.referer)}
              <a href="{$dl.referer}" target="_blank">
                {$dl.referer|regex_replace:"/^https\:\/\/www\.zenkiren\.net/":""}
              </a>
            {/if}
          </td>
        </tr>
      {/foreach}
    </table>
  </div>

  {*** ページャ ***}
  {*
  {include file="include/pager.tpl"}
      *}

{/block}