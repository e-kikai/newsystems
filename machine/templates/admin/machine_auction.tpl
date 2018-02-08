{extends file='include/layout.tpl'}

{block 'header'}

<script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

{/block}

{block 'main'}

<fieldset class="search">
<legend>検索</legend>
<form action="/admin/machine_list.php" method="GET" id="company_list_form">
  <input type="hidden" name="output" value="auction" />
  <select class="genre_id" name="g">
    <option value="">▼ジャンル▼</option>
    {foreach $genreList as $g}
      {if !empty($g.id)}
        <option value="{$g.id}"{if $q.genre_id==$g.id} selected="selected"{/if}>{$g.genre} ({$g.count})</option>
      {/if}
    {/foreach}
  </select>

  {*
  <select class="maker" name="m">
    <option value="">▼メーカー▼</option>
    {foreach $makerList as $m}
      {if !empty($m.maker)}
        <option value="{$m.maker}"{if $q.maker==$m.maker} selected="selected"{/if}>{$m.maker} ({$m.count})</option>
      {/if}
    {/foreach}
  </select>
  <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="キーワード検索">
  <br />
  登録日{html_select_date prefix='start' field_order='YMD' time=$q.start_date
    year_empty='年' month_empty='月' day_empty='日' month_format='%m'
    start_year='2012' reverse_years=true field_separator=" / "} ～
  {html_select_date prefix='end' field_order='YMD' time=$q.end_date
    year_empty='年' month_empty='月' day_empty='日' month_format='%m'
    start_year='2012' reverse_years=true field_separator=" / "}
  *}

  <input type="text" class="keyword_search" name="no" value="{$q.no}" style="width:400px;" placeholder="管理番号">

  <br/ >
  <button type="submit" class="company_list_submit" style="width:200px;margin-top:32px;">CSV出力</button>

  <a href="/admin/machine_auction.php">条件リセット</a>
</form>
</fieldset>

{/block}
