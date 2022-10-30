{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />
  <script type="text/javascript">
    {literal}
      $(function() {});
    </script>
    <style type="text/css">
      table.result {
        width: 360px;
        margin-left: 80px;
        float: left;
      }

      table.result td {
        text-align: right;
      }

      dl.total {
        width: 360px;
        margin: 15px auto 15px 520px;
      }

      dl.total dt {
        display: inline-block;
        width: 176px;
        text-align: left;

        font-size: 15px;
      }

      dl.total dd {
        display: inline-block;
        width: 176px;
        text-align: right;

        font-size: 15px;
      }

      dl.total dt.result,
      dl.total dd.result {
        font-weight: bold;
        margin-top: 15px;
        border-top: 1px solid #333;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <table class="result form">
    <caption>落札代金請求書</caption>
    <tr>
      <th>落札代金請求額(イ)</th>
      <td class="number">{$sum.billing_amount|number_format}円</td>
    </tr>
    <tr>
      <th>デメ半(ロ)</th>
      <td class="number">{$sum.billing_demeh|number_format}円</td>
    </tr>
    <tr>
      <th>小計(イ)-(ロ)=(ハ)</th>
      <td class="number">{($sum.billing_amount - $sum.billing_demeh)|number_format}円</td>
    </tr>

    <tr>
      <th>貴社受取手数料(ニ)</th>
      <td class="number">{$sum.billing_rFee|number_format}円</td>
    </tr>
    <tr>
      <th>差引(ハ)-(ニ)</th>
      <td class="number">{$sum.billing|number_format}円</td>
    </tr>
    <tr>
      <th>消費税 : {$bidOpen.tax}%</th>
      <td class="number">{$sum.billing_tax|number_format}円</td>
    </tr>
    <tr>
      <th>差引落札請求額</th>
      <td class="number">{$sum.final_billing|number_format}円</td>
    </tr>
  </table>

  <table class="result form">
    <caption>出品支払書</caption>
    <tr>
      <th>出品支払額(イ)</th>
      <td class="number">{$sum.payment_amount|number_format}円</td>
    </tr>
    <tr>
      <th>デメ半(ロ)</th>
      <td class="number">{$sum.payment_demeh|number_format}円</td>
    </tr>
    <tr>
      <th>小計(イ)-(ロ)=(ハ)</th>
      <td class="number">{($sum.payment_amount - $sum.payment_demeh)|number_format}円</td>
    </tr>
    <tr>
      <th>出品料(ニ)事務局手数料</th>
      <td class="number">{$sum.payment_jFee|number_format}円</td>
    </tr>
    <tr>
      <th>出品料(ニ)販売手数料</th>
      <td class="number">{$sum.payment_rFee|number_format}円</td>
    </tr>
    <tr>
      <th>差引(ハ)-(ニ)</th>
      <td class="number">{$sum.payment|number_format}円</td>
    </tr>
    <tr>
      <th>消費税 : {$bidOpen.tax}%</th>
      <td class="number">{$sum.payment_tax|number_format}円</td>
    </tr>
    <tr>
      <th>差引出品支払額</th>
      <td class="number">{$sum.final_payment|number_format}円</td>
    </tr>
  </table>
  <br style="clear:both;">

  <dl class="total">
    <dt>落札請求額</dt>
    <dd>{$sum.final_billing|number_format}円</dd>
    <dt>出品支払額</dt>
    <dd>{$sum.final_payment|number_format}円</dd>

    {if $sum.final_billing > $sum.final_payment}
      <dt class="result">差引落札請求額</dt>
      <dd class="result">{($sum.final_billing - $sum.final_payment)|number_format}円</dd>
    {else}
      <dt class="result">差引出品支払額</dt>
      <dd class="result">{($sum.final_payment - $sum.final_billing)|number_format}円</dd>
    {/if}
  </dl>

{/block}