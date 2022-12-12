{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  {*** ページャ ***}
  {include file="include/pager.tpl"}

  <div class="table_area">
    <table class='table table-hover table-condensed table-striped'>

      {foreach $bid_machines as $bm}
        {if $bm@first}
          <tr>
            <th class="list_no">出品番号</th>
            <th class="img"></th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            <th class="company">出品会社</th>
            <th class="min_price">最低入札金額</th>
            <th class="border-start same_count">入札<br />件数</th>
            <th class="min_price">落札金額</th>

          </tr>
        {/if}

        <tr {if !empty($bm.deleted_at)} class="deleted" {/if}>
          <td class="list_no fs-5 text-center">{$bm.list_no}</td>
          <td class="img">
            {if !empty($bm.top_img)}
              <a href="/bid_detail.php?m={$bm.bid_machine_id}" target="_blank">
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$bm.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$bm.top_img}" alt='PDF' /></noscript>
              </a>
            {/if}
          </td>
          <td class="name">
            <a href="/bid_detail.php?m={$bm.bid_machine_id}" target="_blank">{$bm.name}</a>
          </td>
          <td class="maker">{$bm.maker}</td>
          <td class="model">{$bm.model}</td>

          <td class="company">
            {if !empty($bm.company)}
              <a href="company_detail.php?c={$bm.company_id}" target="_blank">
                {'/(株式|有限|合.)会社/'|preg_replace:'':$bm.company}
              </a>
            {/if}
          </td>
          <td class="min_price">{$bm.min_price|number_format}円</td>

          <td class="same_count border-start">
            {if !empty($bids_count[$bm.id])}{$bids_count[$bm.id]|number_format}{/if}
          </td>

          <td class="min_price ">
            {if !empty($bids_result[$bm.id])}
              {$bids_result[$bm.id].amount|number_format}円

              {if $bids_result[$bm.id].same_count > 1}
                <br />
                (同額:{$bids_result[$bm.id].same_count})
              {/if}
            {/if}

          </td>
        </tr>
      {/foreach}
    </table>
  </div>

  {*** ページャ ***}
  {include file="include/pager.tpl"}


  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/bid_door.php?o={$bid_open.id}" class="btn btn-outline-secondary" target="_blank">
      <i class="fas fa-magnifying-glass"></i> Web入札会トップページ
    </a>
    <a href="/mypage/my_bid_watches.php?o={$bid_open.id}" class="btn btn-outline-secondary">
      <i class="fas fa-star"></i> ウォッチリストを見る
    </a>
    <a href="/mypage/" class="btn btn-outline-secondary">
      <i class="fas fa-house"></i> マイページ トップに戻る
    </a>
  </div>

{/block}