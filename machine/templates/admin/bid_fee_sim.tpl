<!DOCTYPE html>

{include "include/html_header.tpl"}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
  var deme = {$bidOpen.deme};
  var tax  = {$bidOpen.tax};
  var bidMinPrice  = {$bidOpen.min_price};
  var rate = {$bidOpen.rate};

  var feeTable = {};
  {foreach $feeTable as $f}
    feeTable['{$f@key}'] = [{$f[0]}, {$f[1]}];
  {/foreach}

  {literal}
    $(function() {
      $('button.calc').click(function() {
        // 数値チェック
        $('input.min_price, input.amount').change();
        var minPrice = parseInt($.trim($('input.min_price').val()));
        var amount = parseInt($.trim($('input.amount').val()));

        // 表示切替
        $('input.min_price').val(cjf.numberFormat(minPrice));
        $('input.amount').val(cjf.numberFormat(amount));

        var e = '';
        if (!minPrice || !amount) {
          e += '最低入札金額、落札金額を入力して下さい';
        } else if (amount < minPrice) {
          e += '落札金額が、最低入札金額より少なくなっています';
        } else if (minPrice < bidMinPrice) {
          e += "最低入札金額が最低額より少なくなっています\n最低金額 : " + cjf.numberFormat(bidMinPrice) + "円";
        } else if ((minPrice % rate) != 0) {
          e += "最低入札金額が入札レートの倍数ではありません\n入札レート : " + cjf.numberFormat(rate) + "円";
        } else if ((amount % rate) != 0) {
          e += "落札金額が入札レートの倍数ではありません\n入札レート : " + cjf.numberFormat(rate) + "円";
        }

        if (e != '') { alert(e); return false; }

        // デメ半の計算
        var demeh = (amount - minPrice) * deme / 100;

        // 手数料計算
        var jPer = 0;
        var rPer = 0;
        $.each(feeTable, function(i, val) {
          if (i == 'else' || parseInt(i) >= minPrice) {
            jPer = val[0];
            rPer = val[1];
            return false;
          }
        });

        var rFee = minPrice * rPer / 100;
        var jFee = minPrice * jPer / 100;

        // 税抜き金額
        var payment = minPrice + demeh - rFee - jFee;
        var billing = amount - demeh - rFee;

        // 消費税
        var paymentTax = Math.floor(payment * tax / 100);
        var billingTax = Math.floor(billing * tax / 100);

        // 計算結果
        var finalPayment = payment + paymentTax;
        var finalBilling = billing + billingTax;

        $('.calc_table.result .min_price').text(cjf.numberFormat(minPrice) + '円');
        $('.calc_table.result .amount').text(cjf.numberFormat(amount) + '円');

        $('.calc_table .demeh').text(cjf.numberFormat(demeh) + '円');

        $('.calc_table .r_fee').text(cjf.numberFormat(rFee) + '円 (' + rPer + '%)');
        $('.calc_table .j_fee').text(cjf.numberFormat(jFee) + '円 (' + jPer + '%)');

        $('.calc_table .payment').text(cjf.numberFormat(payment) + '円');
        $('.calc_table .billing').text(cjf.numberFormat(billing) + '円');
      });

      //// 数値のみに自動整形 ////
      $('input.number').change(function() {
        var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9.]/g, '');
        $(this).val(price ? parseInt(price) : '');
      });
    });
  </script>
  <style type="text/css"></style>
{/literal}
</head>

<body>
  <h1>{$pageTitle}</h1>

  <div class='feetable_area'>
    <h2>支払・請求額シミュレータ</h2>
    <p>
      商品の最低入札金額と、落札金額を入力して、「計算」をクリックすると、出品支払額・落札請求額を計算して表示させることができます。<br />
      商品を出品する際に、最低入札金額を決定する時の参考にして下さい。<br /><br />

      手数料計算方法について、詳しくは<a href="admin/bid_fee_help.php?o={$bidOpenId}" target=="_blank">入札会手数料について</a>
    </p>
    <table class="calc_table">
      <tr>
        <th>最低入札金額</th>
        <th>落札金額</th>
        <th></th>
      </tr>
      <tr>
        <td><input type="text" class="min_price number" />円</td>
        <td><input type="text" class="amount number" />円</td>
        <td><button type="button" class="calc">計算</button></td>
      </tr>
    </table>

    <p>
      最低出品金額 : {$bidOpen.min_price|number_format}円、 入札レート : {$bidOpen.rate|number_format}円
    </p>
    <div class="arrow">⇓</div>

    <table class="calc_table result">
      <tr>
        <td class="blank"></td>
        <th>最低入札金額</th>
        <th>落札金額</th>
        <th class="final">デメ半({$bidOpen.deme}%) ③</th>
        <th class="fee">落札会社への手数料 ④</th>
        <th class="fee">事務局手数料 ⑤</th>
        <th class="final">計算結果</th>
      </tr>
      <tr>
        <th>出品支払額 ①</th>
        <td class="min_price" rowspan="2"></td>
        <td class="amount" rowspan="2"></td>
        <td class="final demeh" rowspan="2"></td>
        <td class="r_fee fee" rowspan="2"></td>
        <td class="j_fee fee"></td>
        <td class="final payment"></td>
      </tr>

      <tr>
        <th>落札請求額 ②</th>

        <td>--</td>
        <td class="final billing"></td>
      </tr>
    </table>

    <button class="close" onclick="window.close();return false;">支払・請求額シミュレータを閉じる</button>
  </div>

</body>

</html>