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
    <style type="text/css"></style>
  {/literal}
{/block}

{block 'main'}

  {if $my_bid_bids}
    <div class="error_mes">まだ、入札情報がありません。</div>
  {/if}

  <div class="table_area">
    {foreach $my_bid_bids as $b}
      <table class="machines list">
        {if $b@first}
          <tr>
            <th class="list_no">出品番号</th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            <th class="company">出品会社</th>
            <th class="min_price">最低入札金額</th>
            <th class="min_price">入札金額</th>
            <th class="comment">備考欄</th>
            <th class="created_at">入札日時</th>
            {if $bidOpen.status == 'bid'}
              <th class="delete">取消</th>
            {/if}
            {if in_array($bidOpen.status, array('carryout', 'after'))}
              <th class="min_price sepa2">落札金額</th>
              <th class="res">結果</th>
            {/if}
          </tr>
        {/if}

        <tr {if !empty($b.deleted_at)} class="deleted" {/if}>
          <td class="list_no">{$b.list_no}</td>
          <td class="name">
            <a href="/admin/bid_detail.php?m={$b.bid_machine_id}" target="_blank">{$b.name}</a>
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
          {/if}
        </tr>
      </table>

    {/foreach}
  </div>
{/block}