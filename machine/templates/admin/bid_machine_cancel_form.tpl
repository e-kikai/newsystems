{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 処理 ///
        $('button.submit').click(function() {
          var data = {
            'id': $.trim($('input.bid_machine_id').val()),
            'cancels': {
              'cancel_comment': $.trim($('textarea.cancel_comment').val()),
            }
          };

          /// 入力のチェック ///
          var e = '';
          $('textarea[required]').each(function() {
            if ($(this).val() == '') {
              e += "必須項目が入力されていません\n\n";
              return false;
            }
          });

          /// エラー表示 ///
          if (e != '') { alert(e); return false; }

          // 送信確認
          if (!confirm('該当商品を出品キャンセルします。よろしいですか。')) { return false; }

          $('button.submit').attr('disabled', 'disabled').text('キャンセル処理中、終了までそのままお待ち下さい');

          $.post('/admin/ajax/bid_cancel.php', {
            'target': 'member',
            'action': 'set',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $('button.submit').removeAttr('disabled').text('出品キャンセルする');
              alert(res);
              return false;
            }

            // 登録完了
            alert('キャンセル処理が完了しました');
            location.href = '/admin/bid_machine_list.php?o=' + $('input.bid_open_id').val();
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
  <table class="machine form">
    <input type="hidden" class="bid_machine_id" value="{$machine.id}" />
    <input type="hidden" class="bid_open_id" value="{$machine.bid_open_id}" />

    <tr>
      <th>出品番号</th>
      <td class="list_no">{$machine.list_no}</td>
    </tr>

    <tr class="">
      <th>商品名</th>
      <td>{$machine.name} {$machine.maker} {$machine.model}</td>
    </tr>

    <tr class="">
      <th>最低入札価格</th>
      <td>{$machine.min_price|number_format}円</td>
    </tr>

    <tr class=" cancel">
      <th>キャンセル理由<span class="required">(必須)</span></th>
      <td>
        <textarea name=" cancel_comment" class="cancel_comment" required="required"
          placeholder="キャンセルする理由を記入してください。">{$machine.cancel_comment}</textarea>
      </td>
    </tr>
  </table>

  <div class="form_comment">
    <ul>
      <li>
        キャンセルすると、キャンセル理由をすでに入札・ウォッチ登録されているユーザに通知します。<br />
        なので、ユーザにわかりやすいように記入をお願いいたします。
      </li>
      <li>キャンセルした商品について、「キャンセル解除」することもできます。</li>
    </ul>
  </div>

  <button type="button" class="submit"><i class="fas fa-store-slash"></i> 出品キャンセルする</button>
{/block}