{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {

        /// 自動入札の入札取消処理 ///
        $('button.auto_bid_delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          var data = {'id': $.trim($_self.val())}

          // 送信確認
          var mes = "出品番号 : " + $_parent.find('td.list_no').text() + "\n";
          mes += $.trim($_parent.find('td.name').text()) + ' ';
          mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n\n";

          mes += "この自動入札での入札を取消します。よろしいですか。";

          if (!confirm(mes)) { return false; }

          $_self.attr('disabled', 'disabled');

          // 送信処理
          $.post('/admin/ajax/auto_bid_bid.php', {
            'target': 'member',
            'action': 'delete',
            'data': data,
          }, function(res) { // 結果コールバック
            if (res != 'success') {
              $_self.removeAttr('disabled');
              alert(res);
              return false;
            }

            alert('自動入札の入札を取消しました。');
            location.reload();
            return false;
          }, 'text');

          return false;
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
            <th class="uniq_account">入札ユーザ<br />アカウント</th>
            <th class="min_price">最低入札金額</th>
            <th class="min_price">入札金額</th>
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
          <td class="model">{$bb.model} {$bb.id}</td>
          <td class="uniq_account">
            {if $bb.my_user_id == MyUser::SYSTEM_MY_USER_ID}
              <span class="fst-italic text-danger">自動入札</span><br />
              <button class="auto_bid_delete" value="{$bb.id}">✕ 取消</button>
            {else}
              {$bb.uniq_account}
            {/if}
          </td>
          <td class="min_price">{$bb.min_price|number_format}円</td>
          <td class="min_price">{$bb.amount|number_format}円</td>
          <td class="created_at">{$bb.created_at|date_format:'%Y/%m/%d %H:%M'}</td>

          {if in_array($bid_open.status, array('carryout', 'after'))}
            <td class="min_price sepa2">
              {$bids_result[$bb.bid_machine_id].company} {$bids_result[$bb.bid_machine_id].name}
            </td>
            <td class="min_price">
              {if !empty($bids_result[$bb.bid_machine_id].amount)}
                {$bids_result[$bb.bid_machine_id].amount|number_format}円
              {/if}
            </td>

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

          {/if}
        </tr>
      {/foreach}
    </table>
  </div>
{/block}