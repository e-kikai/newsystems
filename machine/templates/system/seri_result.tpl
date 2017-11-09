{extends file='include/layout.tpl'}

{block 'header'}

<script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
    //// テーブルスクロール ////
    $(window).resize(function() {
        $('div.table_area').css('height', $(window).height() - 270);
    }).triggerHandler('resize');

     $('div.table_area').scroll(function() {
        $(window).triggerHandler('scroll');
     });
});
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

{if empty($sumList)}
  <div class="error_mes">条件に合う機械はありません</div>
{/if}

<div class="table_area">
{foreach $sumList as $s}
  {if $s@first}
  <table class="machines list">
    <tr>
      <th class="id" rowspan="2">会社ID</th>
      <th class="company" rowspan="2">会社名</th>
      <th class="sepa2" colspan="3" style="width:300px;">落札代金請求</th>
      <th class="sepa2" colspan="1" style="width:120px;">出品支払</th>
      <th class="sepa2" colspan="2" style="width:200px;">結果</th>
      <th class="company sepa2" rowspan="2">会社名</th>
      <th class="sepa2" colspan="7" style="width:700px;">支払口座(支払の場合のみ表示)</th>

    <tr>
      <th class="min_price sepa2">落札代金請求額</th>
      <th class="min_price">消費税({$bidOpen.tax}%)</th>
      <th class="min_price">差引落札請求額</th>

      <th class="min_price sepa2">出品支払額</th>

      <th class="min_price sepa2">結果</th>
      <th class="min_price">金額</th>

      <th class="sepa2">出品担当者</th>
      <th class="">銀行名</th>
      <th class="">支店名</th>
      <th class="">種類</th>
      <th class="">口座番号</th>
      <th class="">口座名義</th>
      <th class="">銀行振込略称</th>
    </tr>
  {/if}

  <tr>
    <td class="id">{$s.company_id}</td>
    <td class="company">{$s.company.company}</td>
    <td class="min_price sepa2">{$s.billing|number_format}円</td>
    <td class="min_price">{$s.billing_tax|number_format}円</td>
    <td class="min_price">{$s.final_billing|number_format}円</td>

    <td class="min_price sepa2">{$s.final_payment|number_format}円</td>

    <td class="min_price sepa2">{$s.result_type}</td>
    <td class="min_price">{$s.result|number_format}円</td>

    <td class="company sepa2">{$s.be_company}</td>

    {if $s.final_payment > $s.final_billing}
      <td class="sepa2">{$s.be_officer}</td>
      <td class="">{$s.be_bank}</td>
      <td class="">{$s.be_branch}</td>
      <td class="">{$s.be_type}</td>
      <td class="">{$s.be_number}</td>
      <td class="">{$s.be_name}</td>
      <td class="">{$s.be_abbr}</td>
    {else}
      <td class="sepa"></td>
      <td class=""></td>
      <td class=""></td>
      <td class=""></td>
      <td class=""></td>
      <td class=""></td>
      <td class=""></td>
      <td class=""></td>
    {/if}
  </tr>

  {if $s@last}
    </table>
  {/if}
{/foreach}
</div>

{*** ページャ ***}
{include file="include/pager.tpl"}

{/block}
