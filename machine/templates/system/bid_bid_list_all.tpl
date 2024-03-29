{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {});
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
        <th class="title">タイトル</th>
        <th class="">下見期間</th>
        <th class="entry_start_date">入札締切</th>
        <th class="status">状況</th>
        <th class="id">出品数</th>
        <th class="id">ウォッチ</th>
        <th class="id">入札数</th>
        <th class="id">入札人数</th>
        <th class="id">落札数</th>
        <th class="result_price">落札金額</th>
      </tr>
    </thead>

    {$flag = 1}

    {foreach $bidOpenList as $b}
      {if $flag == 1 &&  $b.user_bid_date <= $smarty.const.BID_USER_START_DATE}
        <tr>
          <th class='id'>ID</th>
          <th class="title">タイトル</th>
          <th class="">下見期間</th>
          <th class="entry_start_date">入札締切</th>
          <th class="status">状況</th>
          <th class="id">出品数</th>
          <th class="id"></th>
          <th class="id">入札数</th>
          <th class="id">入札会社</th>
          <th class="id">落札数</th>
          <th class="result_price">落札金額</th>
        </tr>
        {$flag = 0}
      {/if}

      <tr class="{$b.status}">
        <td class='id'>{$b.id}</td>
        <td class='title'>
          <a href="/system/bid_open_form.php?id={$b.id}">{$b.title}</a>
        </td>
        <td class=''>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</td>
        <td class=''>{$b.user_bid_date|date_format:'%m/%d %H:%M'}</td>
        <td class='status'>{BidOpen::statusLabel($b.status)}</td>
        <td class='id'>{$b.product_count|number_format}</td>
        {if $b.user_bid_date > $smarty.const.BID_USER_START_DATE}
          <td class='id'>
            <a href="/system/my_bid_watches/?o={$b.id}">{$b.my_bid_watch_count|number_format}</a>
          <td class='id'>
            <a href="/system/my_bid_bids/?o={$b.id}">{$b.my_bid_count|number_format}</a>
          <td class='id'>{$b.my_bid_user_count|number_format}</td>
          <td class='id'>{$b.my_bid_result_count|number_format}</td>
          <td class='result_price'>{$b.my_bid_result_price_sum|number_format} 円</td>
        {else}
          <td class='id'></td>
          <td class='id'>
            <a href="/system/bid_bid_list_detail.php?o={$b.id}">{$b.count|number_format}</a>
          <td class='id'>{$b.company_count|number_format}</td>
          <td class='id'>{$b.result_count|number_format}</td>
          <td class='result_price'>{$b.result_price_sum|number_format} 円</td>
        {/if}
      </tr>
    {/foreach}
  </table>
{/block}