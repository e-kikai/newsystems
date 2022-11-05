{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css?4" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 削除処理 ///
        $('button.delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          var data = {
            'machine_id': $.trim($_self.val()),
          }

          // // 入力のチェック
          // var e = '';

          // // エラー表示
          // if (e != '') { alert(e); return false; }

          // 送信確認
          var mes = "出品番号 : " + $_parent.find('td.list_no').text() + "\n";
          mes += $.trim($_parent.find('td.name').text()) + ' ';
          mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n\n";
          mes += "この入札会商品を削除します。よろしいですか。";
          if (!confirm(mes)) { return false; }

          $_self.attr('disabled', 'disabled');

          // 送信処理
          $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'delete',
            'data': data,
          }, function(res) {
            // 結果コールバック
            if (res != 'success') {
              $_self.removeAttr('disabled');
              alert(res);
              return false;
            }

            alert('削除が完了しました');
            $_parent.remove();
            return false;
          }, 'text');

          return false;
        });

        /// キャンセル解除(再出品)処理 ///
        $('button.cancel_delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          var data = {
            'id': $.trim($_self.val()),
          }

          // 送信確認
          var mes = "出品番号 : " + $_parent.find('td.list_no').text() + "\n";
          mes += $.trim($_parent.find('td.name').text()) + ' ';
          mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n\n";

          mes += "<キャンセル理由>\n" + $_parent.find('input.cancel_comment').val() + "\n\n";

          mes += "この入札会商品のキャンセルを解除して、再出品します。よろしいですか。";
          if (!confirm(mes)) { return false; }

          $_self.attr('disabled', 'disabled');

          // 送信処理
          $.post('/admin/ajax/bid_cancel.php', {
            'target': 'member',
            'action': 'delete',
            'data': data,
          }, function(res) {
            // 結果コールバック
            if (res != 'success') {
              $_self.removeAttr('disabled');
              alert(res);
              return false;
            }

            alert('再出品が完了しました');
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

  {if empty($bidMachineList)}
    <div class="error_mes">入札会に登録している商品情報はありません</div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  {if in_array($bidOpen.status, array('entry'))}
    <div>
      <a href="/admin/bid_machine_form.php?o={$bidOpenId}">新規商品登録</a> |
      <a href="/admin/bid_machine2machine.php?o={$bidOpenId}">在庫機械から出品</a>
    </div>
  {/if}

  <div class="table_area">
    {foreach $bidMachineList as $m}
      {if $m@first}
        <table class="machines list">
          <tr>
            <th class="img"></th>
            <th class="list_no">出品番号</th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            {if in_array($bidOpen.status, array('entry', 'margin', 'bid'))}
              <th class="year">年式</th>
              <th class="location">在庫場所</th>
            {/if}
            <th class="min_price">最低入札金額</th>

            {* キャンセル対応 *}
            {if in_array($bidOpen.status, array('margin', 'bid'))}
              <th class="cancel">キャンセル</th>
            {/if}

            {if $bidOpen.status == 'entry' || (in_array($bidOpen.status, array('margin', 'bid')) && Auth::check('system'))}
              <th class="delete">削除</th>
            {/if}

            {if in_array($bidOpen.status, array('carryout', 'after'))}
              {if Companies::checkRank($rank, 'A会員')}
                <th class="b2m">在庫に<br />登録</th>
              {/if}

              {* ユーザ入札対応 *}
              {if $bidOpen.user_bid_date < $smarty.const.BID_USER_START_DATE}
                <th class="company sepa2">落札会社</th>
                <th class="min_price">落札金額</th>
                <th class="min_price">デメ半<br />({$bidOpen.deme}%)</th>
                <th class="min_price">事務局<br />手数料</th>
                <th class="min_price">落札会社<br />手数料</th>
                <th class="min_price sepa">支払金額</th>
              {else}
                <th class="company sepa2">落札ユーザ</th>
                <th class="min_price">落札金額</th>
                <th class="b2m">取引</th>
              {/if}

            {/if}
          </tr>
        {/if}

        <tr {if $m.canceled_at != null}class="canceled" {/if}>
          <td class="img">
            {if !empty($m.top_img)}
              <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
              <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
            {/if}
          </td>
          <td class="list_no">{$m.list_no}</td>
          <td class="name">
            {if $bidOpen.status == 'entry' || (in_array($bidOpen.status, array('margin', 'bid')) && Auth::check('system'))}
              <a href="/admin/bid_machine_form.php?m={$m.id}">{$m.name}</a>
            {else}
              <a href="/admin/bid_detail.php?m={$m.id}">{$m.name}</a>
            {/if}
          </td>
          <td class="maker">{$m.maker}</td>
          <td class="model">{$m.model}</td>
          {if in_array($bidOpen.status, array('entry', 'margin', 'bid'))}
            <td class="year">{$m.year}</td>
            <td class="location">{$m.addr1}<br />({$m.location})</td>
          {/if}

          <td class="min_price">{$m.min_price|number_format}円</td>

          {* キャンセル対応 *}
          {if in_array($bidOpen.status, array('margin', 'bid'))}
            <td class="cancel">
              {if $m.canceled_at == null}
                <a href="/admin/bid_machine_cancel_form.php?m={$m.id}" class="cancel button">
                  <i class="fas fa-store-slash"></i> キャンセル
                </a>
              {else}
                <div>キャンセル済</div>
                <input type="hidden" name="cancel_comment" class="cancel_comment" value="{$m.cancel_comment}" />
                <button class="cancel_delete" value="{$m.id}"><i class="fas fa-store"></i> 再出品</button>
              {/if}
            </td>
          {/if}

          {if $bidOpen.status == 'entry' || (in_array($bidOpen.status, array('margin', 'bid')) && Auth::check('system'))}
            <td class='delete'>
              <button class="delete" value="{$m.id}">✕ 削除</button>
            </td>
          {/if}
          {if in_array($bidOpen.status, array('carryout', 'after'))}

            {if Companies::checkRank($rank, 'A会員')}
              <td class="b2m">
                {if !empty($m.res_amount)}
                  落札
                {elseif !empty($m.machine_id)}
                  登録済
                {else}
                  <a href="/admin/machine_form.php?bid_machine_id={$m.id}" class="button">登録</a>
                {/if}
              </td>
            {/if}

            {* ユーザ入札対応 *}
            {if $bidOpen.user_bid_date < $smarty.const.BID_USER_START_DATE}
              <td class="min_price sepa2">
                {if !empty($m.res_company)}
                  <a href="company_detail.php?c={$m.res_company_id}" target="_blank">
                    {'/(株式|有限|合.)会社/'|preg_replace:'':$m.res_company}
                  </a>
                {/if}
              </td>
              <td class="min_price">{if !empty($m.res_amount)}{$m.res_amount|number_format}円{/if}</td>
              <td class="min_price">{if !empty($m.demeh)}{$m.demeh|number_format}円{/if}</td>
              <td class="min_price">{if !empty($m.jFee)}{$m.jFee|number_format}円<br />({$m.jPer|number_format}%){/if}</td>
              <td class="min_price">{if !empty($m.rFee)}{$m.rFee|number_format}円<br />({$m.rPer|number_format}%){/if}</td>
              <td class="min_price sepa">{if !empty($m.payment)}{$m.payment|number_format}円{/if}</td>
            {else}
              <td class="min_price sepa2">
              </td>
              <td class="min_price">円</td>
              <td class="b2m"><i class="fas fa-comments-dollar"></i> 取引</td>
            {/if}

          {/if}
        </tr>

        {if $m@last}
          {if $bidOpen.user_bid_date < $smarty.const.BID_USER_START_DATE}
            {if in_array($bidOpen.status, array('carryout', 'after')) && !empty($sum)}
              <tr>
                <td class="blank" colspan="11"></td>
                <th>支払合計金額</th>
                <td class="min_price sepa">{$sum|number_format}円</td>
              </tr>
              <tr>
                <td class="blank" colspan="11"></td>
                <th>消費税({$bidOpen.tax}%)</th>
                <td class="min_price sepa">{$tax|number_format}円</td>
              </tr>
              <tr>
                <td class="blank" colspan="11"></td>
                <th>差引出品支払額</th>
                <td class="min_price sepa">{$finalSum|number_format}円</td>
              </tr>
            {/if}
          {/if}
        </table>
      {/if}

    {/foreach}
  </div>
  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}