{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        /// サムネイル画像の遅延読み込み（Lazyload） ///
        $('img.lazy').css('display', 'block').lazyload({
          effect: "fadeIn"
        });

        setTimeout(function() {
          $(window).triggerHandler('scroll');
        }, 100);

        $('#company_list_form').submit(function() {
          if ($('select.xl_genre_id option:selected').hasClass('large_genre')) {
            $('select.xl_genre_id').attr('name', 'l');
          }

          if ($('select.region option:selected').hasClass('state')) {
            $('select.region').attr('name', 's');
          }
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  {include "include/bid_announce.tpl"}

  <fieldset class="search id_search">
    <legend>出品番号から検索</legend>
    <form method="GET" id="no_form" action="admin/bid_list.php">
      <input type="hidden" name="o" value="{$bidOpenId}" />
      <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
      <button type="submit" class="company_list_submit">検索</button>
    </form>
  </fieldset>

  <fieldset class="search">
    <legend>検索</legend>

    <form method="GET" id="company_list_form">
      <input type="hidden" name="o" value="{$bidOpenId}" />

      <select class="xl_genre_id" name="x">
        <option value="">▼ジャンル▼</option>
        {foreach $xlGenreList as $x}
          <option value="{$x.id}" {if $q.xl_genre_id==$x.id} selected="selected" {/if}>{$x.xl_genre} ({$x.count})</option>
          {foreach $largeGenreList as $l}
            {if $l.xl_genre_id == $x.id}
              <option value="{$l.id}" class="large_genre" {if $q.large_genre_id==$l.id} selected="selected" {/if}>
                　{$l.large_genre} ({$l.count})
              </option>
            {/if}
          {/foreach}
        {/foreach}
      </select>

      <select class="region" name="r">
        <option value="">▼地域・都道府県▼</option>
        {foreach $regionList as $r}
          <option value="{$r.region}" {if $q.region==$r.region} selected="selected" {/if}>{$r.region} ({$r.count})</option>
          {foreach $stateList as $s}
            {if $s.region_id == $r.id}
              <option value="{$s.state}" class="state" {if $q.state==$s.state} selected="selected" {/if}>　{$s.state}
                ({$s.count})</option>
            {/if}
          {/foreach}
        {/foreach}
      </select>

      <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
      <button type="submit" class="company_list_submit">検索</button>
    </form>

  </fieldset>

  {if empty($bidMachineList)}
    <div class="error_mes">条件に合う機械はありません</div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  {foreach $bidMachineList as $m}
    {if $m@first}
      <table class="machines list">
        <tr>
          <th class="img"></th>
          <th class="bid_machine_id"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}">出品番号</a></th>
          <th class="name"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=name">機械名</a></th>
          <th class="maker"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=maker">メーカー</a></th>
          <th class="model"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=model">型式</a></th>
          {if !in_array($bidOpen.status, array('carryout', 'after'))}
            <th class="location"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=location">在庫場所</a></th>
            <th class="company"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=company">出品会社</a></th>
            <th class="min_price"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=min_price">最低入札金額</a></th>
            <th class="min_price">自社入札</th>
          {else}
            <th class="company"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=company">出品会社</a></th>
            <th class="min_price"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=min_price">最低入札金額</a></th>
            <th class="same_count">入札数</th>
            <th class="company_min">落札会社</th>
            <th class="min_price">落札金額</th>
            <th class="min_price">自社入札</th>
            <th class="same_count">落札</th>
          {/if}
        </tr>
      {/if}

      <tr>
        <td class="img">
          {if !empty($m.top_img)}
            <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
            <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
          {/if}
        </td>
        <td class="bid_machine_id">{$m.list_no}</td>
        {*
        <td class="name"><a class="bid" href="admin/bid_detail.php?m={$m.id}">{$m.name}</a></td>
        *}
        <td class="name"><a class="bid" href="bid_detail.php?m={$m.id}">{$m.name}</a></td>
        <td class="maker">{$m.maker}</td>
        <td class="model">{$m.model}</td>
        {if !in_array($bidOpen.status, array('carryout', 'after'))}
          <td class="location">{$m.addr1}<br />({$m.location})</td>
          <td class="company">
            <a href="company_detail.php?c={$m.company_id}" target="_blank">
              {'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company}
            </a><br />
            <a class="contact" href="contact.php?c={$m.company_id}&b=1&o={$bidOpenId}&bm={$m.id}" target="_blank">お問い合せ</a>
          </td>
          <td class="min_price">{$m.min_price|number_format}円</td>
          <td class="min_price">
            {if !empty($resultListCompanyAsKey[$m.id].amount)}{$resultListCompanyAsKey[$m.id].amount|number_format}円{/if}
          </td>
        {else}
          <td class="company_min">
            <a href="company_detail.php?c={$m.company_id}" target="_blank">
              {'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company}
            </a><br />
            <a class="contact" href="contact.php?c={$m.company_id}" target="_blank">お問い合せ</a>
          </td>
          <td class="min_price">{$m.min_price|number_format}円</td>
          <td class="same_count">
            {if !empty($resultListAsKey[$m.id].count)}{$resultListAsKey[$m.id].count}{/if}
          </td>
          <td class="company_min">
            {if !empty($resultListAsKey[$m.id].company)}
              <a href="company_detail.php?c={$resultListAsKey[$m.id].company_id}" target="_blank">
                {'/(株式|有限|合.)会社/u'|preg_replace:'':$resultListAsKey[$m.id].company}
              </a>
            {/if}
          </td>
          <td class="min_price">
            {if !empty($resultListAsKey[$m.id].amount)}{$resultListAsKey[$m.id].amount|number_format}円{/if}
            {if $resultListAsKey[$m.id].same_count > 1}(同額札有){/if}
          </td>
          <td class="min_price">
            {if !empty($resultListCompanyAsKey[$m.id].amount)}{$resultListCompanyAsKey[$m.id].amount|number_format}円{/if}
          </td>
          <td class="same_count">
            {if !empty($resultListCompanyAsKey[$m.id])}
              {if $resultListCompanyAsKey[$m.id].bid_id == $resultListAsKey[$m.id].bid_id}<span class="bid_true">◯</span>
              {else}<span class="bid_false">×</span>
              {/if}
            {/if}
          </td>
        {/if}
      </tr>

      {if $m@last}
      </table>
    {/if}
  {/foreach}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}