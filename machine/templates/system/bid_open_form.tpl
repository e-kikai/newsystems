{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.ui.datepicker-ja.js"></script>

<script type="text/JavaScript">
{literal}
$(function() {
    //// datepicker ////
    $('input.date').datepicker({
        showAnim    : 'fadeIn',
        prevText    : '',
        nextText    : '',
        dateFormat  : 'yy/mm/dd',
        altFormat   : 'yy/mm/dd',
        changeMonth : true,
        appendText  : '',
        maxDate     : '',
        minDate     : ''
    });

    // 選択可能期間の設定
    $('input.date.entry_start').datepicker("option", 'onClose', function(selectedDate) {
        $('input.date.bid_start').datepicker( "option", "minDate", selectedDate);
    });

    $('input.date.bid_start').datepicker("option", 'onClose', function(selectedDate) {
        $('input.date.bid_end').datepicker( "option", "minDate", selectedDate);
    });
    $('input.date.bid_end').datepicker("option", 'onClose', function(selectedDate) {
        $('input.date.bid_start').datepicker( "option", "maxDate", selectedDate);
        $('input.date.billing_date').datepicker( "option", "minDate", selectedDate);
        $('input.carryout_start_date').datepicker( "option", "minDate", selectedDate);
    });

    $('input.date.billing_date').datepicker("option", 'onClose', function(selectedDate) {
        $('input.date.payment_date').datepicker( "option", "minDate", selectedDate);
    });

    $('input.carryout_start_date').datepicker("option", 'onClose', function(selectedDate) {
        $('input.carryout_end_date.date').datepicker( "option", "minDate", selectedDate);
    });
    $('input.carryout_end_date').datepicker("option", 'onClose', function(selectedDate) {
        $('input.carryout_start_date.date').datepicker( "option", "maxDate", selectedDate);
    });

    // $('input.date.display_start').datepicker("option", 'onClose', function(selectedDate) {
    //     $('input.date.display_end').datepicker( "option", "minDate", selectedDate);
    // });
    // $('input.date.display_end').datepicker("option", 'onClose', function(selectedDate) {
    //     $('input.date.display_start').datepicker( "option", "maxDate", selectedDate);
    // });

    $('input.date.seri_start').datepicker("option", 'onClose', function(selectedDate) {
        $('input.date.seri_end').datepicker( "option", "minDate", selectedDate);
    });
    $('input.date.seri_end').datepicker("option", 'onClose', function(selectedDate) {
        $('input.date.seri_start').datepicker( "option", "maxDate", selectedDate);
    });

    // 時間コンボボックスのイベント設定
    var timeArray = [];
    for (i=9; i<24; i++) {
        timeArray.push(i + ":00");
        timeArray.push(i + ":30");
    }
    for (i=0; i<9; i++) {
        timeArray.push(i + ":00");
        timeArray.push(i + ":30");
    }
    $('input.time').autocomplete({
        source :  function(req, res) { res(timeArray);},
        minLength : 0
    }).click(function() {
        $(this).autocomplete('search');
    });


    //// 数値のみに自動整形 ////
    $('input.number').change(function() {
        var number = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9.]/g, '');
        $(this).val(number ? parseInt(number) : '');
    });

    //// デメ計算 ////
    $('input.deme').change(function() {
        $('span.deme2').text(100 - $(this).val());
    }).change();

    //// 処理 ////
    $('button.submit').click(function() {
        var data = {
            'id': $.trim($('input.id').val()),

            'title': $.trim($('input.title').val()),
            'organizer': $.trim($('input.organizer').val()),
            'entry_start_date': $.trim($('input.entry_start.date').val()),
            'entry_start_time': $.trim($('input.entry_start.time').val()),
            'entry_end_date': $.trim($('input.entry_end.date').val()),
            'entry_end_time': $.trim($('input.entry_end.time').val()),

            'preview_start_date': $.trim($('input.preview_start_date').val()),
            'preview_end_date': $.trim($('input.preview_end_date').val()),

            'bid_start_date': $.trim($('input.bid_start.date').val()),
            'bid_start_time': $.trim($('input.bid_start.time').val()),
            'bid_end_date': $.trim($('input.bid_end.date').val()),
            'bid_end_time': $.trim($('input.bid_end.time').val()),

            'user_bid_date': $.trim($('input.user_bid.date').val()),
            'user_bid_time': $.trim($('input.user_bid.time').val()),

            'billing_date': $.trim($('input.billing_date').val()),
            'payment_date': $.trim($('input.payment_date').val()),
            'carryout_start_date': $.trim($('input.carryout_start_date.date').val()),
            // 'carryout_start_time': $.trim($('input.carryout_start_date.time').val()),
            'carryout_start_time': '00:00',
            'carryout_end_date': $.trim($('input.carryout_end_date.date').val()),
            // 'carryout_end_time': $.trim($('input.carryout_end_date.time').val()),
            'carryout_end_time': '23:59:59',

            /*
            'display_start_date': $.trim($('input.display_start.date').val()),
            'display_start_time': $.trim($('input.display_start.time').val()),
            'display_end_date': $.trim($('input.display_end.date').val()),
            'display_end_time': $.trim($('input.display_end.time').val()),
            */

            'seri_start_date': $.trim($('input.seri_start.date').val()),
            'seri_start_time': $.trim($('input.seri_start.time').val()),
            'seri_end_date': $.trim($('input.seri_end.date').val()),
            'seri_end_time': $.trim($('input.seri_end.time').val()),

            'min_price': $.trim($('input.min_price').val()),
            'rate': $.trim($('input.rate').val()),
            'tax': $.trim($('input.tax').val()),
            'motobiki': $.trim($('input.motobiki').val()),
            'deme': $.trim($('input.deme').val()),

            // 'entry_limit_style': $.trim($('input.entry_limit_style:checked').val()),
            // 'entry_limit_num': $.trim($('input.entry_limit_num').val()),
        };

        //// 入力のチェック ////
        var e = '';
        $('input[required]').each(function() {
            if ($(this).val() == '') {
                e += "必須項目が入力されていません\n\n";
                return false;
            }
        });

        /*
        if (data['entry_limit_style'] > 0 && !data['entry_limit_num']) {
            e += "登録制限数が入力されていません\n";
        }
        */

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('入力した入札会情報を保存します。よろしいですか。')) { return false; }

        $('button.submit').attr('disabled', 'disabled').text('保存処理中、終了までそのままお待ち下さい');

        $.post('/system/ajax/bid.php', {
            'target': 'system',
            'action': 'setOpen',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                $('button.submit').removeAttr('disabled').text('入札会情報を保存');
                alert(res);
                return false;
            }

            // 登録完了
            alert('保存が完了しました');
            location.href = '/system/';
            return false;
        }, 'text');

        return false;
    });
});
</script>
<style type="text/css">
table.form td {
  vertical-align: middle;
}

