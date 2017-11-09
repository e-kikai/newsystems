{extends file='include/layout.tpl'}

{block name='header'}
<meta name="robots" content="noindex, nofollow" />
<link href="{$_conf.site_uri}{$_conf.css_dir}contact.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.cookie.js"></script>
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
            'company': $.trim($('input.company').val()),
            'name': $.trim($('input.name').val()),
            'mail': $.trim($('input.mail').val()),
            'tel': $.trim($('input.tel').val()),
            'fax': '',
            'ret': '',
            'addr1': $.trim($('select.addr1').val()),
            
            'message': "[[Web入札会 参加申し込み]]\n\n" +
                "業種 : " + $.trim($('select.business').val()) + "\n" +
                "どんな機械をお探しですか？ : " + $.trim($('select.large_genre_id').val()) + ' ' + $.trim($('select.large_genre_id option:selected').text()) + "\n\n" +
                $.trim(message) + "\n\n" +
                'referer : ' + $.trim($('input.ref').val()),
            
            'keystring': $.trim($('input.keystring').val())
        }

        //// 入力のチェック ////
        var e = '';
        if (data.message == '')   { e += "内容がありません\n"; }
        if (data.company == '')   { e += "会社名が入力されていません\n"; }
        if (data.name == '')      { e += "担当者名が入力されていません\n"; }
        if (data.mail == '')      { e += "メールアドレスが入力されていません\n"; }

        if (data.addr1 == '')     { e += "都道府県が選択されていません\n"; }
        if ($.trim($('select.business').val()) == '')     { e += "業種が選択されていません\n"; }
        if ($.trim($('select.large_genre_id').val()) == '')     { e += "どんな機械をお探しですかが選択されていません\n"; }
        
        if (data.keystring == '') { e += "セキュリティコードが入力されていません\n"; }

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('Web入札会 参加申し込みを送信します。よろしいですか。')) { return false; }

        $.post('/ajax/contact.php', {
            'target': 'machine',
            'action': 'sendMachine',
            'data': data
        }, function(res) {
            if (res != 'success') { alert(res); return false; }
            
            //// 入力値をcookieに格納 ////
            $.cookie('contact_name', $('input.name').val(), {expires: 31});
            $.cookie('contact_company', $('input.company').val(), {expires: 31});
            $.cookie('contact_mail', $('input.mail').val(), {expires: 31});
            $.cookie('contact_tel', $('input.tel').val(), {expires: 31});
            $.cookie('addr1', $('select.addr1').val(), {expires: 31});

            // お問い合せ完了
            location.href = '/contact_fin.php';
            return false;
        });

        return false;
    });
    
    //// cookieから入力値を再利用 ////
    $('input.name').val($.cookie('contact_name'));
    $('input.company').val($.cookie('contact_company'));
    $('input.mail').val($.cookie('contact_mail'));
    $('input.tel').val($.cookie('contact_tel'));
    $('select.addr1').val($.cookie('addr1'));
    
    //// seccodeの再表示 ///
    $('button.seccode_reflesh').click(function() {
        var date = new Date();
        $('.seccode').attr('src', $('.seccode').attr('src') + '&' + date.getTime());
        return false;
    });
});
</script>
<style type="text/css">
img.step_img {
  display: block;
  margin: auto;
}
</style>
{/literal}
{/block}

{block 'main'}

<img src="imgs/bidlp_form_step.gif" class="step_img" />
<div>
  <span class='required'>(必須)</span>は必須項目です。
</div>

<input type="hidden" class="ref" value="{$ref}" />

<table class='contact'>
{*
  <tr class='company'>
    <th>入札会<span class='required'>(必須)</span></th>
    <td>
      {$bidOpen.title}
      <input type='hidden' name='bid_open_id' class='bid_open_id' value='{$bidOpenId}' required />
    </td>
  </tr>
*}

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
  
  <tr class='addr1'>
    <th>業種<span class='required'>(必須)</span></th>
    <td>
      <select name="business" class="business">
        <option value="">▼選択▼</option>
        <option value="製造業">製造業</option>
        <option value="第一次産業(水産・農林・鉱業)">第一次産業(水産・農林・鉱業)</option>
        <option value="建設業">建設業</option>
        <option value="卸売業">卸売業</option>
        <option value="小売業">小売業</option>
        <option value="サービス業">サービス業</option>
        <option value="その他">その他</option>
      </select>
    </td>
  </tr>
  
  <tr class='service'>
    <th>どんな機械をお探しですが？<br /><span class='required'>(必須)</span></th>
    <td>
      <select name="large_genre_id" class="large_genre_id">
        {foreach $largeGenreList as $l}
          {if $l@first}<optgroup label="NC工作機械">
          {elseif $l.id == 10}</optgroup><optgroup label="一般工作機械">
          {elseif $l.id == 9}</optgroup><optgroup label="鍛圧機械">
          {elseif $l.id == 19}</optgroup><optgroup label="鈑金機械">
          {elseif $l.id == 24}</optgroup><optgroup label="鉄骨加工機械">
          {elseif $l.id == 37}</optgroup><optgroup label="輸送・荷役機械">
          {elseif $l.id == 47}</optgroup><optgroup label="工作機械周辺機器">
          {elseif $l.id == 30}</optgroup><optgroup label="測定器・試験機">
          {elseif $l.id == 50}</optgroup><optgroup label="電気設備">
          {elseif $l.id == 54}</optgroup><optgroup label="鉄製造設備">
          {elseif $l.id == 32}</optgroup><optgroup label="その他機械">{/if}
          
          <option value="{$l.id}">
            {$l.large_genre}
          </option>
        {/foreach}
        </optgroup>
      </select>
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
  登録していただいたメールアドレスに、全機連事務局からWeb入札会のご案内などをお送りいたします。
  <br /><br />
  個人情報の取り扱いについて<br />
  このサービスでは皆様からお預かりした個人情報を問合せ先機械業者に提供するとともに、個人情報が特定できない形での統計データとして利用いたします。<br />
  必須項目に不備があった場合、機械業者からの連絡が受けられないことがあります。あらかじめご了承ください。
</div>

<button type='button' value='conf' name='submit' class='submit'>上記に同意の上、お申し込みを送信</button>
{/block}
