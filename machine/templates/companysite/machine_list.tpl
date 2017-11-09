{extends file='companysite/layout.tpl'}

{block 'header'}
<meta name="description" content="" />
<meta name="keywords" content="中古機械" />

{literal}
<script type="text/javascript">
$(function() {
    //// サムネイル画像の遅延読み込み（Lazyload） ////
    $('img.lazy').css('display', 'block').lazyload({
        effect: "fadeIn"
    });
});
</script>
<style type="text/css">

</style>
{/literal}
{/block}

{block 'main'}
<h1>在庫一覧</h1>

<fieldset class="search">
<legend>検索</legend>
<form method="GET" id="company_list_form">
  <select class="genre_id" name="g">
    <option value="">▼ジャンル▼</option>
    {foreach $genreList as $g}
      {if !empty($g.id)}
        <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
      {/if}
    {/foreach}
  </select>

  <select class="maker" name="m">
    <option value="">▼メーカー▼</option>
    {foreach $makerList as $m}
      {if !empty($m.maker)}
        <option value="{$m.maker}"{if $q.maker==$m.maker} selected="selected"{/if}>{$m.maker} ({$m.count})</option>
      {/if}
    {/foreach}
  </select>
  <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="キーワード検索">

  <button type="submit" class="company_list_submit">検索</button>
  
  <a href="machine_list.php">条件リセット</a>
</form>
</fieldset>

{if empty($machineList)}
  <div class="error_mes">条件に合う機械はありません</div>
{/if}

{*** ページャ ***}
{include file="include/pager.tpl"}

{foreach $machineList as $m}
  {if $m@first}
  <table class="machines list">
    <tr>
      <th class="number">管理番号</th>
      <th class="img"></th>
      <th class="name">機械名</th>
      <th class="maker">メーカー</th>
      <th class="model">型式</th>
      <th class="year">年式</th>
      <th class="location">在庫場所</th>
      <th class="spec">仕様</th>
      <th class="buttons">お問い合せ</th>
    </tr>
  {/if}
  
  <tr class="machine {cycle values='even, odd'}">
    <td class="number">{$m.no}</td>
    <td class="img">
      {if !empty($m.top_img)}
        <a href="machine_detail.php?m={$m.id}">
          <img class="lazy" src='{$_conf.site_uri}imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
          <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
        </a>
      {/if}
    </td>
    <td class="name"><a href="machine_detail.php?m={$m.id}">{$m.name}</a></td>
    <td class="maker">{$m.maker}</td>
    <td class="model">{$m.model}</td>
    <td class="year">{$m.year}</td>
    <td class="location">{$m.location}{if !empty($m.addr1)}<br />({$m.addr1}){/if}</td>
    <td class="spec">
      {if !empty($m.capacity_label) && !empty($m.capacity)}{$m.capacity}{$m.capacity_unit}{/if}
      {if !empty($m.spec)}
        <div class="others">{$m.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">' nofilter}</div>
      {/if}
    </td>
    <td class="buttons"><a href="contact.php?m={$m.id}">お問い合せ</a></td>
  </tr>
  
  {if $m@last}
    </table>
  {/if}
{/foreach}

{*** ページャ ***}
{include file="include/pager.tpl"}
<br style="clear:both;" />
{/block}
