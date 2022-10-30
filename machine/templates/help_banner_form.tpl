{extends file='include/layout.tpl'}

{block name='header'}
<meta name="robots" content="noindex, nofollow" />
<link href="{$_conf.site_uri}{$_conf.css_dir}contact.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    $('button.submit').click(function() {
        //// 内容の整理 ////
        var message = '';
        var other = $.trim($('textarea.other_message').val());
        if (other != '') {
            message += "\n" + other;
        }

        var data = {
            'company'      : $.trim($('input.company').val()),
            'name'         : $.trim($('input.name').val()),
            'mail'         : $.trim($('input.mail').val()),
            'tel'          : $.trim($('input.tel').val()),
            'fax'          : '',
            'ret'          : '',
            'addr1'        : $.trim($('select.addr1').val()),

            'message'      : "広告バナー掲載のお申込み\n\n" +
                "サイトURI : " + $.trim($('input.uri').val()) + "\n" +
                "ご希望サービス : " + $.trim($('input.service:checked').val()) + "\n" +
                "バナー作成 : " + $.trim($('input.make_banner:checked').val()) + "\n" +
                "メール配信 : " + $.trim($('input.send_mail:checked').val()) + "\n\n" + $.trim(message),

            'keystring'    : $.trim($('input.keystring').val()),
            'mailuser_flag': 0,
        }

        //// 入力のチェック ////
        var e = '';
        if (data.message == '')   { e += "お問い合せ内容が選択されていません\n"; }
        if (data.company == '')   { e += "会社名が入力されていません\n"; }
        if (data.name == '')      { e += "担当者名が入力されていません\n"; }
        if (data.mail == '')      { e += "メールアドレスが入力されていません\n"; }

        if (data.addr1 == '')     { e += "都道府県が選択されていません\n"; }
        if (data.keystring == '') { e += "セキュリティコードが入力されていません\n"; }

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('お申込みを送信します。よろしいですか。')) { return false; }

        $.post('/ajax/contact.php', {
            'target': 'machine',
            'action': 'sendMachine',
            'data': data
        }, function(res) {
            if (res != 'success') { alert(res); return false; }

            // お問い合せ完了
            location.href = '/contact_fin.php';
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
<div>
  <span class='required'>(必須)</span>は必須項目です。
</div>

<table class='contact'>
  <tr class='company'>
    <th>会社名<span class='required'>(必須)</span></th>
    <td>
      <input type='text' name='company' class='company' id='company' value='' required />
    </td>
  </tr>

  <tr class='name'>
    <th>担当者名<span class='required'>(必須)</span></th>
    <td>
      <input type='text' name='name' class='name' id='name' value='' required />
    </td>
  </tr>

  <tr class='tel'>
    <th>TEL<span class='required'>(必須)</span></th>
    <td>
      <input type='text' name='tel' class='tel' id='tel' maxlength='12' value='' required />
    </td>
  </tr>

  <tr class='mail'>
    <th>メールアドレス<span class='required'>(必須)</span></th>
    <td>
      <input type='email' name='mail' class='mail' id='mail' value='' required />
    </td>
  </tr>

  <tr class='addr1'>
    <th>都道府県<span class='required'>(必須)</span></th>
    <td>
      <select name="addr1" class="addr1">
        <option value="">▼選択▼</option>
      {foreach $addr1List as $a}
        <option value="{$a.state}">{$a.state}</option>
      {/foreach}
      <option value="海外">海外</option>
      </select>
    </td>
  </tr>

  <tr class='uri'>
    <th>サイトURI</th>
    <td>
      <input type='text' name='uri' class='uri' id='uri' value='' />
    </td>
  </tr>

  <tr class='service'>
    <th>ご希望サービス<span class='required'>(必須)</span></th>
    <td>
      <label><input type='radio' class='service' name='service' value='大バナー掲載' checked /> 大バナー掲載</label>
      <label><input type='radio' class='service' name='service' value='小バナー掲載' /> 小バナー掲載</label>
      <label><input type='radio' class='service' name='service' value='入札会バナー掲載' /> 入札会バナー掲載</label>
      <label><input type='radio' class='service' name='service' value='入札会バナー掲載 + 入札会ご案内ページ作成' /> 入札会バナー掲載 + 入札会ご案内ページ作成</label>
    </td>
  </tr>

  <tr class='make_banner'>
    <th>バナー作成<span class='required'>(必須)</span></th>
    <td>
      <label><input type='radio' class='make_banner' name='make_banner' value='希望する' checked /> 希望する</label>
      <label><input type='radio' class='make_banner' name='make_banner' value='希望しない' /> 希望しない</label>
    </td>
  </tr>

  <tr class='send_mail'>
    <th>メール配信<span class='required'>(必須)</span></th>
    <td>
      <label><input type='radio' class='send_mail' name='send_mail' value='希望する' checked /> 希望する</label>
      <label><input type='radio' class='send_mail' name='send_mail' value='希望しない' /> 希望しない</label>
    </td>
  </tr>

  <tr class='mess'>
    <th>お問い合わせ</th>
    <td>
      <textarea name='message' class='other_message'></textarea>
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

<button type='button' value='conf' name='submit' class='submit'>上記に同意の上、お申込みを送信</button>
{/block}
