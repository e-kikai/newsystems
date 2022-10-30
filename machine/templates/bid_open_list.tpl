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
        <th class="organizer">主催者名</th>
        <th class="entry_start_date">登録開始日時</th>
        <th class="bid_date">入札期間</th>
        <th class="condition">状況</th>
      </tr>
    </thead>

    {foreach $bidOpenList as $b}
      <tr>
        <td class='id'>{$b.id}</td>
        <td class='title'>
          <a href="/admin/bid_list.php?o={$b.id}">{$b.title}</a>
        </td>
        <td class='organizer'>{$b.organizer}</td>
        <td class='entry_start_date'>{$b.entry_start_date|date_format:'%Y/%m/%d %H:%M'}</td>
        <td class='bid_date'>
          {$b.bid_start_date|date_format:'%Y/%m/%d %H:%M'} ～
          {$b.bid_end_date|date_format:'%m/%d %H:%M'}
        </td>
        <td class='condition'>{BidOpen::statusLabel($b.status)}</td>
      </tr>
    {/foreach}
  </table>
{/block}