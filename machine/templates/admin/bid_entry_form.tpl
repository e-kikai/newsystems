{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        //// 処理 ////
        $('button.submit').click(function() {
          var data = {
            'bid_entries': {
              'officer': $.trim($('input.officer').val()),
              'bank': $.trim($('input.bank').val()),
              'branch': $.trim($('input.branch').val()),
              'type': $.trim($('input.type:checked').val()),
              'number': $.trim($('input.number').val()),
              'name': $.trim($('input.name').val()),
              'abbr': $.trim($('input.abbr').val()),
            }
          };

          //// 入力のチェック ////
          var e = '';
          $('input[required]').each(function() {
            if ($(this).val() == '') {
              e += "必須項目が入力されていません\n\n";
              return false;
            }
          });

          //// エラー表示 ////
          if (e != '') { alert(e); return false; }

          // 送信確認
          if (!confirm('入力した商品出品登録を保存します。よろしいですか。')) { return false; }

          $('button.submit').attr('disabled', 'disabled').text('保存処理中、終了までそのままお待ち下さい');

          $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'setBidEntry',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $('button.submit').removeAttr('disabled').text('商品出品登録');
              alert(res);
              return false;
            }

            // 登録完了
            alert('保存が完了しました');
            location.href = '/admin/';
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
  <div class="form_comment">
    <span class="alert">※</span>
    　項目名が<span class="required">(必須)</span>の項目は必須入力項目です。
  </div>

  <table class="machine form">
    <tr>
      <th>会社名</th>
      <td>{$company.company}</td>
    </tr>
    <tr class="zip">
      <th>〒</th>
      <td>{$company.zip}</td>
    </tr>

    <tr class="address">
      <th>住所</th>
      <td>{$company.addr1} {$company.addr2} {$company.addr3}</td>
    </tr>

    <tr class="tel">
      <th>TEL</th>
      <td>{$company.tel}</td>
    </tr>

    <tr class="fax">
      <th>FAX</th>
      <td>{$company.fax}</td>
    </tr>

    <tr class="officer">
      <th>出品担当者<span class="required">(必須)</span></th>
      <td>
        <input type="text" name="officer" class="officer" value="{$company.bid_entries.officer}" placeholder="入札会の出品担当者"
          required />
      </td>
    </tr>

    <tr class="bank">
      <th>銀行名<span class="required">(必須)</span></th>
      <td>
        <input type="text" name="bank" class="bank" value="{$company.bid_entries.bank}" placeholder="銀行名" required />
      </td>
    </tr>

    <tr class="branch">
      <th>支店名<span class="required">(必須)</span></th>
      <td>
        <input type="text" name="branch" class="branch" value="{$company.bid_entries.branch}" placeholder="支店名"
          required />
      </td>
    </tr>

    <tr class="type">
      <th>種類<span class="required">(必須)</span></th>
      <td>
        {if !empty($company.bid_entries.type)}{assign 'type' $company.bid_entries.type}{else}{assign 'type' 1}{/if}
        {html_radios name='type' class='type' options=['1' => '普通', '2' => '当座']
         selected=$type separator=' '}
      </td>
    </tr>

    <tr class="number">
      <th>口座番号<span class="required">(必須)</span></th>
      <td>
        <input type="text" name="number" class="number number" value="{$company.bid_entries.number}" placeholder="数値入力"
          required />
      </td>
    </tr>
    <tr class="name">
      <th>口座名義<span class="required">(必須)</span></th>
      <td>
        <input type="text" name="name" class="name" value="{$company.bid_entries.name}" placeholder="口座名称" required />
      </td>
    </tr>

    <tr class="abbr">
      <th>銀行振込略称</th>
      <td>
        <input type="text" name="abbr" class="abbr" value="{$company.bid_entries.abbr}" placeholder="銀行振込略称(カタカナを入力)" />
      </td>
    </tr>
  </table>

  <button type="button" class="submit">商品出品登録</button>
{/block}