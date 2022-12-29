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
          mes += "\n入札金額 : " + $.trim($_parent.find('td.amount').text()) + "円";
          mes += "\n\nこの入札を取り消します。よろしいですか。"
          if (!confirm(mes)) { return false; }

          // $_self.attr('disabled', 'disabled');

          return ture;
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  {if empty(count($my_bid_bids))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-pen-to-square"></i> まだ、入札がありません。
    </div>
  {/if}

  <div class="table_area">
    <table class='table table-hover table-condensed table-striped'>

      {foreach $my_bid_bids as $bb}
        {if $bb@first}
          <tr>
            <th class="list_no">出品番号</th>
            <th class="img"></th>
            {*
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            *}
            <th class="full_name">機械名/メーカー/型式</th>
            <th class="company">出品会社</th>
            <th class="min_price">最低入札金額</th>
            <th class="amount">入札金額</th>
            <th class="comment">備考欄</th>
            {if $bid_open.status == 'bid'}
              <th class="created_at">入札日時</th>
              <th class="delete">取消</th>
            {/if}
            {if in_array($bid_open.status, array('carryout', 'after'))}
              <th class="created_at_min">入札日時</th>
              <th class="min_price border-start">落札金額</th>
              <th class="same_count">入札<br />件数</th>
              <th class="result">結果</th>
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
          {*
          <td class="name">
            <a href="/bid_detail.php?m={$bb.bid_machine_id}" target="_blank">{$bb.name}</a>
          </td>
          <td class="maker">{$bb.maker}</td>
          <td class="model">{$bb.model}</td>
          *}
          <td class="full_name">
            <a href="/bid_detail.php?m={$bb.bid_machine_id}" target="_blank">{$bb.name} {$bb.maker} {$bb.model}</a>
          </td>

          <td class="company">
            {if !empty($bb.company)}
              <a href="company_detail.php?c={$bb.company_id}" target="_blank">
                {'/(株式|有限|合.)会社/'|preg_replace:'':$bb.company}
              </a>
            {/if}
          </td>
          <td class="min_price">{$bb.min_price|number_format}円</td>
          <td class="amount">{$bb.amount|number_format}円</td>
          <td class="comment">{$bb.comment}</td>

          {if $bid_open.status == 'bid'}
            <td class="created_at">{$bb.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
            <td class='delete'>
              {if !empty($bb.deleted_at)}
                取消済
              {else}
                <form method="post" action="/mypage/my_bid_bids/delete_do.php">
                  <input type="hidden" name="id" value="{$bb.id}" />
                  <input type="hidden" name="o" value="{$bid_open.id}" />

                  <button class="delete btn btn-outline-danger" value="{$bb.bid_machine_id}">
                    <i class="fas fa-eraser"></i> 取消
                  </button>
                </form>
              {/if}
            </td>
          {/if}

          {if in_array($bid_open.status, array('carryout', 'after'))}
            <td class="created_at_min">{$bb.created_at|date_format:'%m/%d %H:%M:%S'}</td>

            <td class="min_price border-start">
              {if !empty($bids_result[$bb.bid_machine_id].amount)}
                {$bids_result[$bb.bid_machine_id].amount|number_format}円
              {/if}
              {if $bids_result[$bb.bid_machine_id].same_count > 1}
                <br />
                (同額:{$bids_result[$bb.bid_machine_id].same_count})
              {/if}
            </td>
            <td class="same_count">{$bids_count[$bb.bid_machine_id]|number_format}</td>

            <td class="result">
              {if $bids_result[$bb.bid_machine_id].my_user_id == $_my_user["id"]}
                <span class="bid_true">落札</span>
                <a href="mypage/my_bid_trades/show.php?m={$bb.bid_machine_id}" class="btn-xs btn btn-success btn-trade">
                  <i class="fas fa-comments-dollar"></i> 取引
                </a>
              {else}
                <span class="bid_false">×</span>
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
    <a href="/mypage/my_bid_watches.php?o={$bid_open.id}" class="btn btn-outline-secondary">
      <i class="fas fa-star"></i> ウォッチリストを見る
    </a>
    <a href="/mypage/" class="btn btn-outline-secondary">
      <i class="fas fa-house"></i> マイページ トップに戻る
    </a>
  </div>

{/block}