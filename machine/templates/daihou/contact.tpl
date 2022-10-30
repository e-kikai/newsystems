{extends file='daihou/layout/layout.tpl'}


{block 'header'}

{literal}
<script type="text/javascript">
$(function() {
    // seccodeの再表示 ///
    $('button.seccode_reflesh').click(function() {
        var date = new Date();
        $('.seccode').attr('src', $('.seccode').attr('src') + '&' + date.getTime());
        return false;
    });

    $('button.submit').click(function() {
        //// 内容の整理 ////
        var message = '';

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

        var data = {
            'machineId'    : machineId,

            'message'   : $.trim(message),
            'company'   : $.trim($('input.company').val()),
            'name'      : $.trim($('input.name').val()),
            'mail'      : $.trim($('input.mail').val()),
            'tel'       : $.trim($('input.tel').val()),
            'fax'       : $.trim($('input.fax').val()),
            'addr1'     : $.trim($('select.addr1').val()),
            'keystring' : $.trim($('input.keystring').val())
        }

        // console.log(data);

        //// 入力のチェック ////
        var e = '';
        if (data.message == '')   { e += "お問い合せ内容が選択されていません\n"; }
        if (data.comapny == '')   { e += "会社名が入力されていません\n"; }
        // if (data.name == '')      { e += "お名前が入力されていません\n"; }
        // if (data.tel == '')       { e += "TELが入力されていません\n"; }
        if (data.mail == '')      { e += "メールアドレスが入力されていません\n"; }
        // if (data.addr1 == '')     { e += "都道府県が入力されていません\n"; }
        if (data.keystring == '') { e += "セキュリティコードが入力されていません\n"; }

        //// 20150226@ba-ta メールアドレスチェック ////
        // var mail_check = $('input.mail_check_1').val() + '@' + $('input.mail_check_2').val();
        // if (data.mail != mail_check) { e += "メールアドレスと確認用メールアドレスが違っています\n"; }

        //// 連絡先 ////
        var ret = '';
        // メール
        if ($('input.return_mail').prop('checked')) {
            ret += "メールで連絡を希望\n";
        }

        // TEL
        if ($('input.return_tel').prop('checked')) {
            // ret += "電話で連絡を希望 ご希望の時間帯:" + $.trim($('input.tel_time').val()) + "\n";
            ret += "電話で連絡を希望\n";
        }

        // FAX
        if ($('input.return_fax').prop('checked')) {
            // if ($.trim($('input.fax').val()) != '') {
            //     ret += "FAXで連絡を希望\n";
            // } else {
            //     e += "連絡先FAXが入力されていません\n";
            // }
            ret += "FAXで連絡を希望\n";
        }

        data.ret = $.trim(ret);

        // お知らせメール
        // data.mailuser_flag = $('input.mailuser_flag').prop('checked') ? 1 : 0;

        //// エラー表示 ////
        if (e != '') {
            alert(e);
            // sendEvent('form_error');
            return false;
       }

        // 送信確認
        if (!confirm('お問い合せを送信します。よろしいですか。')) {
            // sendEvent('cancel');
            return false;
        }

        $.post('./ajax/contact.php', {
            'target': 'machine',
            'action': 'sendMachine',
            'data'  : data
        }, function(res) {
            if (res != 'success') {
                alert(res);
                // sendEvent('server_error');
                return false;
            }

            // //// 入力値をcookieに格納 ////
            // $.cookie('contact_name',     $('input.name').val(),     {expires: 31});
            // $.cookie('contact_company',  $('input.company').val(),  {expires: 31});
            // $.cookie('contact_mail',     $('input.mail').val(),     {expires: 31});
            // $.cookie('contact_tel',      $('input.tel').val(),      {expires: 31});
            // $.cookie('addr1',            $('select.addr1').val(),   {expires: 31});

            // window._loq.push(["tag_recording", "contact_submit", true]);

            // sendEvent('success');

            // @ba-ta 20150103 完了URLに現在のURLを付加する
            location.href = './contact_fin.php'; // お問い合せ完了
        });

        return false;
    });
});
</script>
<style type="text/css">


</style>
{/literal}
{/block}

