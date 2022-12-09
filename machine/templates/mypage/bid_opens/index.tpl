{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript"></script>
    <style type="text/css">
      table .condition {
        width: 100px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <table class='table table-hover table-condensed table-striped'>
    <thead>
      <tr>
        {*
        <th class='id'>ID</th>
        *}
        <th class="title">タイトル</th>
        <th class="condition">ウォッチ</th>

        <th class="condition">入札結果</th>
        <th class="condition">全体の落札結果</th>
        {*
        <th class="organizer">主催者名</th>
        <th class="entry_start_date">登録開始日時</th>
        *}
        <th class="bid_date">下見期間</th>
        <th class="bid_date">入札締切・開票日</th>
        <th class="">状況</th>
      </tr>
    </thead>

    {foreach $bid_opens as $bo}
      {if $bo.user_bid_date > $smarty.const.BID_USER_START_DATE}
        <tr>
          {*
        <td class='id'>{$bo.id}</td>
        *}
          <td class='title'>
            {$bo.title}
          </td>

          <td class="condition">
            {if in_array($bo.status, array('carryout', 'after'))}
              <a href="/mypage/my_bid_watches/?o={$bo.id}">
                <i class="fas fa-star"></i> ウォッチ
              </a>
            {/if}
          </td>

          <td class="condition">
            {if in_array($bo.status, array('carryout', 'after'))}
              <a href="/mypage/my_bid_bids/?o={$bo.id}">
                <i class="fas fa-pen-to-square"></i> 入札
              </a>
            {/if}
          </td>
          <td class="condition">
            {if in_array($bo.status, array('carryout', 'after'))}
              <a href="/mypage/my_bid_bids/?o={$bo.id}">
                <i class="fas fa-list-check"></i> 結果
              </a>
            {/if}
          </td>
          {*
        <td class='organizer'>{$bo.organizer}</td>
        <td class='entry_start_date'>{$bo.entry_start_date|date_format:'%Y/%m/%d %H:%M'}</td>
        *}
          <td class='bid_date'>
            {$bo.preview_start_date|date_format:"%Y/%m/%d"} 〜
            {$bo.preview_end_date|date_format:"%m/%d"}
          </td>
          <td class='bid_date'>
            {$bo.user_bid_date|date_format:"%Y/%m/%d"}
            ({B::strtoweek($bo.user_bid_date)})
            {$bo.user_bid_date|date_format:"%H:%M"}
          </td>
          <td class=''>{BidOpen::statusLabel($bo.status)}</td>
        </tr>
      {/if}
    {/foreach}
  </table>
{/block}