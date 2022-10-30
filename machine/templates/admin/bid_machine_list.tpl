{extends file='include/layout.tpl'}

{block 'header'}

  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        //// 削除処理 ////
        $('button.delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          var data = {
            'machine_id': $.trim($_self.val()),
          }

          //// 入力のチェック ////
          var e = '';

          // エラー表示
          if (e != '') { alert(e); return false; }

          // 送信確認
          var mes = $.trim($_parent.find('td.bid_machine_id').text()) + ' ' + $.trim($_parent.find('td.name')
          .text()) + ' ';
          mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n\n";
          mes += "この入札会商品を削除します。よろしいですか。";
          if (!confirm(mes)) { return false; }

          $_self.attr('disabled', 'disabled');

          $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'delete',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $_self.removeAttr('disabled');
              alert(res);
              return false;
            }

            // 登録完了
            alert('削除が完了しました');
            $_parent.remove();
            return false;
          }, 'text');

          return false;
        });

        //// テーブルスクロール ////
        $(window).resize(function() {
          $('div.table_area').css('height', $(window).height() - 240);
        }).triggerHandler('resize');

        $('div.table_area').scroll(function() {
          $(window).triggerHandler('scroll');
        });
      });
    </script>
    <style type="text/css">
      table.list .company {
        width: 80px;
      }
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

    {/if}
    <div class="table_area">
      {foreach $bidMachineList as $m}
        {if $m@first}
          <table class="machines list">
            <tr>
              <th class="img"></th>
              <th class="bid_machine_id">出品番号</th>
              <th class="name">機械名</th>
              <th class="maker">メーカー</th>
              <th class="model">型式</th>
              {if in_array($bidOpen.status, array('entry', 'margin', 'bid'))}
                <th class="year">年式</th>
                <th class="location">在庫場所</th>
              {/if}
              <th class="min_price">最低入札金額</th>

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
                <th class="company sepa2">落札会社</th>
                <th class="min_price">落札金額</th>
                <th class="min_price">デメ半<br />({$bidOpen.deme}%)</th>
                <th class="min_price">事務局<br />手数料</th>
                <th class="min_price">落札会社<br />手数料</th>
                <th class="min_price sepa">支払金額</th>

              {/if}
            </tr>
          {/if}

          <tr>
            <td class="img">
              {if !empty($m.top_img)}
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
              {/if}
            </td>
            <td class="bid_machine_id">{$m.list_no}</td>
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

            {if in_array($bidOpen.status, array('margin', 'bid'))}
              <td class="cancel"><button class="cancel" value="{$m.id}"><i class="fas store-slash"></i> キャンセル</button></td>
            {/if}

            {if $bidOpen.status == 'entry' || (in_array($bidOpen.status, array('margin', 'bid')) && Auth::check('system'))}
              <td class='delete'><button class="delete" value="{$m.id}">削除</button></td>
            {/if}
            {if in_array($bidOpen.status, array('carryout', 'after'))}

              {if Companies::checkRank($rank, 'A会員')}
                <td class="b2m">
                  {if !empty($m.res_amount)}
                    落札
                  {elseif !empty($m.machine_id)}
                    登録済
                  {else}
                    <a href="/admin/machine_form.php?bid_machine_id={$m.id}" class="button">登録</button>
                    {/if}
                </td>
              {/if}

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

            {/if}
          </tr>

          {if $m@last}
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
          </table>
        {/if}

      {/foreach}
    </div>
    {*** ページャ ***}
    {include file="include/pager.tpl"}

{/block}