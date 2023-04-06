{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}bid_list.css" rel="stylesheet" type="text/css" />

  {*
<script type="text/javascript" src="{$_conf.libjs_uri}/easyab.min.js"></script>
*}

  <meta name="description"
    content="{$bidOpen.title}に出品された{$siteName}の商品。全機連が主催する全国展開の中古工作機械・工具のWeb入札会開催中！下見期間{$bidOpen.preview_start_date|date_format:'%Y/%m/%d'}({B::strtoweek($bidOpen.preview_start_date)})～{$bidOpen.preview_end_date|date_format:'%m/%d'}({B::strtoweek($bidOpen.preview_end_date)})。" />

  {*
<meta name="keywords" content="{$siteName},中古機械,Web入札会,工具,全機連,マシンライフ" />
*}
  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  {*
{if $bidOpen.status == 'bid'}
  <div>
    商品への入札、出品者へのお問い合せは、
    お近くの<a href="bid_company_list.php?o={$bidOpenId}">全機連会員</a>を通して行ってください
  </div>
{/if}
*}

  {include "include/bid_timer.tpl"}

  {*
<div class="sp_area">
  <img class="" src="/imgs/bid_frow01_02.gif" usemap="#bidfrow"/>

  <map name="bidfrow">
    <area shape="rect" coords="0,0,240,201" href="bid_door.php?o={$bidOpenId}" alt="商品リスト">
    <area shape="rect" coords="480,0,720,120" href="bid_company_list.php?o={$bidOpenId}" target="_blank" alt="Web入札会 全機連会員一覧">
  </map>
</div>
*}

  {*
<fieldset class="search id_search">
<legend>商品IDから検索</legend>
<form method="GET" id="company_list_form" action="bid_detail.php">
  <input type="text" class="m number" name="m" value="" placeholder="商品ID" />
  <button type="submit" class="company_list_submit">検索</button>
</form>
</fieldset>
*}

  <div class="search">
    並び替え:
    {foreach ['name' => 'ジャンル・機械名', 'list_no' => '出品番号', 'model' => '型式',
                          'year_desc' => '年式:新しい順', 'year' => '年式:古い順', 'location' => '都道府県',
                          'min_price' => '最低入札金額:安い順', 'min_price_desc' => '最低入札金額:高い順'] as $key => $o}
    {if $key == $q.order || ($key == 'name' && empty($q.order))}
      <span class="order_selected">{$o}</span>
    {else}
      <a class="order" href="bid_list.php?o={$bidOpenId}{$siteUrl}&k={Req::query('k')}&order={$key}">{$o}</a>
    {/if}
  {/foreach}
</div>

{if empty($bidMachineList)}
  <div class="error_mes">条件に合う商品はありません</div>
{/if}

{*** ページャ ***}
{include file="include/pager.tpl"}

