{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
});
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="company">入札会社</th>

      <th class="min_price">入札金額</th>

      <th class="entry_start_date">入札日時</th>
      {*
      <th class="entry_start_date">キャンセル</th>
      *}

      <th class='id sepa2'>No.</th>
      <th class="">商品名</th>
      <th class="min_price">最低金額</th>
      <th class="company">出品会社</th>
    </tr>
  </thead>

  {foreach $bidBidList as $bb}
    <tr>
      <td class='id'>{$bb.id}</td>
      <td class='company'>{'/(株式|有限|合.)会社/u'|preg_replace:' ':$bb.bid_company|trim}</td>

      <td class='min_price'>{$bb.amount|number_format}円
      <td class=''>{$bb.created_at|date_format:'%m/%d %H:%M:%S'}</td>
      {*
      <td class=''>{$bb.deleted_at|date_format:'%m/%d %H:%M:%S'}</td>
      *}

      <td class='id sepa2'>{$bb.list_no}</td>
      <td class=''>
        <a href="/bid_detail.php?m={$bb.bid_machine_id}">{$bb.maker} {$bb.name} {$bb.model}</a>
      </td>
      <td class='min_price'>{$bb.min_price|number_format}円
      <td class='company'>{'/(株式|有限|合.)会社/u'|preg_replace:' ':$bb.company|trim}</td>
      </td>
    </tr>
  {/foreach}
</table>
{/block}
