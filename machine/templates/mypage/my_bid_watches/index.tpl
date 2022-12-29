{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 削除処理 ///
        $('button.delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          // 送信確認
          var mes = "出品番号 : " + $.trim($_parent.find('td.list_no').text()) + "\n";
          mes += $.trim($_parent.find('td.name').text()) + " ";
          mes += $.trim($_parent.find('td.maker').text()) + " " + $.trim($_parent.find('td.model').text());
          mes += "\nこのウォッチを解除します。よろしいですか。"
          if (!confirm(mes)) { return false; }

          // $_self.attr('disabled', 'disabled');

          return true;
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  {if empty(count($my_bid_watches))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-star"></i> まだ、ウォッチリストに登録がありません。
    </div>
  {/if}

  <div class="table_area">
    <table class='table table-hover table-condensed table-striped'>

      {foreach $my_bid_watches as $mw}
        {if $mw@first}
          <tr>
            <th class="list_no">出品番号</th>
            <th class="img"></th>
            {*
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            *}
            <th class="full_name_02">機械名/メーカー/型式</th>
            <th class="year">年式</th>

            <th class="company">出品会社</th>

            <th class="min_price">最低入札金額</th>
            <th class="addr_1">都道府県</th>

            {if $bid_open.status == 'bid'}
              <th class="created_at">ウォッチ日時</th>
              <th class="delete">解除</th>
            {/if}
            {if in_array($bid_open.status, array('carryout', 'after'))}
              <th class="created_at_min">入札日時</th>
              <th class="min_price border-start">落札金額</th>
              <th class="same_count">入札<br />件数</th>
            {/if}
          </tr>
        {/if}

        <tr {if !empty($mw.deleted_at)} class="deleted" {/if}>
          <td class="list_no fs-5 text-center">{$mw.list_no}</td>
          <td class="img">
            {if !empty($mw.top_img)}
              <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$mw.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$mw.top_img}" alt='PDF' /></noscript>
              </a>
            {/if}
          </td>
          {*
          <td class="name">
            <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">{$mw.name}</a>
          </td>
          <td class="maker">{$mw.maker}</td>
          <td class="model">{$mw.model}</td>
          *}
          <td class="full_name_02">
            <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">{$mw.name} {$mw.maker} {$mw.model}</a>
          </td>
          <td class="year">{$mw.year}</td>

          <td class="company">
            {if !empty($mw.company)}
              <a href="company_detail.php?c={$mw.company_id}" target="_blank">
                {'/(株式|有限|合.)会社/'|preg_replace:'':$mw.company}
              </a>
            {/if}
          </td>

          <td class="min_price text-right">{$mw.min_price|number_format}円</td>

          <td class="addr_1">{$mw.addr1}</td>

          {if $bid_open.status == 'bid'}
            <td class="created_at">{$mw.created_at|date_format:'%m/%d %H:%M:%S'}</td>

            <td class='delete text-center'>
              {if !empty($mw.deleted_at)}
                取消済
              {else}
                <form method="post" action="/mypage/my_bid_watches/delete_do.php">
                  <input type="hidden" name="id" value="{$mw.bid_machine_id}" />
                  <input type="hidden" name="o" value="{$bid_open.id}" />

                  <button class="delete btn btn-outline-warning" value="{$mw.bid_machine_id}">
                    <i class="far fa-star"></i> 解除
                  </button>
                </form>
              {/if}
            </td>
          {/if}

          {if in_array($bid_open.status, array('carryout', 'after'))}
            <td class="created_at_min">{$mw.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
            <td class="min_price border-start">
              {if !empty($bids_result[$mw.bid_machine_id])}
                {$bids_result[$mw.bid_machine_id].amount|number_format}円
                {if $bids_result[$mw.bid_machine_id].same_count > 1}
                  <br />
                  (同額:{$bids_result[$mw.bid_machine_id].same_count})
                {/if}
              {/if}
            </td>
            <td class="same_count">
              {if !empty($bids_count[$mw.bid_machine_id])}
                {$bids_count[$mw.bid_machine_id]|number_format}
              {/if}
            </td>
          {/if}
        </tr>
      {/foreach}
    </table>
  </div>

  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/bid_door.php?o={$bid_open.id}" class="btn btn-outline-secondary" target="_blank">
      <i class="fas fa-magnifying-glass"></i> 商品をさがす - Web入札会トップページ
    </a>
    <a href="/mypage/" class="btn btn-outline-secondary">
      <i class="fas fa-house"></i> マイページ トップに戻る
    </a>
  </div>
{/block}