{block 'main'}

    <h2 class="minititle"><i class="fas fa-phone-alt"></i>電話でお問い合わせ</h2>
    <p class="contact_message">
      <strong>
        <a href="tel:+81-6-6747-7222"><span itemprop="tel">{$company.contact_tel}</span></a>
      </strong><br />
      (受付時間 : 9:00 ～17:00)
    </p>

    <h2 class="minititle"><i class="fas fa-paper-plane"></i>フォームからお問い合わせ</h2>
    <p class="contact_message">
    以下のお問い合わせフォームに必要事項を明記の上、ご送信ください。<br />
    担当者が確認次第、折り返しご連絡を差し上げます。
    </p>

    <form class="contact">
      {if !empty($machineList)}
        <div class="row mb-3">
            <label class="col-sm-4">お問い合わせ機械</label>
            <div class="col-sm-8">
              {foreach $machineList as $m}
                <input type='hidden' class='machine_id' name='m[]' value='{$m.id}' />
                <div class='name'>
                  管理番号 {$m.no}. <a href="./detail.php?m={$m.id}">{$m.name} {$m.maker} {$m.model}</a>
                </div>
              {/foreach}
            </div>
        </div>
      {/if}

        <div class="row mb-3">
            <label for="inputPassword3" class="col-sm-4 col-form-label">メールドレス<span class="required">(必須)</span></label>
            <div class="col-sm-8">
            <input id="mail" type='email' name='mail' class='form-control mail' id='mail' value='' required />
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputcompany" class="col-sm-4 col-form-label">会社名<span class="required">(必須)</span></label>
            <div class="col-sm-8">
              <input id="company" type='text' name='company' class='form-control company' id='mail' value='' required />
            </div>
        </div>

        <div class="row mb-3">
            <label for="inputPassword3" class="col-sm-4 col-form-label">担当者</label>
            <div class="col-sm-8">
            <input id="name" type='text' name='name' class='form-control name' id='name' value='' />
            </div>
        </div>
        <div class="row mb-3">
            <label for="inputPassword3" class="col-sm-4 col-form-label">電話番号</label>
            <div class="col-sm-8">
            <input id="tel" type='tel' name='tel' class='form-control tel' id='tel' value='' />
            </div>
        </div>

        <div class="row mb-3">
            <label for="tel" class="col-sm-4 col-form-label">都道府県</label>
            <div class="col-sm-8">
              <select id="addr1" type='tel' name='addr1' class='form-control addr1'>
                <option value="">▼ 選択 ▼</option>
                {foreach $addr1List as $a}
                    <option value="{$a.state}">{$a.state}</option>
                {/foreach}
                <option value="海外">海外</option>
              </select>
            </div>
        </div>

        <div class="row mb-3">
            <label for="inputPassword3" class="col-sm-4 col-form-label">お問い合わせ内容<span class="required">(必須)</span></label>
            <div class="col-sm-8">
                {if !empty($machineList)}
                    {foreach $select as $s}
                    <div>
                      <label class="form-check-label"><input type='checkbox' class='form-check-input' name='s' value='{$s}'/> {$s}</label>
                    </div>
                    {/foreach}
                    その他問い合わせ（下記に記入してください）<br />
                {/if}

              <textarea name='message' class='form-control other_message'>{if !empty($mes)}{$mes}{/if}</textarea>
            </div>
        </div>

        <div class="row mb-3">
            <label for="tel" class="col-sm-4 col-form-label">希望連絡方法</label>
            <div class="col-sm-8">
                <div>
                  <label class="form-check-label">
                    <input type='checkbox' class='return_mail form-check-input' name='return_mail' value='mail' />
                    メールで連絡を希望
                  </label>
                </div>
                <div>
                  <label class="form-check-label">
                    <input type='checkbox' class='return_tel form-check-input' name='return_tel' value='TEL' />
                    電話で連絡を希望
                  </label>
                </div>

                <div>
                  <label class="form-check-label">
                    <input type='checkbox' class='return_fax form-check-input' name='return_fax' value='FAX' />
                    FAXで連絡を希望
                  </label>
                </div>
            </div>
        </div>


            <div class="row mb-3">
              <label for="keystring" class="col-sm-4 col-form-label">
                セキュリティコード<span class='required'>(必須)</span>
              </label>
              <div class="col-sm-8">
                <div class="seccode_area">
                    <img class="seccode" src="/ajax/kcaptcha/index.php?{session_name()}={session_id()}">
                    <button class="btn btn-secondary seccode_reflesh">再表示</button>
                </div>
                <div>画像に書かれているコードを半角数字で入力してください</div>
                <input type='text' name='keystring' class='keystring form-control' id='keystring' value='' required />
                <p>
                    <span class="required">※</span>
                    セキュリティコードが合わない場合「再表示」ボタンを押して再入力してください
                </p>
              </div>
            </div>

        <button type="button" class="btn btn-primary d-block mx-auto col-10 col-md-6 my-4 submit">
          <i class="fas fa-paper-plane"></i>お問い合わせを送信
        </button>
    </form>


{/block}