{foreach $bidMachineList as $m}
  {*
  {if $m@first}
  <table class="machines list">
    <thead>
    <tr>
      <th class="img"></th>
      <th class="bid_machine_id"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=id">商品ID</a></th>
      <th class="name"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=name">機械名</a></th>
      <th class="maker"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=maker">メーカー</a></th>
      <th class="model"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=model">型式</a></th>
      <th class="year"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=year">年式</a></th>
      <th class="region"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=location">出品地域</a></th>
      <th class="company"><a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=company">出品会社</a></th>
      <th class="spec">仕様</th>
      <th class="min_price">最低入札金額<br />
        <a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=min_price">▼</a>
        <a href="{$cUri|regex_replace:"/(\&?order=[a-z_]+)/":""}&order=min_price_desc">▲</a>
      </th>
    </tr>
    </thead>
  {/if}

  <tr>
    <td class="img">
      {if !empty($m.top_img)}
        <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
        <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' /></noscript>
      {/if}
    </td>
    <td class="bid_machine_id">{$m.id}</td>
    <td class="name"><a class="bid" href="bid_detail.php?m={$m.id}">{$m.name}</a></td>
    <td class="maker">{$m.maker}</td>
    <td class="model">{$m.model}</td>
    <td class="year">{$m.year}</td>
    <td class="region">{$m.addr1}</td>
    <td class="company">
      <a href="company_detail.php?c={$m.company_id}" target="_blank">
        {'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company}
      </a><br />
      <a class="contact" href="contact.php?c={$m.company_id}&b=1&o={$bidOpenId}&bm={$m.id}" target="_blank">お問い合せ</a>
    </td>
    <td class="spec">
      {if !empty($m.capacity_label) && !empty($m.capacity)}{$m.capacity}{$m.capacity_unit}{/if}
      {if !empty($m.spec)}
        <div class="others">{$m.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">' nofilter}</div>
      {/if}
    </td>
    <td class="min_price">{$m.min_price|number_format}円</td>
  </tr>
  {if $m@last}
    </table>
  {/if}
*}

  {*
{if $m@first}
  <div class="machine_label">
    <div class="id">商品ID</div>
    <div class="name">商品名</div>
    <div class="year">年式</div>
    <div class="location">在庫場所</div>
    <div class="company">出品会社</div>
  </div>
{/if}
*}

  <div class="product_line">
    <div class="img_area">
      <a href="bid_detail.php?m={$m.id}{if in_array($m.id, $recommendIds)}&recommend=1{/if}">
        {if !empty($m.top_img)}
          <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/{$m.top_img}" alt='' />
          <noscript><img src="{$_conf.media_dir}machine/{$m.top_img}" alt='' /></noscript>
        {else}
          <img class='noimage' src='./imgs/noimage.png' alt="" />
        {/if}
      </a>
    </div>

    {*** 商品名 ***}
    {*
    <div class="info_area"></div>
    *}

    <a class="bid" href="bid_detail.php?m={$m.id}">
      {* <a class="bid" href="bid_detail.php?m={$m.id}{if in_array($m.id, $recommendIds)}&recommend=1{/if}"> *}
      {($m.name|cat:" "|cat:$m.maker|cat:" "|cat:$m.model)|mb_strimwidth :0:60:"..."}
    </a>

    <div class="id">出品番号 : {* {$m.id} *}{$m.list_no}</div>

    {if !empty($m.imgs)}
      <div class="imgs_num">{count($m.imgs) + 1}photos</div>
    {/if}

    {*** 最低入札金額 ***}
    {*
    <div class="price_label">最低入札金額</div>
    *}
    <div class="min_price">{$m.min_price|number_format}円</div>

    <div class="spec">{$m.spec|mb_strimwidth:0:200:"..."}</div>

    <div class="year">{if $m.year}{$m.year}年式{/if}</div>


    <div class="region">{$m.addr1}</div>

    {*
    <a href="company_detail.php?c={$m.company_id}" class="company" target="_blank">
      {'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company}
    </a>
    *}

    {*
    <a class="bid_detail_02" href="bid_detail.php?m={$m.id}" target="_blank">商品詳細ページ</a>
    *}

    <a class="contact" href="contact.php?o={$bidOpenId}&bm={$m.id}" target="_blank"
      {* onclick="_gaq.push(['_trackEvent', 'bid_contact', 'list']);" *}
      onclick="ga('send', 'event', 'bid_contact', 'list');">問い合わせ</a>

    {*
    {if preg_match('/mylist/', $siteUrl)}
      <button class="delete_mylist" value="{$m.id}">マイリスト<br />削除</button>
    {elseif !empty($smarty.session.bid_mylist) && !empty($smarty.session.bid_mylist[$m.id])}
      <a class="mylist_text_link" href="/bid_list.php?o={$bidOpenId}&mylist=1">お気に入り表示</a>
    {else}
      <button class="mylist" value="{$m.id}">マイリスト<br />追加</button>
    {/if}
    *}

    {if !empty($smarty.session.bid_batch) && !empty($smarty.session.bid_batch[$m.id])}
      <button class="mylist btn btn-primary" value="{$m.id}" style="display:none;"
        onclick="ga('send', 'event', 'bid_batch', 'set', '{$m.id}', 1, true);"><span
          class="mylist_pluse">＋</span>一括問い合わせに追加</button>
      <button class="delete_mylist btn btn-primary" value="{$m.id}"
        onclick="ga('send', 'event', 'bid_batch', 'delete', '{$m.id}', 1, true);">一括問い合わせ削除</button>
    {else}
      <button class="mylist btn btn-primary" value="{$m.id}"
        onclick="ga('send', 'event', 'bid_batch', 'set', '{$m.id}', 1, true);"><span
          class="mylist_pluse">＋</span>一括問い合わせに追加</button>
      <button class="delete_mylist btn btn-primary" value="{$m.id}" style="display:none;"
        onclick="ga('send', 'event', 'bid_batch', 'delete', '{$m.id}', 1, true);">一括問い合わせ削除</button>
    {/if}

  </div>
{/foreach}

{*** ページャ ***}
{include file="include/pager.tpl"}

{assign "keywords" "{$pankuzuTitle|regex_replace:"/[.\/,\s]+/":"|"}"}
{include file="include/mnok_ads.tpl"}

{/block}