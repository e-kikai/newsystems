{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
    </script>
    <style type="text/css">
      .bid_open {
        float: left;
        width: 440px;
        margin-right: 8px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <div class="bid_open">
    <dl class="bid_date">
      <dt>出品会社数</dt>
      <dd>{$sums.company_num} 社</dd><br />
      <dt>出品点数</dt>
      <dd>{$sums.count} 件</dd><br />
      {*
    <dt>売り切り金額合計</dt>
    <dd>{$sums.min_price|number_format} 円</dd><br />
    *}
      {if strtotime($bidOpen["seri_start_date"]) <= time()}
        <dt>落札点数</dt>
        <dd>{$sums.result_count} 件</dd><br />
        <dt>落札金額合計</dt>
        <dd>{$sums.result_price|number_format} 円</dd><br />
      {/if}
    </dl>
  </div>

  <div class="bid_open">
    <dl class="bid_date">
      <dt>出品期間</dt>
      <dd>{$bidOpen.entry_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$bidOpen.bid_end_date|date_format:'%m/%d %H:%M'}
      </dd><br />
      <dt>開催期間</dt>
      <dd>{$bidOpen.seri_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$bidOpen.seri_end_date|date_format:'%m/%d %H:%M'}
      </dd><br />
    </dl>
  </div>

  <br style="clear:both;" />

  {*
    <fieldset class="search id_search">
    <legend>出品番号から検索</legend>
    <form method="GET" id="company_list_form" action="system/bid_list.php">
      <input type="hidden" name="o" value="{$bidOpenId}" />
      <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
      <button type="submit" class="company_list_submit">検索</button>
    </form>
    </fieldset>

    <fieldset class="search">
    <legend>検索</legend>
    <form method="GET" id="company_list_form">
      <input type="hidden" name="o" value="{$bidOpenId}" />
      <select class="genre_id" name="g">
        <option value="">▼ジャンル▼</option>
        {foreach $genreList as $g}

      {*
      <fieldset class="search id_search">
      <legend>出品番号から検索</legend>
      <form method="GET" id="company_list_form" action="system/bid_list.php">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
        <button type="submit" class="company_list_submit">検索</button>
      </form>
      </fieldset>

      <fieldset class="search">
      <legend>検索</legend>
      <form method="GET" id="company_list_form">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <select class="genre_id" name="g">
          <option value="">▼ジャンル▼</option>
          {foreach $genreList as $g}
              {if !empty($g.id)}
                  <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
              {/if}
          {/foreach}
        </select>

        <select class="region" name="r">
          <option value="">▼地域▼</option>
          {foreach $regionList as $r}
              {if !empty($r.region)}
                  <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
              {/if}
          {/foreach}
        </select>
        <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
        <button type="submit" class="company_list_submit">検索</button>
        <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
      </form>
      </fieldset>
      *}{if !empty($g.id)}
                <option value="{$g.id}"
        {*
        <fieldset class="search id_search">
        <legend>出品番号から検索</legend>
        <form method="GET" id="company_list_form" action="system/bid_list.php">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
          <button type="submit" class="company_list_submit">検索</button>
        </form>
        </fieldset>

        <fieldset class="search">
        <legend>検索</legend>
        <form method="GET" id="company_list_form">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <select class="genre_id" name="g">
            <option value="">▼ジャンル▼</option>
            {foreach $genreList as $g}
                {if !empty($g.id)}
                    <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
                {/if}
            {/foreach}
          </select>

          <select class="region" name="r">
            <option value="">▼地域▼</option>
            {foreach $regionList as $r}
                {if !empty($r.region)}
                    <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
                {/if}
            {/foreach}
          </select>
          <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
          <button type="submit" class="company_list_submit">検索</button>
          <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
        </form>
        </fieldset>
        *}{if $q.genre_id==$g.id} selected="selected"
          {*
          <fieldset class="search id_search">
          <legend>出品番号から検索</legend>
          <form method="GET" id="company_list_form" action="system/bid_list.php">
            <input type="hidden" name="o" value="{$bidOpenId}" />
            <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
            <button type="submit" class="company_list_submit">検索</button>
          </form>
          </fieldset>

          <fieldset class="search">
          <legend>検索</legend>
          <form method="GET" id="company_list_form">
            <input type="hidden" name="o" value="{$bidOpenId}" />
            <select class="genre_id" name="g">
              <option value="">▼ジャンル▼</option>
              {foreach $genreList as $g}
                  {if !empty($g.id)}
                      <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
                  {/if}
              {/foreach}
            </select>

            <select class="region" name="r">
              <option value="">▼地域▼</option>
              {foreach $regionList as $r}
                  {if !empty($r.region)}
                      <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
                  {/if}
              {/foreach}
            </select>
            <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
            <button type="submit" class="company_list_submit">検索</button>
            <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
          </form>
          </fieldset>
        *}{/if}>{$g.genre} ({$g.count})</option>

        {*
        <fieldset class="search id_search">
        <legend>出品番号から検索</legend>
        <form method="GET" id="company_list_form" action="system/bid_list.php">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
          <button type="submit" class="company_list_submit">検索</button>
        </form>
        </fieldset>

        <fieldset class="search">
        <legend>検索</legend>
        <form method="GET" id="company_list_form">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <select class="genre_id" name="g">
            <option value="">▼ジャンル▼</option>
            {foreach $genreList as $g}
                {if !empty($g.id)}
                    <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
                {/if}
            {/foreach}
          </select>

          <select class="region" name="r">
            <option value="">▼地域▼</option>
            {foreach $regionList as $r}
                {if !empty($r.region)}
                    <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
                {/if}
            {/foreach}
          </select>
          <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
          <button type="submit" class="company_list_submit">検索</button>
          <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
        </form>
        </fieldset>
      *}{/if}

      {*
      <fieldset class="search id_search">
      <legend>出品番号から検索</legend>
      <form method="GET" id="company_list_form" action="system/bid_list.php">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
        <button type="submit" class="company_list_submit">検索</button>
      </form>
      </fieldset>

      <fieldset class="search">
      <legend>検索</legend>
      <form method="GET" id="company_list_form">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <select class="genre_id" name="g">
          <option value="">▼ジャンル▼</option>
          {foreach $genreList as $g}
              {if !empty($g.id)}
                  <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
              {/if}
          {/foreach}
        </select>

        <select class="region" name="r">
          <option value="">▼地域▼</option>
          {foreach $regionList as $r}
              {if !empty($r.region)}
                  <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
              {/if}
          {/foreach}
        </select>
        <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
        <button type="submit" class="company_list_submit">検索</button>
        <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
      </form>
      </fieldset>
    *}{/foreach}
      </select>

      <select class="region" name="r">
        <option value="">▼地域▼</option>

    {*
    <fieldset class="search id_search">
    <legend>出品番号から検索</legend>
    <form method="GET" id="company_list_form" action="system/bid_list.php">
      <input type="hidden" name="o" value="{$bidOpenId}" />
      <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
      <button type="submit" class="company_list_submit">検索</button>
    </form>
    </fieldset>

    <fieldset class="search">
    <legend>検索</legend>
    <form method="GET" id="company_list_form">
      <input type="hidden" name="o" value="{$bidOpenId}" />
      <select class="genre_id" name="g">
        <option value="">▼ジャンル▼</option>
        {foreach $genreList as $g}
            {if !empty($g.id)}
                <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
            {/if}
        {/foreach}
      </select>

      <select class="region" name="r">
        <option value="">▼地域▼</option>
        {foreach $regionList as $r}
            {if !empty($r.region)}
                <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
            {/if}
        {/foreach}
      </select>
      <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
      <button type="submit" class="company_list_submit">検索</button>
      <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
    </form>
    </fieldset>
    *}{foreach $regionList as $r}

      {*
      <fieldset class="search id_search">
      <legend>出品番号から検索</legend>
      <form method="GET" id="company_list_form" action="system/bid_list.php">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
        <button type="submit" class="company_list_submit">検索</button>
      </form>
      </fieldset>

      <fieldset class="search">
      <legend>検索</legend>
      <form method="GET" id="company_list_form">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <select class="genre_id" name="g">
          <option value="">▼ジャンル▼</option>
          {foreach $genreList as $g}
              {if !empty($g.id)}
                  <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
              {/if}
          {/foreach}
        </select>

        <select class="region" name="r">
          <option value="">▼地域▼</option>
          {foreach $regionList as $r}
              {if !empty($r.region)}
                  <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
              {/if}
          {/foreach}
        </select>
        <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
        <button type="submit" class="company_list_submit">検索</button>
        <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
      </form>
      </fieldset>
      *}{if !empty($r.region)}
                <option value="{$r.region}"
        {*
        <fieldset class="search id_search">
        <legend>出品番号から検索</legend>
        <form method="GET" id="company_list_form" action="system/bid_list.php">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
          <button type="submit" class="company_list_submit">検索</button>
        </form>
        </fieldset>

        <fieldset class="search">
        <legend>検索</legend>
        <form method="GET" id="company_list_form">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <select class="genre_id" name="g">
            <option value="">▼ジャンル▼</option>
            {foreach $genreList as $g}
                {if !empty($g.id)}
                    <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
                {/if}
            {/foreach}
          </select>

          <select class="region" name="r">
            <option value="">▼地域▼</option>
            {foreach $regionList as $r}
                {if !empty($r.region)}
                    <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
                {/if}
            {/foreach}
          </select>
          <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
          <button type="submit" class="company_list_submit">検索</button>
          <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
        </form>
        </fieldset>
        *}{if $q.region==$r.region} selected="selected"
          {*
          <fieldset class="search id_search">
          <legend>出品番号から検索</legend>
          <form method="GET" id="company_list_form" action="system/bid_list.php">
            <input type="hidden" name="o" value="{$bidOpenId}" />
            <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
            <button type="submit" class="company_list_submit">検索</button>
          </form>
          </fieldset>

          <fieldset class="search">
          <legend>検索</legend>
          <form method="GET" id="company_list_form">
            <input type="hidden" name="o" value="{$bidOpenId}" />
            <select class="genre_id" name="g">
              <option value="">▼ジャンル▼</option>
              {foreach $genreList as $g}
                  {if !empty($g.id)}
                      <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
                  {/if}
              {/foreach}
            </select>

            <select class="region" name="r">
              <option value="">▼地域▼</option>
              {foreach $regionList as $r}
                  {if !empty($r.region)}
                      <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
                  {/if}
              {/foreach}
            </select>
            <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
            <button type="submit" class="company_list_submit">検索</button>
            <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
          </form>
          </fieldset>
        *}{/if}>{$r.region} ({$r.count})</option>

        {*
        <fieldset class="search id_search">
        <legend>出品番号から検索</legend>
        <form method="GET" id="company_list_form" action="system/bid_list.php">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
          <button type="submit" class="company_list_submit">検索</button>
        </form>
        </fieldset>

        <fieldset class="search">
        <legend>検索</legend>
        <form method="GET" id="company_list_form">
          <input type="hidden" name="o" value="{$bidOpenId}" />
          <select class="genre_id" name="g">
            <option value="">▼ジャンル▼</option>
            {foreach $genreList as $g}
                {if !empty($g.id)}
                    <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
                {/if}
            {/foreach}
          </select>

          <select class="region" name="r">
            <option value="">▼地域▼</option>
            {foreach $regionList as $r}
                {if !empty($r.region)}
                    <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
                {/if}
            {/foreach}
          </select>
          <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
          <button type="submit" class="company_list_submit">検索</button>
          <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
        </form>
        </fieldset>
      *}{/if}

      {*
      <fieldset class="search id_search">
      <legend>出品番号から検索</legend>
      <form method="GET" id="company_list_form" action="system/bid_list.php">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
        <button type="submit" class="company_list_submit">検索</button>
      </form>
      </fieldset>

      <fieldset class="search">
      <legend>検索</legend>
      <form method="GET" id="company_list_form">
        <input type="hidden" name="o" value="{$bidOpenId}" />
        <select class="genre_id" name="g">
          <option value="">▼ジャンル▼</option>
          {foreach $genreList as $g}
              {if !empty($g.id)}
                  <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
              {/if}
          {/foreach}
        </select>

        <select class="region" name="r">
          <option value="">▼地域▼</option>
          {foreach $regionList as $r}
              {if !empty($r.region)}
                  <option value="{$r.region}"{if $q.region==$r.region} selected="selected"{/if}>{$r.region} ({$r.count})</option>
              {/if}
          {/foreach}
        </select>
        <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
        <button type="submit" class="company_list_submit">検索</button>
        <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
      </form>
      </fieldset>
    *}{/foreach}
      </select>
      <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="メーカー・型式検索">
      <button type="submit" class="company_list_submit">検索</button>
      <a href="/system/bid_list.php?o={$bidOpenId}">条件リセット</a>
    </form>
    </fieldset>
    *}

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
            <th class="addr1"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=addr1">都道府県</a></th>
            <th class="company"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=company">出品会社</a></th>
            {*
      <th class="min_price"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=min_price">売り切り金額</a></th>
      *}
            {if strtotime($bidOpen["seri_start_date"]) <= time()}
              <th class="same_count">入札数</th>
              <th class="company">最高入札会社</th>
              <th class="min_price">最高入札金額</th>
              <th class="status">落札</th>
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
          <td class="name"><a class="bid" href="system/bid_detail.php?m={$m.id}">{$m.name}</a></td>
          <td class="maker">{$m.maker}</td>
          <td class="model">{$m.model}</td>
          <td class="addr1">{$m.addr1}</td>
          <td class="company">
            <a href="company_detail.php?c={$m.company_id}" target="_blank">
              {'/(株式|有限|合.)会社/'|preg_replace:'':$m.company}
            </a>
          </td>
          {*
    <td class="min_price">{$m.seri_price|number_format}円</td>
    *}

          {if strtotime($bidOpen["seri_start_date"]) <= time()}
            {if !empty($m['seri_amount'])}
              <td class="same_count">{$m['seri_count']|number_format}</td>
              <td class="company_min">
                <a href="company_detail.php?c={$m['seri_company_id']}" target="_blank">{$m['seri_company']}</a>
              </td>
              <td class="min_price">{$m['seri_amount']|number_format}円</td>

              <td class="status">
                {if !empty($m.seri_result)}<span class="bidoff">落札</span>{/if}
              </td>
            {else}
              <td class="same_count"></td>
              <td class="company_min"></td>
              <td class="min_price"></td>
              <td class="status"></td>
            {/if}
          {/if}
        </tr>

        {if $m@last}
        </table>
      {/if}
    {/foreach}

    {*** ページャ ***}
    {include file="include/pager.tpl"}

  {/block}