{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
});
</script>
<style type="text/css">
table.result {
  width: 360px;
  margin-left: 80px;
  float: left;
}

table.result td  {
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
    <th>落札代金請求額</th>
    <td class="number">{$seriBidSum|number_format}円</td>
  </tr>
  <tr>
    <th>消費税 : {$bidOpen.tax|number_format}%</th>
    <td class="number">{$seriTax|number_format}円</td>
  </tr>
  <tr>
    <th>差引落札請求額</th>
    <td class="number">{$seriFinalSum|number_format}円</td>
  </tr>
</table>

<table class="result form">
  <caption>出品支払書</caption>
  <tr>
    <th>出品支払額</th>
    <td class="number">{$seriSum|number_format}円</td>
  </tr>
</table>
<br style="clear:both;">

<dl class="total">
  <dt>落札請求額</dt>
  <dd>{$seriFinalSum|number_format}円</dd>
  <dt>出品支払額</dt>
  <dd>{$seriSum|number_format}円</dd>

  {if $seriResult < 0}
    <dt class="result">差引落札請求額</dt>
  {else}
    <dt class="result">差引出品支払額</dt>
  {/if}
  <dd class="result">{$seriResult|abs|number_format}円</dd>
</dl>

{/block}
