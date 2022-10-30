{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}toppage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
      .list_area li {
        margin: 2px 8px;
        display: block;
      }

      .list_area {
        width: 188px;
        margin-right: 4px;
        float: left;
        margin-bottom: 6px;
      }

      .list_area a {
        line-height: 15px;
      }

      span.nolink {
        color: #999;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <a href=''>中古機械情報 トップページ</a>
  <div class="genres">
    <h2>ジャンル一覧</h2>

    {foreach $largeGenreList as $l}
      {if $l@first}
        <div class="list_area">
        {/if}

        <h3><a href="search.php?l={$l.id}">{$l.large_genre}<span class="count">({$l.count})</span></a></h3>
        {foreach $genreList as $g}
          {if $g.large_genre_id == $l.id}
            <li>
              {if !empty($g.count)}
                <a href="search.php?g={$g.id}">{$g.genre}<span class="count">({$g.count})</span></a>
              {else}
                <span class="nolink">{$g.genre}</span>
              {/if}
            </li>
          {/if}
        {/foreach}

        {if preg_match('/その他NC工作機械|その他一般工作機械|溶接機|その他工作機械周辺機器/', $l.large_genre)}
        </div>
        <div class="list_area">
        {/if}

        {if $l@last}
        </div>
      {/if}
    {/foreach}
  </div>

  <br style="clear:both;" />

  <h2>メーカー一覧</h2>
  <div class="list_area" style="width:188px;">
    {foreach $makerList as $ma}
      <li>
        <a href="search.php?ma={$ma.maker}" title="{$ma.makers}">{$ma.maker}<span class="count">({$ma.count})</span></a>
      </li>

      {if $ma@index != 0 && $ma@index % ceil(count($makerList) / 5) == 0}
      </div>
      <div class="list_area">
      {/if}
    {/foreach}
  </div>

  <br style="clear:both;" />

  <h2>ジャンル/メーカー一覧</h2>
  <div class="list_area" style="width:188px;">
    {foreach $largeMakerList as $lma}
      <li>
        <a href="search.php?l={$lma.large_genre_id}&ma={$lma.maker_master}">{$lma.large_genre}/{$lma.maker_master}<span
            class="count">({$lma.count})</span></a>
      </li>

      {if $lma@index != 0 && $lma@index % ceil(count($largeMakerList) / 5) == 0}
      </div>
      <div class="list_area">
      {/if}
    {/foreach}
  </div>

  <br style="clear:both;" />

  <div class="list_area" style="width:376px;">
    <h2><a href='company_list.php'>会社一覧</a></h2>
    {foreach $companyList as $c}
      <li>
        <a href='company_detail.php?c={$c.id}'>{$c.company|regex_replace:'/(株式|有限|合.)会社/u':''}</a>
        > <a href='search.php?c={$c.id}'>在庫一覧<span class="count">({$c.count})</span></a>
      </li>
    {/foreach}
  </div>

  <div class="list_area" style="width:188px;">
    <h2>都道府県</h2>
    {foreach $addr1List as $a}
      <li>
        {if !empty($a.count)}
          <a href="search.php?k={$a.state}">{$a.state}<span class="count">({$a.count})</span></a>
        {else}
          <span class="nolink">{$a.state}</span>
        {/if}
      </li>
    {/foreach}
  </div>

  <div class="list_area" style="width:188px;">
    <h2>大ジャンル</h2>
    {foreach $xlGenreList as $x}
      <li><a href="search.php?x={$x.id}">{$x.xl_genre}<span class="count">({$x.count})</span></a></li>
    {/foreach}
  </div>

  <div class="list_area" style="width:188px;">
    <h2>Web入札会</h2>
    <li><a href='bid_lp.php'>Web入札会のご案内</a></li>
    <li><a href='bid_schedule.php'>入札会開催日程</a></li>

    <h2>その他ページ</h2>
    <li><a href='news.php?pe=3'>新着情報</a></li>
    <li><a href="{$_conf.catalog_uri}" target="_blank">電子カタログ</a></li>
    <li><a href='{$_conf.website_uri}?%E5%85%A8%E6%A9%9F%E9%80%A3%E3%81%A8%E3%81%AF' target="_blank">全機連とは</a></li>
    <li><a href='sitemap.php'>サイトマップ</a></li>
    <li><a href='contact.php'>事務局にお問い合わせ</a></li>
    <li><a href='help_banner.php'>広告バナー掲載のご案内</a></li>
    <li><a href='{$_conf.website_uri}' target="_blank">全機連ウェブサイト</a></li>
    <li><a href="https://twitter.com/zenkiren" target="_blank">中古機械マシンライフ Twitter</a></li>

    {if Auth::check('member')}
      <h2>会員ページ</h2>
      <li><a href="mylist.php">マイリスト（在庫機械）</a></li>
      <li><a href="mylist_genres.php">マイリスト（検索条件）</a></li>
      <li><a href="mylist_company.php">マイリスト（会社）</a></li>
      <li><a href="/admin/">会員ページ（在庫管理）</a></li>
      <li><a href="logout_do.php">会員ログアウト</a></li>
    {else}
      <li><a href="login.php">会員ログイン</a></li>
    {/if}
  </div>

  <br class="clear" />
{/block}