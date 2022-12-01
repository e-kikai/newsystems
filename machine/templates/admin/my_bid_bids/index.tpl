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

  {if empty(count($my_bid_bids))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-pen-to-square"></i> 自社出品への入札は、まだありません。
    </div>
  {/if}

  <div class="table_area">
    <table class="machines list">
      {foreach $my_bid_bids as $bb}
        {if $bb@first}
          <tr>
            <th class="list_no">出品番号</th>
            <th class="img"></th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            <th class="company">入札ユーザ<br />アカウント</th>
            <th class="min_price">最低入札金額</th>
            <th class="min_price">入札金額</th>
            <th class="comment">備考欄</th>
            <th class="created_at">入札日時</th>
            {if in_array($bid_open.status, array('carryout', 'after'))}
              <th class="min_price sepa2">落札金額</th>
              <th class="res">結果</th>
            {/if}
          </tr>
        {/if}

        <tr {if !empty($bb.deleted_at)} class="deleted" {/if}>
          <td class="list_no fs-5 text-center">{$bb.list_no}</td>
          <td class="img">
            {if !empty($bb.top_img)}
              <a href="/bid_detail.php?m={$bb.bid_machine_id}" target="_blank">
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$bb.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$bb.top_img}" alt='PDF' /></noscript>
              </a>
            {/if}
          </td>
          <td class="name">
            <a href="/bid_detail.php?m={$bb.bid_machine_id}" target="_blank">{$bb.name}</a>
          </td>
          <td class="maker">{$bb.maker}</td>
          <td class="model">{$bb.model}</td>
          <td class="model">{$bb.uniq_account}</td>
          <td class="min_price">{$bb.min_price|number_format}円</td>
          <td class="min_price">{$bb.amount|number_format}円</td>
          <td class="comment">{$bb.comment}</td>
          <td class="created_at">{$bb.created_at|date_format:'%Y/%m/%d %H:%M'}</td>

          {if in_array($bid_open.status, array('carryout', 'after'))}
            <td class="min_price sepa2">
              {$bids_result[$m.id].company} {$bids_result[$m.id].name}
            </td>
            <td class="min_price">
              {if !empty($bids_result[$m.id].amount)}
                {$bids_result[$m.id].amount|number_format}円
              {/if}
            </td>
          {/if}
        </tr>
      {/foreach}
    </table>
  </div>
{/block}