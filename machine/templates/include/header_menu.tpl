{**
 * 共通ヘッダメニュー
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/04/24
 *}
<div class="header_menu">
  <a class="menu first" href="" title="中古機械情報TOPに戻る"
    {* onClick="_gaq.push(['_trackEvent', 'pankuzu', 'toppage', 'heder_menu', 1, true]);" *}
    onClick="ga('send', 'event', 'pankuzu', 'toppage', 'heder_menu', 1, true);">
    TOP
    {*
    <img class="even" src="imgs/menu_top.png" alt="中古機械情報 マシンライフ 中古旋盤,中古フライス等の中古機械情報をご提供" />
    <img class="hover" src="imgs/menu_top_hover.png" alt="中古機械情報 マシンライフ 中古旋盤,中古フライス等の中古機械情報をご提供" />
    *}
  </a>
  <div class="submenu">
    <div>新着一覧</div>
    <ul>
      <a onclick="ga('send', 'event','toppage', 'news', 'machine', 1, true);" href="news.php">新着中古機械一覧</a>
      <a onclick="ga('send', 'event','toppage', 'news', 'tool', 1, true);" href="news.php?b=1">新着中古工具一覧</a>
    </ul>
  </div>

  <a href="company_list.php">会社一覧</a>
  {*
  <div class="submenu">
    <a href="kaitashi_list.php">買いたし情報</a>
    <ul>
      <a href="kaitashi_form.php">買いたし情報登録</a>
      <a href="kaitashi_list.php">買いたし情報一覧</a>
    </ul>
  </div>
  *}
  <div class="submenu">
    <div class="mylist">マシンライフについて</div>
    <ul>
      <a href="http://www.zenkiren.org/index.php?%E5%85%A8%E6%A9%9F%E9%80%A3%E3%81%A8%E3%81%AF"
        target="_blank">全機連とは</a>
      <a href="sitemap.php">サイトマップ</a>
      {*
      <a href="news.php?pe=1">新着中古機械情報</a>
      *}
      <a href="help_rank.php">会員区分について</a>
      <a href="contact.php">事務局にお問い合わせ</a>
    </ul>
  </div>

  <a href="help_banner.php" target="_blank">広告バナーのご案内</a>
  <a href="{$_conf.catalog_uri}" target="_blank">電子カタログ</a>

  {if Auth::check('member')}
    <div class="submenu">
      <div class="mylist">会員メニュー</div>
      <ul>
        <a href="mylist.php">マイリスト（機械）</a>
        {*
        <a href="mylist_genres.php">マイリスト（検索条件）</a>
        *}
        <a href="mylist_company.php">マイリスト（会社）</a>
        <a href="/admin/">会員ページ(在庫管理)</a>
        {if Auth::check('system')}
          <a href="/system/">管理者ページ</a>
        {/if}
        <a href="logout_do.php">ログアウト</a>
      </ul>
    </div>
  {else}
    <a href="login.php">会員ログイン</a>
  {/if}
</div>