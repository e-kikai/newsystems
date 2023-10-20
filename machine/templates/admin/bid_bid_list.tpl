{extends file='include/layout.tpl'}

{block 'header'}
  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        /// 削除処理 ///
        $('button.delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');
          var data = {
            'id': $.trim($_self.val()),
          }

          /// 入力のチェック ///
          var e = '';

          // エラー表示
          if (e != '') { alert(e); return false; }

          // 送信確認
          if (!confirm($.trim($_parent.find('td.name').text()) + "\nこの入札を取り消します。よろしいですか。")) { return false; }

          $_self.attr('disabled', 'disabled');

          $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'bidDelete',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $_self.removeAttr('disabled');
              alert(res);
              return false;
            }

            // 登録完了
            alert($.trim($_parent.find('td.name').text()) + "\nの取り消し処理が完了しました");
            $_parent.remove();
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

  {if empty($bidBidList)}
    <div class="error_mes">入札情報がありません</div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  <div class="table_area">
    {foreach $bidBidList as $b}
      {if $b@first}
        <table class="machines list">
          <tr>
            <th class="list_no">出品番号</th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            <th class="company">出品会社</th>
            <th class="min_price">最低入札金額</th>
            <th class="min_price">入札金額</th>
            <th class="charge">担当者</th>
            <th class="comment">備考欄</th>
            <th class="created_at">入札日時</th>
            {if $bidOpen.status == 'bid'}
              <th class="delete">取消</th>
            {/if}
            {if in_array($bidOpen.status, array('carryout', 'after'))}
              {*
        <th class="company">落札会社</th>
        *}
              <th class="min_price sepa2">落札金額</th>
              <th class="res">結果</th>
              <th class="min_price">デメ半<br />({$bidOpen.deme}%)</th>
              <th class="min_price">落札会社<br />手数料</th>
              <th class="min_price sepa">請求金額</th>
            {/if}
          </tr>
        {/if}

        <tr {if !empty($b.deleted_at)} class="deleted" {/if}>
          <td class="list_no">{$b.list_no}</td>
          <td class="name">
            {* <a href="/admin/bid_detail.php?m={$b.bid_machine_id}" target="_blank">{$b.name}</a> *}
            <a href="/bid_detail.php?m={$b.bid_machine_id}" target="_blank">{$b.name}</a>
          </td>
          <td class="maker">{$b.maker}</td>
          <td class="model">{$b.model}</td>
          <td class="company">
            {if !empty($b.company)}
              <a href="company_detail.php?c={$b.company_id}" target="_blank">
                {'/(株式|有限|合.)会社/'|preg_replace:'':$b.company}
              </a>
            {/if}
          </td>
          <td class="min_price">{$b.min_price|number_format}円</td>
          <td class="min_price">{$b.amount|number_format}円</td>
          <td class="charge">{$b.charge}</td>
          <td class="comment">{$b.comment}</td>
          <td class="created_at">{$b.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
          {if $bidOpen.status == 'bid'}
            <td class='delete'>
              {if !empty($b.deleted_at)}
                取消済
              {else}
                <button class="delete" value="{$b.id}">取消</button>
              {/if}
            </td>
          {/if}
          {if in_array($bidOpen.status, array('carryout', 'after'))}
            <td class="min_price sepa2">
              {if !empty($b.res_amount)}{$b.res_amount|number_format}円{/if}
              {if $b.same_count > 1}(同額札有){/if}
            </td>
            <td class="same_count">
              {if $b.res}<span class="bid_true">◯</span>{else}<span class="bid_false">×</span>{/if}
            </td>
            <td class="min_price">{if !empty($b.demeh)}{$b.demeh|number_format}円{/if}</td>
            <td class="min_price">{if !empty($b.rFee)}{$b.rFee|number_format}円<br />({$b.rPer|number_format}%){/if}</td>
            <td class="min_price sepa">{if !empty($b.billing)}{$b.billing|number_format}円{/if}</td>
          {/if}
        </tr>

        {if $b@last}
          {if in_array($bidOpen.status, array('carryout', 'after')) && !empty($sum)}
            <tr>
              <td class="blank" colspan="13"></td>
              <th>請求合計金額</th>
              <td class="min_price sepa">{$sum|number_format}円</td>
            </tr>
            <tr>
              <td class="blank" colspan="13"></td>
              <th>消費税({$bidOpen.tax}%)</th>
              <td class="min_price sepa">{$tax|number_format}円</td>
            </tr>
            <tr>
              <td class="blank" colspan="13"></td>
              <th>差引落札請求額</th>
              <td class="min_price sepa">{$finalSum|number_format}円</td>
            </tr>
          {/if}
        </table>
      {/if}
    {/foreach}
  </div>
  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}