input.date {
  width: 90px;
}

input.time {
  width: 60px;
}

table.form td input.tax,
table.form td input.deme,
table.form td input.entry_limit_num {
  width: 40px;
}

table.form td textarea.fee_calc {
  width: 150px;
  height: 120px;
}
</style>
{/literal}
{/block}

{block 'main'}
<input type="hidden" class="id" value="{$bidOpen.id}" />

{*
<div class="form_comment">
  <span class="alert">※</span>
  　<span class="required">(必須)</span>の項目は必須入力項目です。
</div>
*}

<table class="info form">
  <tr class="title">
    <th>タイトル<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="title" class="title" value="{$bidOpen.title}" required />
    </td>
  </tr>

  <tr class="organizer">
    <th>主催者名<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="organizer" class="organizer" value="{$bidOpen.organizer}" required />
    </td>
  </tr>

  <tr class="open">
    <th>出品期間<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="entry_start_date" class="entry_start date" value="{$bidOpen.entry_start_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="entry_start_time" class="entry_start time" value="{$bidOpen.entry_start_date|date_format:'%H:%M'}" required />
      ～
      <input type="text" name="entry_end_date" class="entry_end date" value="{$bidOpen.entry_end_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="entry_end_time" class="entry_end time" value="{$bidOpen.entry_end_date|date_format:'%H:%M'}" required />
    </td>
  </tr>

  <tr class="bid">
    <th>下見期間<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="preview_start_date" class="preview_start_date date" value="{$bidOpen.preview_start_date|date_format:'%Y/%m/%d'}" required />
      ～
      <input type="text" name="preview_end_date" class="preview_end_date date" value="{$bidOpen.preview_end_date|date_format:'%Y/%m/%d'}" required />
    </td>
  </tr>

  <tr class="bid">
    <th>入札期間<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="bid_start_date" class="bid_start date" value="{$bidOpen.bid_start_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="bid_start_time" class="bid_start time" value="{$bidOpen.bid_start_date|date_format:'%H:%M'}" required />
      ～
      <input type="text" name="bid_end_date" class="bid_end date" value="{$bidOpen.bid_end_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="bid_end_time" class="bid_end time" value="{$bidOpen.bid_end_date|date_format:'%H:%M'}" required />
    </td>
  </tr>

  <tr class="bid">
    <th>入札日時(一般ユーザ向け)<br /><span class="required">(必須)</span></th>
    <td>
      <input type="text" name="user_bid_date" class="user_bid date" value="{$bidOpen.user_bid_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="user_bid_time" class="user_bid time" value="{$bidOpen.user_bid_date|date_format:'%H:%M'}" required />
    </td>
  </tr>

  <tr class="bid">
    <th>企業間売り切り期間</th>
    <td>
      <input type="text" name="seri_start_date" class="seri_start date" value="{$bidOpen.seri_start_date|date_format:'%Y/%m/%d'}" />
      <input type="text" name="seri_start_time" class="seri_start time" value="{$bidOpen.seri_start_date|date_format:'%H:%M'}" />
      ～
      <input type="text" name="seri_end_date" class="seri_end date" value="{$bidOpen.seri_end_date|date_format:'%Y/%m/%d'}" />
      <input type="text" name="seri_end_time" class="seri_end time" value="{$bidOpen.seri_end_date|date_format:'%H:%M'}" />
    </td>
  </tr>

  <tr class="billing_date">
    <th>請求日<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="billing_date" class="billing_date date" value="{$bidOpen.billing_date|date_format:'%Y/%m/%d'}" required />
    </td>
  </tr>

  <tr class="payment_date">
    <th>支払日<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="payment_date" class="payment_date date" value="{$bidOpen.payment_date|date_format:'%Y/%m/%d'}" required />
    </td>
  </tr>

  <tr class="carryout">
    <th>搬出期間<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="carryout_start_date" class="carryout_start_date date" value="{$bidOpen.carryout_start_date|date_format:'%Y/%m/%d'}" required />
      {*
      <input type="text" name="carryout_start_time" class="carryout_start_date time" value="{$bidOpen.carryout_start_date|date_format:'%H:%M'}" required />
      *}
      ～
      <input type="text" name="carryout_end_date" class="carryout_end_date date" value="{$bidOpen.carryout_end_date|date_format:'%Y/%m/%d'}" required />
      {*
      <input type="text" name="carryout_end_time" class="carryout_end_date time" value="{$bidOpen.carryout_end_date|date_format:'%H:%M'}" required />
      *}
    </td>
  </tr>

  {*
  <tr class="display_start">
    <th>表示期間<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="display_start_date" class="display_start date" value="{$bidOpen.display_start_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="display_start_time" class="display_start time" value="{$bidOpen.display_start_date|date_format:'%H:%M'}" required />
      ～
      <input type="text" name="display_end_date" class="display_end date" value="{$bidOpen.display_end_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="display_end_time" class="display_end time" value="{$bidOpen.display_end_date|date_format:'%H:%M'}" required />
    </td>
  </tr>
  *}

  <tr class="min_price">
    <th>最低出品金額<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="min_price" class="min_price number" value="{$bidOpen.min_price}" required />円
    </td>
  </tr>

  <tr class="min_price">
    <th>入札レート<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="rate" class="rate number" value="{$bidOpen.rate}" required />円
    </td>
  </tr>

  <tr class="tax">
    <th>消費税<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="tax" class="tax number" value="{$bidOpen.tax}" required />%
    </td>
  </tr>

  {*
  <tr class="motobiki">
    <th>元引き手数料<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="motobiki" class="motobiki number" value="{$bidOpen.motobiki}" required />円
    </td>
  </tr>
  *}

  <tr class="deme">
    <th>デメ<span class="required">(必須)</span></th>
    <td>
      出品者 : <input type="text" name="deme" class="deme number" value="{$bidOpen.deme}" required />%
      落札者 : <span class="deme2"></span>%
    </td>
  </tr>

{*
  <tr class="fee_calc">
    <th>販売手数料<span class="required">(必須)</span></th>
    <td>
      出品最低価格(円) : 組合手数料(%) , 落札者への手数料(%)<br />
      <textarea name="fee_calc" class="fee_calc" required>{$bidOpen.fee_calc}</textarea>
    </td>
  </tr>
*}

  {*
  <tr class="entry_limit">
    <th>出品点数制限</th>
    <td>
      {html_radios name='entry_limit_style' class='entry_limit_style'
        options=[0 => '制限なし', 100 => '会社ごとの件数', 2 => '全体の件数']
        selected=$bidOpen.entry_limit_style separator=' '}
      <br />
      <input type="text" name="entry_limit_num" class="entry_limit_num number" value="{$bidOpen.entry_limit_num}" />件
    </td>
  </tr>
  *}

</table>

<button type="button" name="submit" class="submit">入札会情報を保存</button>
{/block}
