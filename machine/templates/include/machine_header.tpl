<div class="machine_header">
  <a class="all_clear">すべての絞り込み解除</a>

  {*** ジャンル絞り込み ***}
  {if !empty($genreList)}
    <div class='filter_area genre_area'>
      <li>
        <span class="area_label">ジャンル</span>
        <a class="genre_all" href='{$cUrl}'>絞込解除</a>
      </li>
      {foreach $genreList as $g}
        {if $g.count && !empty($g.genre)}
          <li>
            <label{if mb_strwidth($g.genre) > 16 || $g.count > 99} title="{$g.genre} ({$g.count})" {/if}>
              <input type="checkbox" name="g[]" value="{$g.id}" />
              <span class="check_label">{$g.genre|mb_strimwidth :0:16:"…"}</span><span class="count">({$g.count})</span>
              </label>
          </li>
        {/if}
      {/foreach}
    </div>
  {/if}

  {*** メーカー絞り込み ***}
  {if !empty($makerList)}
    <div class='filter_area maker_area'>
      <li>
        <span class="area_label">メーカー</span>
        <a class="maker_all" href='{$cUrl}'>絞込解除</a>
      </li>
      {foreach $makerList as $makey => $ma}
        {if $ma.count && !empty($ma.maker)}

          {if $makey == 12}
            <li>
              <a class="maker_other_show" href="">▼もっと表示▼</a>
            </li>
          {/if}

          <li {if $makey >= 12}class="other" {/if}>
            <label title="{if $ma.makers}{$ma.makers}{else}{$ma.maker}{/if} ({$ma.count})">
              <input type="checkbox" name="ma[]" value="{if $ma.makers}{$ma.makers}{else}{$ma.maker}{/if}" />
              <span class="check_label">{$ma.maker|mb_strimwidth :0:14:"…"}</span><span class="count">({$ma.count})</span>
            </label>
          </li>
        {/if}
      {/foreach}
    </div>
  {/if}

  {*** 型式絞り込み ***}
  <div class='filter_area model2_area'>
    <span class="area_label">型式</span>
    <input type="text" id="model2" class="model2" value="" />

    {*** 都道府県絞り込み ***}
    {if !empty($addr1List)}
      <span class="area_label">地域・都道府県</span>
      <span class='location_area'>
        <select class="location" name="lo">
          <option value="">すべて表示</option>
          {foreach $addr1List as $lo}
            {if $lo.count && !empty($lo.addr1)}
              <option value="{$lo.addr1}">{if $lo.sorder != 0}　{/if}{$lo.addr1} ({$lo.count})</option>
            {/if}
          {/foreach}
        </select>
      </span>
      {*
  <li>
    <a class="addr1_all" href='{$cUrl}'>絞込解除</a>
  </li>
  *}
    {/if}

    {*** NC装置 ***}
    {if !empty($isNc)}
      <span class="area_label">NC装置</span>
      <span class="nc_area">
        <select class="nc" name="nc">
          <option value="">すべて表示</option>
          <option value="ファナック|Fanuc|F-">ファナック</option>
          <option value="メルダス|Meldas">メルダス</option>
          <option value="トスナック|TOSNUC|TOS-">トスナック</option>
          <option value="OSP">OSP</option>
          <option value="プロフェッショナル|Professional|Pro-">プロフェッショナル</option>
          <option value="マザトロール|MAZ|Mazatrol">マザトロール</option>
        </select>
      </span>
    {/if}
    {*
  <div class="bid_area" id="bid_area">
    <label>
      <input type="radio" name="bid" class="bid" value="" checked="checked" />
      <span class="check_label">すべて</span>
    </label>
    <label>
      <input type="radio" name="bid" class="bid" value="bid" />
      <span class="check_label">Web入札会出品中</span>
    </label>
  </div>
  *}
  </div>

  {*
{if !empty($addr1List)}
  <div class='filter_area location_area'>
    <li>
      <span class="area_label">都道府県</span>
      <a class="addr1_all" href='{$cUrl}'>すべて表示</a>
    </li>
    {foreach $addr1List as $lo}
      {if $lo.count && !empty($lo.addr1)}
        <li>
          <label>
            <input type="checkbox" name="lo[]" value="{$lo.addr1}">
            <span class="check_label">{$lo.addr1}</span><span class="count">({$lo.count})</span>
          </label>
        </li>
      {/if}
    {/foreach}
  </div>
{/if}
*}

  {*** 能力絞り込み ***}
  {if !empty($capacityList)}
    <div class='filter_area capacity_area'>
      {foreach $capacityList as $c}
        {if !empty($c['capacity_label']) }
          {if $c@first}
            <div class="capacity_label_area first">
              <li>
                <a class="capacity_all" href='{$cUrl}'>絞込解除</a>
              </li>

              <li>
                <span class="area_label">{$c.capacity_label}</span>
              </li>
              {elseif (($c.capacity_label != $capacityList[$c@key - 1].capacity_label) ||
                                                                                                                                  ($c.capacity_unit != $capacityList[$c@key - 1].capacity_unit))}
            </div>
            <div class="capacity_label_area">
              <li>
                <span class="area_label">{$c.capacity_label}</span>
              </li>
            {/if}
            <li>
              <label>
                <input type="checkbox" name="c[]" value="{$c.capacity}" data-max="{$c.capacity_max}"
                  data-unit="{$c.capacity_unit}" data-label="{$c.capacity_label}">
                <span class="check_label">{$c.capacity}{$c.capacity_unit}～</span><span class="count">({$c.count})</span>
              </label>
            </li>
          {/if}

          {if $c@last}
        </div>{/if}
      {/foreach}
    </div>
  {/if}

  <div class="sort_area" id="sort_area">
    <span class="area_label year">並び替え</span>
    <select class="sort">
      <option value="">ジャンル・機械名順</option>
      <option value="year_desc">年式:新しい順</option>
      <option value="year_asc">年式:古い順</option>
      <option value="created_at_desc">登録日時:新しい順</option>
      <option value="created_at_asc">登録日時:古い順</option>
      {*
      <option value="min_price_asc">Web入札会:最低入札価格の安い順</option>
      <option value="min_price_desc">Web入札会:最低入札価格の高い順</option>
      *}
    </select>
  </div>
</div>