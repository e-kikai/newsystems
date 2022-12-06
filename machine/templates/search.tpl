{extends file='include/layout.tpl'}

{block 'header'}
  {*}
<meta name="description" content="全機連中古機械情報の{$pageTitle}です" />
<meta name="keywords" content="中古機械,used_machine,全機連,{$pageTitle}" />
*}
  <meta name="description"
    content="{$keywords}、中古機械、{$keywords}の中古機械に関する情報が満載。{$keywords}の中古機械検索や中古機械販売などの中古機械情報ならマシンライフ！全機連が運営する中古機械情報サイトです。{$keywords}の中古機械が様々な条件で検索可能。" />
  {*
<meta name="keywords"
  content="{$keywords},中古機械,中古機械販売,中古機械情報,中古機械検索,中古工作機械,機械選び,工作機械,マシンライフ
" />
*}

  {*
<!-- Google Maps APL ver 3 -->
<script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>
*}

  <script type="text/javascript" src="{$_conf.libjs_uri}/jsrender.js"></script>

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}search.js?202009022"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}mylist_handler.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}ekikaiMylist.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />
  {literal}

    <script type="text/javascript">
      $(function() {
        $('a.all_clear').button();
        $('#bid_area label').button();
        $('#bid_area').buttonset();
      });
    </script>
    <style>
    {/literal}

    {if !Auth::check('mylist') || preg_match('/mylist.php/', $smarty.server.PHP_SELF)}
      {literal}
        table.machines button.mylist {
          display: none;
        }

      {/literal}
    {/if}
  </style>
{/block}

{block 'main'}
  {*
{if preg_match("/search.*\&?l(\[\]|%5B%5D)?=[0-9]+/", $smarty.server.REQUEST_URI)}
<div class='submit_area'>
  <button type='button' class='genre_open'>検索条件を変更</button>
*}
    {*** ジャンル一覧ウィンドウを開く ***}
    {*
  {include file="include/open_genre.tpl"}

  {if Auth::check('mylist')}
    <button type='button' class='input_mylist_genres' value="{','|implode:$largeGenreId}">検索条件をマイリストに追加</button>
  *}

      {*** メールマガジン登録ウィンドウを開く ***}
      {*
    <button type='button' class='input_mailmagazine' value="{','|implode:$largeGenreId}">検索条件でメールを受け取る</button>
    {include file="include/open_mailmagazine.tpl"}
    *}
    {*
  {/if}
  *}
  {*}
