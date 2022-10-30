{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.cookie.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}contact.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
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
            'machineId': machineId,
            'companyId': companyId,
            'message': $.trim(message),
            'company': $.trim($('input.company').val()),
            'name': $.trim($('input.name').val()),
            'mail': $.trim($('input.mail').val()),
            'tel': $.trim($('input.tel').val()),
            'fax': $.trim($('input.fax').val()),
            'addr1': $.trim($('select.addr1').val()),
            'keystring': $.trim($('input.keystring').val()),
          }

          //// 入力のチェック ////
          var e = '';
          if (data.message == '') { e += "お問い合せ内容が選択されていません\n"; }
          // if (data.comapny == '')   { e += "会社名が入力されていません\n"; }
          if (data.name == '') { e += "お名前が入力されていません\n"; }
          // if (data.tel == '')       { e += "TELが入力されていません\n"; }
          if (data.mail == '') { e += "メールアドレスが入力されていません\n"; }
          // if (data.addr1 == '')     { e += "都道府県が入力されていません\n"; }
          if (data.keystring == '') { e += "セキュリティコードが入力されていません\n"; }

          //// 連絡先 ////
          var ret = '';
          /*
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
      */

          data.ret = $.trim(ret);

          // お知らせメール
          data.mailuser_flag = $('input.mailuser_flag').prop('checked') ? 1 : 0;

          //// エラー表示 ////
          if (e != '') { alert(e); return false; }

          // 送信確認
          if (!confirm('お問い合せを送信します。よろしいですか。')) { return false; }

          // test
          // alert(message); return false;

          $.post('/ajax/contact.php', {
            'target': 'machine',
            'action': 'sendMachine',
            'data': data
          }, function(res) {
            if (res != 'success') { alert(res); return false; }

            //// 入力値をcookieに格納 ////
            $.cookie('contact_name',     $('input.name').val(),     {expires: 31});
            // $.cookie('contact_company',  $('input.company').val(),  {expires: 31});
            $.cookie('contact_mail',     $('input.mail').val(),     {expires: 31});
            // $.cookie('contact_tel',      $('input.tel').val(),      {expires: 31});
            // $.cookie('contact_tel_time', $('input.tel_time').val(), {expires: 31});
            // $.cookie('contact_fax',      $('input.fax').val(),      {expires: 31});
            // $.cookie('addr1',            $('select.addr1').val(),   {expires: 31});

            // @ba-ta 20150103 完了URLに現在のURLを付加する
            location.href = '/contact_fin.php' + location.search; // お問い合せ完了
          });

          return false;
        });

        //// cookieから入力値を再利用 ////
        $('input.name').val($.cookie('contact_name'));
        // $('input.company').val($.cookie('contact_company'));
        $('input.mail').val($.cookie('contact_mail'));
        // $('input.tel').val($.cookie('contact_tel'));
        // $('input.tel_time').val($.cookie('contact_tel_time'));
        // $('input.fax').val($.cookie('contact_fax'));
        // $('select.addr1').val($.cookie('addr1'));

        //// 連絡先TELの表示 ////
        $('input.return_tel').change(function() {
          $(this).prop('checked') ? $('.append_tel').show() : $('.append_tel').hide();
        });

        //// 連絡先FAXの表示 ////
        $('input.return_fax').change(function() {
          $(this).prop('checked') ? $('.append_fax').show() : $('.append_fax').hide();
        });

        //// 入札希望金額の表示 ////
        /*
    $('input.select').change(function() {
        $(this).val() == '入札の依頼' ? $('.append_bid').show() : $('.append_bid').hide();
    });
    */

        //// seccodeの再表示 ///
        $('button.seccode_reflesh').click(function() {
          var date = new Date();
          $('.seccode').attr('src', $('.seccode').attr('src') + '&' + date.getTime());
          return false;
        });

        //// 数値のみに自動整形 ////
        $('input.number').change(function() {
          var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9.]/g, '');
          $(this).val(price ? parseInt(price) : '');
        });
      });
    </script>
    <style type="text/css">
    </style>

    <script>
      /**
   * Google Analytics(ABテスト用ハードコーディング)
   */
      var _gaq = _gaq || [];

      var pluginUrl =
        '//www.google-analytics.com/plugins/ga/inpage_linkid.js';
      _gaq.push(['_require', 'inpage_linkid', pluginUrl]);
      _gaq.push(['_setAccount', 'UA-36579656-2']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script');
        ga.type = 'text/javascript';
        ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ga, s);
      })();
    </script>
  {/literal}
{/block}

