{extends file='companysite/layout.tpl'}

{block 'header'}
<meta name="description" content="" />
<meta name="keywords" content="中古機械" />

{literal}
<script type="text/JavaScript">
$(function() {
    $('button.submit').click(function() {
        //// 内容の整理 ////
        var message = '';
        
        // 入札商品を内容に追加
        $('input.bid_machine').each(function() {
            message += $(this).val() + "\n";
        });

        // 選択肢を内容に追加
        $('.select:checked').each(function() {
            message += $(this).val() + "\n";
        });

        var other = $.trim($('textarea.other_message').val());
        if (other != '') {
            message += "\n" + other;
        }

        var machineId = $('.machine_id').map(function() {
            return $(this).val();
        }).get();

        var companyId = $('input.company_id').map(function() {
            return $(this).val();
        }).get();

        var data = {
            'machineId' : machineId,
            'companyId' : companyId,
            'message'   : $.trim(message),
            'company'   : $.trim($('input.company').val()),
            'name'      : $.trim($('input.name').val()),
            'mail'      : $.trim($('input.mail').val()),
            'tel'       : $.trim($('input.tel').val()),
            'fax'       : $.trim($('input.fax').val()),
            'addr1'     : $.trim($('select.addr1').val()),
            'keystring' : $.trim($('input.keystring').val())
        }

        //// 入力のチェック ////
        var e = '';
        if (data.message == '')   { e += "お問い合せ内容が選択されていません\n"; }
        // if (data.comapny == '')   { e += "会社名が入力されていません\n"; }
        if (data.name == '')      { e += "お名前が入力されていません\n"; }
        // if (data.tel == '')       { e += "TELが入力されていません\n"; }
        if (data.mail == '')      { e += "メールアドレスが入力されていません\n"; }
        // if (data.addr1 == '')     { e += "都道府県が入力されていません\n"; }
        if (data.keystring == '') { e += "セキュリティコードが入力されていません\n"; }

        //// 連絡先 ////
        var ret = '';
        // メール
        if ($('input.return_mail').prop('checked')) {
            ret += "メールで連絡を希望\n";
        }

        // TEL
        if ($('input.return_tel').prop('checked')) {
            ret += "電話で連絡を希望 ご希望の時間帯:" + $.trim($('input.tel_time').val()) + "\n";
        }

        // FAX
        if ($('input.return_fax').prop('checked')) {
            if ($.trim($('input.fax').val()) != '') {
                ret += "FAXで連絡を希望\n";
            } else {
                e += "連絡先FAXが入力されていません\n";
            }
        }

        data.ret = $.trim(ret);

        // お知らせメール
        data.mailuser_flag = 0;

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('お問い合せを送信します。よろしいですか。')) { return false; }

        $.post('/ajax/contact.php', {
            'target': 'machine',
            'action': 'sendMachine',
            'data'  : data
        }, function(res) {
            if (res != 'success') { alert(res); return false; }

            //// 入力値をcookieに格納 ////
            $.cookie('contact_name', $('input.name').val(), {expires: 31});
            $.cookie('contact_company', $('input.company').val(), {expires: 31});
            $.cookie('contact_mail', $('input.mail').val(), {expires: 31});
            $.cookie('contact_tel', $('input.tel').val(), {expires: 31});
            $.cookie('contact_tel_time', $('input.tel_time').val(), {expires: 31});
            // $.cookie('contact_fax', $('input.fax').val(), {expires: 31});
            $.cookie('addr1', $('select.addr1').val(), {expires: 31});

            alert("お問い合わせありがとうございました。¥n" +
                "追ってシステムから、自動的にお問い合せ受け付け通知メールを送信いたします。");

            location.href = '/s/'; // お問い合せ完了
        });

        return false;
    });

    //// cookieから入力値を再利用 ////
    $('input.name').val($.cookie('contact_name'));
    $('input.company').val($.cookie('contact_company'));
    $('input.mail').val($.cookie('contact_mail'));
    $('input.tel').val($.cookie('contact_tel'));
    $('input.tel_time').val($.cookie('contact_tel_time'));
    $('input.fax').val($.cookie('contact_fax'));
    $('select.addr1').val($.cookie('addr1'));

    //// 連絡先TELの表示 ////
    $('input.return_tel').change(function() {
        $(this).prop('checked') ? $('.append_tel').show() : $('.append_tel').hide();
    });

    //// 連絡先FAXの表示 ////
    $('input.return_fax').change(function() {
        $(this).prop('checked') ? $('.append_fax').show() : $('.append_fax').hide();
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

<h1>お問い合せ</h1>

<h2>TEL・FAXでのお問い合せ</h2>
<div class="contact_area">
  <div class="tel">TEL {$site.contact_tel}</div>
  <div class="fax">FAX {$site.contact_fax}</div>
</div>

<h2>お問い合せフォーム</h2>
<table class='mysite contact'>
  <tr class='target'>
    {if !empty($machineList)}
      <th>お問い合わせ機械</th>
      <td>
        {foreach $machineList as $m}
          <input type='hidden' class='machine_id' name='m[]' value='{$m.id}' />
          <div class='name'>
            {$m@iteration}. <a href="machine_detail.php?m={$m.id}">{$m.no} : {$m.name} {$m.maker} {$m.model}</a>
          </div>
        {/foreach}
      </td>
    {/if}
  </tr>

  <tr class='mail'>
    <th>メールアドレス<span class='required'>(必須)</span></th>
    <td>
      <input type='email' name='mail' class='mail' id='mail' value='' required />
    </td>
  </tr>

  <tr class='name'>
    <th>お名前<span class='required'>(必須)</span></th>
    <td>
      <input type='text' name='name' class='name' id='name' value='' required />
    </td>
  </tr>

  <tr class='name'>
    <th>会社名</th>
    <td>
      <input type='text' name='company' class='company' id='company' value='' />
    </td>
  </tr>

  <tr class='tel'>
    <th>TEL</th>
    <td>
      <input type='text' name='tel' class='tel' id='tel' value='' />
    </td>
  </tr>

  <tr class='addr1'>
    <th>都道府県</th>
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

  <tr class='mess'>
    <th>お問い合わせ内容<br /><span class='required'>(必須)</span></th>
    <td>
      {if !empty($machineList)}
        <div>
          <label><input type='checkbox' class='select' name='s' value='この機械の状態を知りたい'/> この機械の状態を知りたい</label>
        </div>
        <div>
          <label><input type='checkbox' class='select' name='s' value='この機械の価格を知りたい'/> この機械の価格を知りたい</label>
        </div>
        <div>
          <label><input type='checkbox' class='select' name='s' value='送料を知りたい'/> 送料を知りたい</label>
        </div>
        <div>
          <label><input type='checkbox' class='select' name='s' value='現物を見たい'/> 現物を見たい</label>
        </div>
        <div>
          <label><input type='checkbox' class='select' name='s' value='試運転は可能ですか'/> 試運転は可能ですか</label>
        </div>
        その他問い合わせ（下記に記入してください）<br />
      {/if}
      <textarea name='message' class='other_message'></textarea>
    </td>
  </tr>

  <tr class='return'>
    <th>希望連絡方法</th>
    <td>
      <div>
        <label>
          <input type='checkbox' class='return_mail' name='return_mail' value='mail' />
          メールで連絡を希望
        </label>
      </div>
      <div>
        <label>
          <input type='checkbox' class='return_tel' name='return_tel' value='TEL' />
          電話で連絡を希望
        </label>
        <div class='append_tel'>
         <label>
           ご希望の時間帯
           <input type='text' name='tel_time' class='tel_time' value=''/>
         </label>
        </div>
      </div>
      <div>
        <label>
          <input type='checkbox' class='return_fax' name='return_fax' value='FAX' />
          FAXで連絡を希望
        </label>
        <div class='append_fax'>
         <label>
           連絡先FAX<span class='required'>(必須)</span>
           <input type='tel' class='fax' name='fax' maxlength='12' />
         </label>
        </div>
      </div>
    </td>
  </tr>
  
  <tr class='mail'>
    <th>セキュリティコード<br /><span class='required'>(必須)</span></th>
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

<button type='submit' value='conf' name='submit' class='submit'>上記に同意の上、お問い合わせを送信</button>
<br style="clear:both;" />

{/block}
