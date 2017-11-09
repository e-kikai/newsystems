{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
<table class='list contact_ss'>
  <thead>
    <tr>
      <th class="month">{if empty($month)}集計月{else}集計日{/if}</th>
      <th class="detail">機械詳細閲覧</th>
      <th class="detail">入札詳細閲覧</th>
      <th class="detail">入札詳細(会員)</th>
      <th class="zenkiren">事務局</th>
      <th class="company">会社</th>
      <th class="machine">在庫機械</th>
      <th class="total">合計</th>
    </tr>
  </thead>
  {assign "dwj" array( '日', '月', '火', '水', '木', '金', '土' )}
  {foreach $contactSS as $c}
    <tr class="{cycle values='even, odd'} {if !empty($month)}{$c.month|date_format:'D'}{/if}">
      <td class="month">
      {if empty($month)}
        {if $c.month|cat:'/01'|date_format:'Y-m' == $smarty.now|date_format:'Y-m'}
          <a href="/system/contact_ss.php?m=now">{$c.month}(今月)</a>
        {else}
          <a href="/system/contact_ss.php?m={$c.month|cat:'/01'|date_format:'Y-m'}">{$c.month}</a>
        {/if}
      {else}
        {$c.month} (<span class="dw">{$dwj[$c.month|date_format:'w']}</span>)
      {/if}
      </td>
      <td class="detail">{$c.detail|number_format}</th>
      <td class="detail">{$c.bid_detail|number_format}</th>
      <td class="detail">{$c.admin_bid_detail|number_format}</th>
      <td class="zenkiren">{$c.zenkiren|number_format}</th>
      <td class="company">{$c.company|number_format}</th>
      <td class="machine">{$c.machine|number_format}</th>
      <td class="total">{$c.total|number_format}</th>
    </tr>
  {/foreach}
</table>
{/block}