{block 'main'}

  <table class='contact'>
    <tr class='target'>
      {if !empty($machineList)}
        <th>お問い合わせ機械</th>
        <td>
          {foreach $machineList as $m}
            <input type='hidden' class='machine_id' name='m[]' value='{$m.id}' />
            <div class='name'>
              {$m@iteration}. <a href="machine_detail.php?m={$m.id}">{$m.name} {$m.maker} {$m.model}</a> →
              <a href="company_detail.php?c={$m.company_id}">{$m.company}</a>
            </div>
          {/foreach}
        </td>
      {elseif !empty($companyList)}
        <th>お問い合わせ先</th>
        <td class="contact_area">
          {foreach $companyList as $c}
            <input type='hidden' class='company_id' name='c[]' value='{$c.id}' />

            <div class='name'>
              {$c@iteration}. <a href="company_detail.php?c={$c.id}">{$c.company}</a><br />
              {if !empty($c.contact_tel)}<div class='tel'>TEL : {$c.contact_tel}</div>{/if}
              {if !empty($c.contact_fax)}<div class='fax'>FAX : {$c.contact_fax}</div>{/if}
            </div>
          {*
          {/if}
          *}
        {/foreach}
      </td>
    {else}
      <th>お問い合わせ先</th>
      <td>
        <div class='name'>全機連事務局へのお問い合わせ</div>
      </td>
    {/if}
  </tr>

  {if !empty($bidMachine)}
    <tr class='target'>
      <th>お問い合わせ商品</th>
      <td>
        出品番号 : {$bidMachine.list_no}<br />
        <a href="bid_detail.php?m={$bidMachine.id}">{$bidMachine.name} {$bidMachine.maker} {$bidMachine.model}</a>
        (<a href="bid_door.php?o={$bidOpen.id}">{$bidOpen.title}</a>)

        <input type='hidden' class='bid_machine' name='bm' value="出品番号 : {$bidMachine.list_no}
{$bidMachine.name} {$bidMachine.maker} {$bidMachine.model} ({$bidOpen.title})" />
      </td>
    </tr>
  {/if}

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

  {*
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
  *}

  <tr class='mess'>
    <th>お問い合わせ内容<span class='required'>(必須)</span></th>
    <td>
      {if !empty($machineList)}
        {foreach $select as $s}
          <div>
            <label><input type='checkbox' class='select' name='s' value='{$s}' /> {$s}</label>
          </div>
        {/foreach}
        その他問い合わせ（下記に記入してください）<br />
      {elseif empty($machineList) && empty($companyList)}
        <div><label>
            <input type="radio" name="s" class="select" value="機械を探しています" /> 機械を探しています
          </label></div>
        <div><label>
            <input type="radio" name="s" class="select" value="機械を売りたい" /> 機械を売りたい
          </label></div>
        <div><label>
            <input type="radio" name="s" class="select" value="全機連についての質問" /> 全機連についての質問
          </label></div>
        <div><label>
            <input type="radio" name="s" class="select" value="" checked /> その他の質問・要望
          </label></div>
      {*
      {elseif !empty($bidFlag)}
      *}
      {elseif !empty($bidMachine) && $bidMachine.company_id == $companyList[0].id}
        <div>
          <label>
            <input type="checkbox" name="s" class="select bid_input" value="この商品への入札を依頼したい" />
            この商品への入札を依頼したい
          </label>
        </div>
        <div>
          <label>
            <input type="checkbox" name="s" class="select bid_input" value="この商品の状態を知りたい" />
            この商品の状態を知りたい
          </label>
        </div>
        <div>
          <label>
            <input type="checkbox" name="s" class="select bid_input" value="送料を知りたい" />
            送料を知りたい (↓に送付先住所を記入してください)
          </label>
        </div>
        <div>
          <label>
            <input type="checkbox" name="s" class="select bid_input" value="商品を下見したい" />
            商品を下見したい
          </label>
        </div>
        <div>
          <label>
            <input type="checkbox" name="s" class="select bid_input" value="試運転は可能ですか" />
            試運転は可能ですか
          </label>
        </div>


      {elseif !empty($bidMachine) && $bidMachine.company_id != $companyList[0].id}
        <div>
          <label>
            <input type="radio" name="s" class="select bid_input" value="この商品への入札を依頼したい" checked />
            この商品への入札を依頼したい
          </label>
        </div>
        <div>
          <label>
            <input type="radio" name="s" class="select" value="入札商品についてのお問い合せ" />
            入札商品についてのお問い合せ
          </label>
        </div>

        <div><label>
            <input type="radio" name="s" class="select" value="" /> その他の質問・要望
          </label></div>

        <span class="required">※</span> 入札の依頼、商品へのお問い合せの際には「出品番号」をお伝え下さい。
      {/if}
      <textarea name='message'
        class='other_message'>{* {if !empty($bidMachineId)}Web入札会出品番号 : {$bidMachineId}{/if} *}</textarea>
    </td>
  </tr>

  {*
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
  *}

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

  {*
  <tr class='mail'>
    <th>マシンライフお知らせメール</th>
    <td class="mailuser">
      <label>
        <input type='checkbox' class='mailuser_flag' name='mailuser_flag' value="1" checked="checked"/>
        マシンライフからのお知らせメールを受信する
      </label>
    </td>
  </tr>
  *}
</table>

<div class='terms'>
  <h2>個人情報の取り扱いについて</h2>
  マシンライフでは、皆様からお預かりした個人情報をお問合せ先の会員会社に提供するとともに、<br />
  個人情報が特定できない形での統計データとして利用いたします。<br />
  必須項目に不備があった場合、機械業者からの連絡が受けられないことがあります。あらかじめご了承ください。
</div>

<button type='button' value='conf' name='submit' class='submit'>上記に同意の上、お問い合わせを送信</button>
{/block}