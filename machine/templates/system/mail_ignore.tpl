{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        $('button.submit').click(function() {
          var data = {
            'mail_ignore': $.trim($('textarea#mail_ignore').val()),
          }

          //// 入力のチェック ////
          var e = '';
          if (data.subject == '') { e += "タイトルが入力されていません\n"; }
          if (data.message == '') { e += "内容が入力されていません\n"; }

          //// エラー表示 ////
          if (e != '') { alert(e); return false; }

          // 送信確認
          if (!confirm("非送信メールアドレス一覧を保存します。\nよろしいですか。")) { return false; }

          $('button.submit').attr('disabled', 'disabled').text('保存処理中、終了までそのままお待ち下さい');

          $.post('/system/ajax/mail.php', {
            'target': 'system',
            'action': 'setMailIgnore',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $('button.submit').removeAttr('disabled').text('非送信メールアドレス一覧を保存');
              alert(res);
              return false;
            }

            // 保存完了
            alert('非送信メールアドレス一覧を保存しました');
            location.href = '/system/';
            return false;
          });

          return false;
        });
      });
    </script>
    <style type="text/css">
      #mail_ignore {
        height: 400px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <table class="info form">
    <tr>
      <th>
        非送信メールアドレス一覧<br />
        <span class="required">(必須)</span>
      </th>
      <td>
        <span class="alert">※</span> 非送信メールアドレスを1行ずつ列挙して下さい。<br />
        <textarea name="mail_ignore" id="mail_ignore">{$mailIgnore}</textarea>
      </td>
    </tr>
  </table>

  <button type="button" name="submit" class="submit" value="member">非送信メールアドレス一覧を保存</button>
{/block}