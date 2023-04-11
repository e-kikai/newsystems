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

  {if empty(count($my_bid_watches))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-pen-to-square"></i> ウォッチリストは、まだありません。
    </div>
  {/if}

  <a href="{$smarty.server.REQUEST_URI}&output=csv" class="btn btn-primary"
    style="position: absolute; right: 8px; top: -46px;">
    <i class="fas fa-file-csv"></i> CSV出力
  </a>

  <div class="table_area max_area">
    <table class="machines list">
      {foreach $my_bid_watches as $mw}
        {if $mw@first}
          <tr>
            <th class="id">ID</th>
            <th class="login_user">ユーザ</th>
            <th class="created_at">ウォッチ日時</th>
            <th class="created_at">取消日時</th>

            <th class="id sepa2">出品番号</th>
            {*
            <th class="img"></th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            <th class="uniq_account">入札ユーザ<br />アカウント</th>
            *}
            <th class="max-name">商品名</th>
            <th class="min_price">最低入札金額</th>
            <th class="company">出品会社</th>

            {if in_array($bid_open.status, array('carryout', 'after'))}
              <th class="border-start same_count">入札<br />件数</th>
              <th class="company sepa2">落札ユーザ</th>
              <th class="min_price">落札金額</th>
            {/if}
          </tr>
        {/if}

        <tr {if !empty($mw.deleted_at)} class="deleted" {/if}>
          <td class="id text-right">{$mw.id}</td>
          <td class="login_user">{$mw.my_user_id} : {$mw.user_name} {$mw.user_company}</td>

          <td class="created_at">{$mw.created_at|date_format:'%m/%d %H:%M:%S'}</td>
          <td class="created_at">{$mw.deleted_at|date_format:'%m/%d %H:%M:%S'}</td>

          <td class="id text-right sepa2">{$mw.list_no}</td>
          {*
          <td class="img">
            {if !empty($mw.top_img)}
              <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$mw.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$mw.top_img}" alt='PDF' /></noscript>
              </a>
            {/if}
          </td>
          <td class="name">
            <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">{$mw.name}</a>
          </td>
          <td class="maker">{$mw.maker}</td>
          <td class="model">{$mw.model}</td>
          <td class="uniq_account">
            {if $mw.my_user_id == MyUser::SYSTEM_MY_USER_ID}
              <span class="fst-italic text-danger">自動入札</span>
              {if !in_array($bid_open.status, array('carryout', 'after'))}
                <br /><button class="auto_bid_delete" value="{$mw.bid_machine_id}">✕ 取消</button>
              {/if}
            {else}
              {$mw.uniq_account}
            {/if}
          </td>
          *}
          <td class="max-name">
            <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">{$mw.name} {$mw.maker} {$mw.model}</a>
          </td>
          <td class="min_price">{$mw.min_price|number_format}円</td>
          <td class='company'>{'/(株式|有限|合.)会社/u'|preg_replace:' ':$mw.company|trim}</td>


          {if in_array($bid_open.status, array('carryout', 'after'))}
            <td class="same_count">
              {if !empty($bids_count[$mw.bid_machine_id])}
                {$bids_count[$mw.bid_machine_id]|number_format}
              {/if}
            </td>

            <td class="company sepa2">
              {if !empty($bids_result[$mw.bid_machine_id])}
                {if $bids_result[$mw.bid_machine_id]["my_user_id"] == MyUser::SYSTEM_MY_USER_ID}
                  <span class="fst-italic text-danger">自動入札</span>
                {else}
                  {$bids_result[$mw.bid_machine_id].my_user_id} :
                  {$bids_result[$mw.bid_machine_id].company}
                  {$bids_result[$mw.bid_machine_id].name}
                {/if}
              {/if}
            </td>

            <td class="min_price border-start">
              {if !empty($bids_result[$mw.bid_machine_id])}
                {$bids_result[$mw.bid_machine_id].amount|number_format}円
                {if $bids_result[$mw.bid_machine_id].same_count > 1}
                  <br />
                  (同額:{$bids_result[$mw.bid_machine_id].same_count})
                {/if}
              {/if}
            </td>

          {/if}
        </tr>
      {/foreach}
    </table>
  </div>
{/block}