</div>
{/if}
*}

  {foreach $bidOpenList as $bo}
    {if !empty($bo.large_genre.id) && !empty($bo['machines'])}
      <a href="bid_list.php?o={$bo.id}&l={$bo.large_genre.id}" class="search_bid_banner"
        onclick="ga('send', 'event', 'seach2bid', 'bid', 'search_banner', 1, true);">
        <div class="bid_title">{$bo.title} 開催中</div>
        <div class="bid_banner_now">出品中の{$bo.large_genre.large_genre}一覧 <span class="bid_banner_click">Click▶</span></div>
      </a>
      <div class="same_area">
        <div class='image_carousel'>
          <div class='carousel_products'>
            {foreach $bo['machines'] as $sm}
              <div class="same_machine">
                <a href="bid_detail.php?m={$sm.id}"
                  onclick="ga('send', 'event', 'seach2bid', 'bid', 'search_detail', 1, true);">
                  <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                  <div class="min_price">
                    <span class="min_price_title">最低入札金額</span>
                    <br />{$sm.min_price|number_format}円
                  </div>
                </a>
              </div>
            {/foreach}
          </div>
        </div>
        {if $sm@total > 6}
          <div class="scrollRight"></div>
          <div class="scrollLeft"></div>
        {/if}
      </div>
    {else}
      <a href="bid_door.php?o={$bo.id}" class="search_bid_banner"
        onclick="ga('send', 'event', 'seach2bid', 'bid', 'search_banner', 1, true);">
        <div class="bid_title">{$bo.title} 開催中</div>
        <div class="bid_banner_now">入札会トップページはこちら <span class="bid_banner_click">Click▶</span></div>
      </a>
    {/if}
  {/foreach}

  {*** 期間絞り込み ***}
  {if !empty($period) || (!empty($start_date) && empty($end_date))}
    <form method="GET" id="period_form">
      <div class='period_area'>
        <li><span class="area_label">期間</span></li>
        <li><label><input type="radio" name="pe" value="1" {if $period==1}checked="checked" {/if} />1日前</label></li>
        <li><label><input type="radio" name="pe" value="2" {if $period==2}checked="checked" {/if} />2日前</label></li>
        <li><label><input type="radio" name="pe" value="3" {if $period==3}checked="checked" {/if} />3日前</label></li>
        <li><label><input type="radio" name="pe" value="7" {if $period==7}checked="checked" {/if} />1週間</label></li>
        <li><label><input type="radio" name="pe" value="14" {if $period==14}checked="checked" {/if} />2週間</label></li>
        <li><label><input type="radio" name="pe" value="31" {if $period==31}checked="checked" {/if} />1ヶ月</label></li>

        <input type="text" name="start_date" id="start_date" value="{$start_date}" placeholder="日付指定" />
      </div>
    </form>
  {/if}

  {if $machineList}

    {*** 表示切り替えタブ／並び替え ***}
    {include file="include/order.tpl"}

    <div class='machine_list list'>
      {include file="include/machine_header.tpl"}

      {*** ページャ ***}
      {include file="include/pager.tpl"}
      <input type="hidden" class="curi" value="{$cUri}" />

      {*** 一括問い合わせ／マイリスト ***}
      {include file="include/mylist_buttons.tpl"}

      <input id="media_dir" type="hidden" value="{$_conf.media_dir}" />

      <table class='machines list'>
        <thead>
          <tr>
            <th class='checkbox'></th>
            <th class='img'></th>
            <th class='tdname'>機械名</th>
            <th class='maker'>メーカー</th>
            <th class='model'>型式</th>
            <th class='year'>年式</th>
            <th class=''>仕様</th>
            {*
        <th class='location'>在庫場所</th>
        *}
            <th class="company">掲載会社・在庫場所</th>
            <th class='buttons reset' style="width:80px;"></th>
          </tr>
        </thead>

        {foreach $machineList as $m}
          {*
    <tbody class="machine">
    *}
          {* セパレータ *}
          {*
    <tr class='separator'><td colspan='8'></td></tr>
    *}

          {*
    <tr>
      <td class='checkbox' rowspan='2'>
        <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
      </td>
      <td class='img' rowspan='2'>
        {if empty($m.deleted_at)}
          <div class='img_area'>
            <a href='/machine_detail.php?m={$m.id}'  target="_blank">
              <div class='name'>{$m.name}</div>
              {if !empty($m.top_img)}
                <img class="top_image hover lazy" src='imgs/blank.png'
                  data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}"
                  data-source="{$_conf.media_dir}machine/{$m.top_img}"
                  alt="中古{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="" /></noscript>
              {else}
                <img class='top_image noimage' src='./imgs/noimage.png'
                  alt="中古{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
              {/if}
            </a>
          </div>
        {else}
          <div class='name'>{$m.name}</div>
        {/if}
      </td>

      <td class='maker'>{$m.maker}</td>
      <td class='model'>{$m.model}</td>
      <td class='year'>{$m.year}</td>
      <td class='locations'>
        <div class="addr1">{$m.addr1}</div>
        {if $m.location}(<span class="location">{$m.location}</span>){/if}
      </td>
      <td class='company_info'>
        <a href='/company_detail.php?c={$m.company_id}'  target="_blank">{$m.company}</a>
        <div class='tel'>TEL: {$m.contact_tel}</div>
        <div class='fax'>FAX: {$m.contact_fax}</div>
      </td>
      <td class='buttons'>
        {if empty($m.deleted_at)}
          {if empty($m.contact_mail)}
            <div class='contact none'>問い<br />合わせ</div>
          {else}
            <a class='contact' href='/contact.php?m={$m.id}'  target="_blank">問い<br />合わせ</a>
          {/if}
          {if Auth::check('mylist') && !preg_match('/mylist.php/', $smarty.server.PHP_SELF)}
            <button class='mylist' value='{$m.id}'>マイリスト<br />追加</button>
          {/if}
        {else}
          売却日 : {$m.deleted_at|date_format:'%Y/%m/%d'}
        {/if}
      </td>
    </tr>
    *}
          <tr class="machine">
            <td class='checkbox'>
              <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
            </td>
            <td class='img'>
              {if empty($m.deleted_at)}
                <div class='img_area'>
                  <a href='/machine_detail.php?m={$m.id}' target="_blank">
                    {if !empty($m.top_img)}
                      <img class="top_image hover lazy" src='imgs/blank.png'
                        data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}"
                        data-source="{$_conf.media_dir}machine/{$m.top_img}" alt="中古{$m.name} {$m.maker} {$m.model}" />
                      <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="" /></noscript>
                    {else}
                      <img class='top_image noimage' src='./imgs/noimage.png' alt="中古{$m.name} {$m.maker} {$m.model}" />
                    {/if}
                  </a>
                </div>
              {/if}
            </td>
            <td class="tdname">
              <a href='/machine_detail.php?m={$m.id}' target="_blank">
                {*** 主能力 ***}
                {if !empty($m.capacity_label) && !empty($m.capacity) && !preg_match('/^[0-9]/', $m.name)}
                  {$m.capacity}{$m.capacity_unit}{$m.name}
                {else}
                  {$m.name}
                {/if}
              </a>
            </td>
            <td class='maker'>{$m.maker}</td>
            <td class='model'>{$m.model}</td>
            <td class='year'>{$m.year}</td>

            <td class=''>
              <div>{$m.spec|mb_strimwidth :0:120:"…"}</div>


              {*** youtube ***}
              {*
        {if !empty($m.youtube) && preg_match("/https?:\/\/youtu.be\/(.+)/", $m.youtube, $res)}
          <a href="javascript:void(0)" data-youtubeid="{$res[1]}" class="label movie">動画</a>
        {/if}
        *}

              {if !empty($m.youtube) && preg_match_all('/([\w\-]{11})/', $m.youtube, $res)}
                {foreach $res[0] as $y}
                  <a href="javascript:void(0)" data-youtubeid="{$y}" class="label movie" title="クリックで動画再生します">動画</a>
                {/foreach}
              {/if}

              {*** 入札会 ***}
              {if !empty($bidMachineIds[$m.id])}
                <a href="bid_detail.php?m={$bidMachineIds[$m.id].bid_machine_id}" class="label bid"
                  target="_blank">Web入札会出品中</a>
              {/if}

              {*** ラベル枠 ***}
              {if $m.view_option == 2}<div class="label vo2">商談中</div>{/if}
              {if $m.commission == 1}<div class="label commission">試運転可</div>{/if}
              {if !empty($m.pdfs)}
                {foreach $m.pdfs as $key => $val}
                  <a href="{$_conf.media_dir}machine/{$val}" class="label pdf" target="_blank">PDF:{$key}</a>
                {/foreach}
              {/if}
              {if Auth::check('member') && !empty($m.catalog_id)}
                <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$m.catalog_id}" class="label catalog"
                  target="_blank">電子カタログ</a>
              {/if}

              {*
        {if !empty($m.label_title)}
          {if $m.label_url}
            <a class="label org" href="{$m.label_url}" target="_blank" style="background:{$m.label_color};">{$m.label_title}</a>
          {else}
            <div class="label org" style="background:{$m.label_color};">{$m.label_title}</div>
          {/if}
        {/if}
        *}
            </td>

            <td class="company">
              <a href='/company_detail.php?c={$m.company_id}' target="_blank">
                {'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company|trim}
              </a>
              <div class="addr1">{$m.addr1}</div>
              {if $m.location}(<span class="location">{$m.location}</span>){/if}
            </td>
            <td class='buttons'>
              {if empty($m.deleted_at)}
                {if empty($m.contact_mail)}
                  <div class='contact none'>問い合わせ</div>
                {else}
                  <a class='contact' href='/contact.php?m={$m.id}' target="_blank">問い合わせ</a>
                {/if}

                {if Auth::check('mylist') && !preg_match('/mylist.php/', $smarty.server.PHP_SELF)}
                  <button class='mylist' value='{$m.id}'>マイリスト</button>
                {/if}
              {else}
                売却日 : {$m.deleted_at|date_format:'%Y/%m/%d'}
              {/if}
            </td>
          </tr>
          {*
    </tbody>
    *}
        {/foreach}
      </table>

      {*** 一括問い合わせ／マイリスト ***}
      {include file="include/mylist_buttons.tpl"}

      {*** ページャ ***}
      {include file="include/pager.tpl"}
    </div>

    {*** 画像リスト ***}
    {*
<div class='machine_list img' style="display:none;">
  {include file="include/pager.tpl"}

  {include file="include/mylist_buttons.tpl"}

  <table class='machines img'></table>

  {include file="include/mylist_buttons.tpl"}

  {include file="include/pager.tpl"}
</div>
*}

    {*** 地図で表示 ***}
    {*
<div class='machine_list map' style="display:none;">
  <div class="maplocation_area"></div>
  <div id="gmap"></div>
  <div class='machines map'></div>
</div>
*}

    {*** 会社別一覧 ***}
    <div class='machine_list company' style="display:none;">
      {include file="include/machine_company.tpl"}
    </div>
  {/if}

  {assign "keywords" "{$keywords|regex_replace:"/[.,\s]+/":"|"}"}
  {include file="include/mnok_ads.tpl"}

  <div class="keywords">{$keywords|regex_replace:"/[.,\s]+/":"|"}</div>
{/block}