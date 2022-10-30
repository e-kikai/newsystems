{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}contact.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        $('button.submit').click(function() {
            //// 内容の整理 ////
            // メールアドレス
            var mail = mb_convert_kana($.trim($('input.mail').val()), 'KVrn');

            var data = {
              'mail': $.trim($('input.mail').val()),
              'keystring': $.trim($('input.keystring').val())
            }

            //// 入力のチェック ////
            var e = '';
            if (data.mail == '') { e += "メールアドレスが入力されていません\n"; }
            if (!data.mail.match(/^[A-Za-z0-9]+[\w-]+@[\w\.-]+\.\w{2,}$/)) {
            e += "メールアドレス正しくありません\n";
          }
          if (data.keystring == '') { e += "セキュリティコードが入力されていません\n"; }

          //// エラー表示 ////
          if (e != '') { alert(e); return false; }

          // 送信確認
          if (!confirm('配信停止情報を送信します。よろしいですか。')) { return false; }

          $('button.submit').attr('disabled', 'disabled').text('配信停止処理中、終了までそのままお待ち下さい');

          $.post('/ajax/mailuser.php', {
            'target': 'machine',
            'action': 'unsend',
            'data': data
          }, function(res) {
            if (res != 'success') {
              $('button.submit').removeAttr('disabled').text('上記に同意の上、配信停止情報送信');
              alert(res);
              return false;
            }

            alert('配信停止処理が完了しました')

            // お問い合せ完了
            location.href = '/';
            return false;
          });

          return false;
        });

      //// seccodeの再表示 ///
      $('button.seccode_reflesh').click(function() {
        var date = new Date();
        $('.seccode').attr('src', $('.seccode').attr('src') + '&' + date.getTime());
        return false;
      });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <form action='contact.php' method='post'>

    <div>
      <span class='required'>(必須)</span>は必須項目です。
    </div>

    <table class='contact'>
      <tr class='mail'>
        <th>メールアドレス<span class='required'>(必須)</span></th>
        <td>
          <input type='email' name='mail' class='mail' id='mail' value='' required />
        </td>
      </tr>
      <tr class='mail'>
        <th>セキュリティコード<span class='required'>(必須)</span></th>
        <td>
          <div class="seccode_area">
            <img class="seccode" src="/ajax/kcaptcha/index.php?{session_name()}={session_id()}">
            <button class="seccode_reflesh">再表示</button>
          </div>
          画像に書かれているコードを半角数字で入力してください<br />
          <input type='text' name='keystring' class='keystring' id='keystring' value='' required />
        </td>
      </tr>
    </table>

    <div class='terms'>
      個人情報の取り扱いについて<br />
      このサービスでは皆様からお預かりした個人情報を問合せ先機械業者に提供するとともに、個人情報が特定できない形での統計データとして利用いたします。<br />
      必須項目に不備があった場合、機械業者からの連絡が受けられないことがあります。あらかじめご了承ください。
    </div>

    <button type='submit' value='conf' name='submit' class='submit'>上記に同意の上、配信停止情報送信</button>
{/block}