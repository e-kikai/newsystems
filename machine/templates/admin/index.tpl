
{extends file='include/layout.tpl'}

{block name='header'}

{* ミニブログ *}
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}/miniblog.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}/miniblog.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
});
</script>
<style type="text/css">
/*** トップメニュー ***/
ul.top_menu {
  width: 500px;
  margin: 16px auto;
}

ul.top_menu li {
  list-style : none;
  font-size : 15px;
  height : 24px;
  line-height : 24px;
  padding : 0 16px;
}

.suspend {
  color : #999;
}

/*** 書きこみ ***/
.info_area {
  margin-right: 8px;
  width: 400px;
  display: inline-block;
  margin-bottom: 8px;
  vertical-align: top;
  float: left;
  margin-right: 32px;
}

.infotitle {
  background: #923431;
  color: white;
  padding: 3px 8px;
  width: 240px;
  text-align: center;
  border-radius: 8px 8px 0 0;
}

.infomations {
  border: 1px solid #923431;
  background: #FFF;
  width: 400px;
  height: 160px;
  font-size: 13px;
  overflow-y: scroll;
  box-shadow: 0 6px 6px rgba(0,0,0,0.1) inset;
  margin-bottom: 8px;
}

.infomations.miniblog {
  height: 600px;
}


.info {
  padding: 3px 0;
  border-bottom: 1px dotted #CCC;
  margin: 4px 8px;
  width: auto;
}

button.miniblog_response {
  display: inline-block;
  width: 60px;
}

.info_date {
  display: inline-block;
  margin-right: 3px;
  color: #AAA;
}

.info_name {
  display: inline-block;
  margin-right: 3px;
  font-weight: bold;
  color: #0A0;
}

.info_contents {
  position: relative;
}

.info_goal {
  display: inline-block;
  margin-right: 3px;
  font-weight: bold;
}

.info_no {
  display: inline-block;
  margin-right: 3px;
}

.info_goal.cell {
  color: #C00;
}

.info_goal.buy {
  color: #00C;
}

.info_end_date {
  display: inline-block;
  margin-right: 3px;
  color: #999;
}

.info_link {
  display: block;
  position: absolute;
  right: 3px;
  bottom: 0;
}

ul.top_menu {
  float: left;
  margin-top: 0;
}

ul.top_menu:after {
  content: "";
  clear: both;
  height: 0;
  display: block;
  visibility: hidden;
}

/*** 目標枠 ***/
span.count_no {
  font-size: 22px;
  font-weight: bold;
  font-style: italic;
  padding: 0 8px;
  color: #903;
}

div.count, div.maker_count, div.goal {
  position: absolute;
  right: 8px;
  top: -54px;
  font-weight: bold;
  font-size: 15px;
  vertical-align: baseline;
}

div.count span.count_label {
  width: 64px;
  display: inline-block;
}

.label {
  font-size:13px;
}

div.logininfo {
  position: absolute;
  right: 16px;
  top: -80px;
  vertical-align: baseline;
}
</style>
{/literal}
{/block}

{block 'main'}
<div class="info_area">
  {*
  <div class="count">
    在庫機械の総登録数  <span class="count_no">{$mCountAll|number_format}</span> 件<br />
    {if $mCountAll < 10000}
      目標1万件まで、あと <span class="count_no">{(10000 - $mCountAll)|number_format}</span> 件
    {else}
      <span class="count_no">目標1万件達成！！</span>
    {/if}
  </div>
  *}

  <div class="count">
    <span class="count_label">会員名</span>   : {$company}<br />
    <span class="count_label">会員区分</span> : {Companies::getRankLabel($rank)}
    <a href="help_rank.php" style="font-weight:normal;font-size:13px;">会員区分と利用サービスについて</a>
    {*
    マシンライフ参加会社数  <span class="count_no">{$cCountByEntry|number_format}</span> 社<br />
    {if $cCountByEntry < 100}
      目標100社まで、あと <span class="count_no">{(100 - $cCountByEntry)|number_format}</span> 社
    {else}
      <span class="count_no">参加者100社目標達成致しました。ありがとうございます</span>
    {/if}
    *}
  </div>

  <div class="logininfo">
    {*
    {$userName} 様 - {$company}({$treenames}) {Companies::getRankLabel($company.rank)}
    *}
  </div>

  <div class="infotitle">事務局からのお知らせ</div>
  <div class="infomations">
    {if !empty($infoList)}
      {foreach $infoList as $i}
        <div class="info">
          {if strtotime($i.created_at) > strtotime('-1week')}
            <div class="cjf_new">NEW!</div>
          {/if}
          <div class="info_date">{$i.info_date|date_format:'%Y/%m/%d'}</div>
          <div class="info_contents">{$i.contents|escape|auto_link|nl2br nofilter}</div>
        </div>
      {/foreach}
    {else}
      <div class="info">まだ書きこみはありません</div>
    {/if}
  </div>

  <div class="infotitle">売りたし買いたし</div>
  <div class="infomations">
    {if !empty($urikaiList)}
      {foreach $urikaiList as $uk}
        <div class="info">
          {if !empty($uk.end_date)}
            <div class="info_end_date">(解決済)</div>
          {elseif strtotime($uk.created_at) > strtotime('-1week')}
            <div class="cjf_new">NEW!</div>
          {/if}
          <div class="info_goal {$uk.goal}">{if $uk.goal == "cell"}売りたし{else}買いたし{/if}</div>
          <div class="info_no">No.{$uk.id}</div>
          <div class="info_name">{'/(株式|有限|合.)会社/u'|preg_replace:'':$uk.company}</div>
          <div class="info_date">{$uk.created_at|date_format:'%Y/%m/%d'}</div>

          <div class="info_contents" data-id="{$uk.id}">
            {$uk.contents|mb_substr:0:26}
            <a href="/admin/urikai_detail.php?id={$uk.id}" class="info_link">→詳細を見る</a>
          </div>
        </div>
      {/foreach}
    {else}
      <div class="info">まだ書きこみはありません</div>
    {/if}
  </div>

  <div class="infotitle">書きこみ</div>
  <div class="infomations miniblog">
    {if !empty($miniblogList)}
      {foreach $miniblogList as $mi}
        <div class="info">
          {if strtotime($mi.created_at) > strtotime('-1week')}
            <div class="cjf_new">NEW!</div>
          {/if}
          <div class="info_name">{'/(株式|有限|合.)会社/u'|preg_replace:'':$mi.user_name}</div>
          <div class="info_date">{$mi.created_at|date_format:'%Y/%m/%d %H:%M'}</div>
          <button type="button" class="miniblog_response" data-id="{$mi.id}">返信</button>
          <div class="info_contents" data-id="{$mi.id}">{$mi.contents|escape|auto_link|nl2br nofilter}</div>
        </div>
      {/foreach}
    {else}
      <div class="info">まだ書きこみはありません</div>
    {/if}
  </div>
</div>

<ul class="top_menu">

  {if Companies::checkRank($rank, 'A会員')}
  <h2>在庫機械情報</h2>
  <li>
    <a href="admin/machine_list.php">在庫機械一覧(変更・削除)</a> |
    <a href="admin/machine_form.php">新規登録</a> >>
    <a href="/search.php?c={$_user.company_id}" target="_blank">自社在庫一覧(確認用)</a>
  </li>
  <li>
    <a href="/admin/machine_list.php?output=csv&limit=999999999">在庫機械一覧CSV出力</a>
  </li>

  <li><a href="#" data-youtubeid="UbWiwrTvjiU" class="movie">[ヘルプ動画] Internet Explorerでの在庫情報登録</a></li>
  <li><a href="#" data-youtubeid="pm-Oqemnwz8" class="movie">[ヘルプ動画] Firefox,Safari,GoogleChromeでの在庫情報登録</a></li>
  <li><a href="#" data-youtubeid="9f9tLOLTleg" class="movie">[ヘルプ動画] Youtubeの動画登録</a></li>
  {/if}

  <h2>お問い合わせ</h2>
  <li><a href="admin/contact_list.php">お問い合わせ一覧</a></li>

  {if Companies::checkRank($rank, 'B会員')}
    <h2>売りたし買いたし</h2>
    <li>
      <a href="admin/urikai_list.php">売りたし買いたし書き込み一覧</a> |
      <a href="admin/urikai_form.php">書き込む</a>
    </li>
  {/if}

  <h2>Web入札会</h2>
  {if !empty($bidOpenList)}
    <li>▼▼▼現在開催中の入札会▼▼▼</li>
    {foreach $bidOpenList as $b}
      <div class="bid_open">
        <h3>{$b.title} :: {BidOpen::statusLabel($b.status)}</h3>
        <dl class="bid_date">
          <dt>出品期間</dt>
          <dd>{$b.entry_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.entry_end_date|date_format:'%m/%d %H:%M'}</dd><br />
          <dt>下見期間</dt>
          <dd>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</dd><br />
          <dt>入札期間</dt>
          <dd>{$b.bid_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.bid_end_date|date_format:'%m/%d %H:%M'}</dd><br />
          <dt>入札日時(一般向)</dt>
          <dd>{$b.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</dd><br />
          <dt>請求日</dt>
          <dd>{$b.billing_date|date_format:'%Y/%m/%d'}</dd><br />
          <dt>支払日</dt>
          <dd>{$b.payment_date|date_format:'%Y/%m/%d'}</dd><br />
          <dt>搬出期間</dt>
          <dd>{$b.carryout_start_date|date_format:'%Y/%m/%d'} ～ {$b.carryout_end_date|date_format:'%m/%d'}</dd><br />
        </dl>
        {if empty($smarty.session[Auth::getNamespace()].bid_first_flag)}
          <li><a href="/admin/bid_first_help.php">Web入札会に参加する</a></li>
        {else}
          {if $b.status == 'entry'}
            {if Companies::checkRank($rank, 'B会員')}
            <li><a href="/admin/bid_machine_form.php?o={$b.id}">新規商品登録</a></li>

            {if Companies::checkRank($rank, 'A会員')}
              <li><a href="/admin/bid_machine2machine.php?o={$b.id}">在庫機械から出品</a></li>
            {/if}

            <li>
              <a href="/admin/bid_machine_list.php?o={$b.id}">出品商品一覧(変更・削除)<span class="count">({$b.count})</span></a> >>
              <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv">CSV出力</a>
            </li>
            <li><a href="/admin/bid_machine_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>下げ札</a></li>
            {/if}

          {elseif $b.status == 'margin'}
            <li>
              <a href="/bid_door.php?o={$b.id}" target="_blank">Web入札会トップページ</a> >>
              <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999">印刷用CSV出力</a>
            </li>
            <li><a href="/admin/bid_list.php?o={$b.id}">商品リスト</a></li>

            {if Companies::checkRank($rank, 'A会員')}
              {if Auth::check('system')}
                <li><a href="/admin/bid_machine_form.php?o={$b.id}">新規商品登録</a></li>
              {/if}
              <li>
                <a href="/admin/bid_machine_list.php?o={$b.id}">出品商品一覧<span class="count">({$b.count})</span></a> >>
                <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv">CSV出力</a>
              </li>
              <li><a href="/admin/bid_machine_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>下げ札</a></li>
            {/if}

          {elseif $b.status == 'bid'}
            <li>
              <a href="/bid_door.php?o={$b.id}" target="_blank">Web入札会トップページ</a> >>
              <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999">印刷用CSV出力</a>
            </li>
            <li>
              <a href="/admin/bid_list.php?o={$b.id}">商品リスト(入札・お問い合せ)</a>
            </li>
            <li><a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>商品リスト</a></li>
            {*
            <li><a href="{$_conf.media_dir}pdf/bid_flyer_03.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>第3回 Web入札会チラシ</a></li>
            *}
            {if Companies::checkRank($rank, 'B会員')}
              {if Auth::check('system')}
                <li><a href="/admin/bid_machine_form.php?o={$b.id}">新規商品登録</a></li>
              {/if}
            {/if}

            <li><a href="/admin/bid_bid_list.php?o={$b.id}">入札履歴(入札の取消)</a></li>

            {if Companies::checkRank($rank, 'B会員')}
              <li>
                <a href="/admin/bid_machine_list.php?o={$b.id}">出品商品一覧<span class="count">({$b.count})</span></a> >>
                <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv">CSV出力</a>
              </li>
              <li><a href="/admin/bid_machine_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>下げ札</a></li>
            {/if}

          {elseif $b.status == 'carryout'}
            <li>
              <a href="/bid_door.php?o={$b.id}" target="_blank">Web入札会トップページ</a> >>
              <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999">印刷用CSV出力</a>
            </li>
            <li><a href="/admin/bid_list.php?o={$b.id}">落札結果一覧</a></li>
            <li><a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>商品リスト</a></li>

            <li>
              <a href="/admin/bid_bid_list.php?o={$b.id}">落札商品 個別計算表</a> >>
              <a href="/admin/bid_bid_list.php?o={$b.id}&output=csv">CSV出力</a>
            </li>

            {if Companies::checkRank($rank, 'B会員')}
              <li>
                <a href="/admin/bid_machine_list.php?o={$b.id}">出品商品 個別計算表<span class="count">({$b.count})</span></a> >>
                <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv">CSV出力</a>
              </li>
            {/if}

            <li>
              <a href="/admin/bid_result.php?o={$b.id}">落札・出品集計表</a>
            </li>
            <li>
              {if empty($b.sashizu_flag)}<span><div class="label pdf">印刷用PDF</div>引取・指図書 ＜事務局の承認待ち＞</span>
              {else}<a href="/admin/bid_bid_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>引取・指図書</a>
              {/if}
            </li>
          {/if}
          <li>
            <a href="/admin/bid_moushikomi.php?o={$b.id}" target="_blank"><div class="label pdf">印刷用PDF</div>入札会申込書</a> >> <a href="{$_conf.media_dir}pdf/moushikomi_sample.pdf" target="_blank">記入例</a>
          </li>
          <li>
            <a href="/admin/bid_fee_help.php?o={$b.id}">入札会手数料について</a> >>
            <a href="/admin/bid_fee_sim.php?o={$b.id}" onclick="window.open('/admin/bid_fee_sim.php?o={$b.id}','','scrollbars=yes,width=850,height=450,');return false;">支払・請求額シミュレータ</a>
          </li>
        {/if}
      </div>

      <div class="bid_open">
        <h3>{$b.title} :: 企業間売り切りシステム</h3>
        {if !empty($b.seri_start_date) && !empty($b.seri_end_date)}
          <dl class="bid_date">
            <dt>出品期間</dt>
            <dd>{$b.entry_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.bid_end_date|date_format:'%m/%d %H:%M'}</dd><br />
            <dt>開催期間</dt>
            <dd>{$b.seri_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.seri_end_date|date_format:'%m/%d %H:%M'}</dd><br />
          </dl>

          {if strtotime($b.entry_start_date) <= time() && strtotime($b.seri_start_date) > time() }
            <li><a href="/admin/seri_form.php?o={$b.id}">企業間売り切り出品</a></li>
          {elseif strtotime($b.seri_start_date) <= time() && strtotime($b.seri_end_date) > time() }
            <li><a href="/admin/seri_form.php?o={$b.id}">企業間売り切り管理</a></li>
            <li><a href="/admin/seri_list.php?o={$b.id}">特設ページ</a></li>
          {elseif strtotime($b.seri_end_date) <= time() }
            <li><a href="/admin/seri_list.php?o={$b.id}">結果一覧</a></li>
            <li>
              <a href="/admin/seri_bid_list.php?o={$b.id}">落札商品 個別計算表</a> >>
              <a href="/admin/seri_bid_list.php?o={$b.id}&output=csv">CSV出力</a>
            </li>
            <li>
              <a href="/admin/seri_form.php?o={$b.id}">出品商品 個別計算表</a> >>
              <a href="/admin/seri_form.php?o={$b.id}&output=csv">CSV出力</a>
            </li>

            <li><a href="/admin/seri_result.php?o={$b.id}">落札・出品集計表</a></li>
            <li><a href="/admin/seri_bid_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>引取指図書</a></li>
          {/if}

          <li><a href="{$_conf.media_dir}pdf/seri_manual_01.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>企業間売り切りシステム マニュアル</a></li>
        {else}
          <div>企業間売り切りは開催されません</div>
        {/if}
      </div>
    {/foreach}
  {else}
    <li>現在開催中の入札会はありません</li>
  {/if}


  <li><a href="/admin/bid_open_list.php">過去のWeb入札会一覧</a></li>
  {if !empty($smarty.session[Auth::getNamespace()].bid_first_flag)}
    <li><a href="/admin/bid_first_help.php">Web入札会 運用規程</a></li>
    <li><a href="/admin/bid_entry_form.php">Web入札会 商品出品登録</a></li>
  {/if}

  <li><a href="admin/bid_manual.pdf" target="_blank"><div class="label pdf">ヘルプ資料</div>Web入札会 取扱説明書</a></li>

  {if Companies::checkRank($rank, 'B会員')}
    {if !empty($companysite.subdomain)}
      <h2>自社ウェブサイト作成サービス</h2>
      <li>
        <a href="admin/companysite_company_form.php">追加会社情報変更</a> >>
        <a href="/s/{$companysite.subdomain}/" target=="_blank">自社ウェブサイト表示(確認用)</a>
      </li>
    {/if}
  {/if}

  {*
  <h2>特別情報配信サービス</h2>
  <li><a href="admin/special_form.php">メール配信フォーム</a></li>
  <li><a href="admin/special_fax.php">FAXで配信</a></li>


  <h2>顧客メール一括送</h2>
  <li><a href="admin/mail_form.php">顧客メール一括送信フォーム</a></li>
  <li><a href="admin/mail_list.php">顧客メールログ</a></li>
  *}

  {*
  <h2>チラシメール</h2>
  <li><a href="admin/flyer_form.php">新規配信</a></li>
  <li><a href="admin/flyer_list.php">配信履歴一覧</a></li>
  *}

  {if Companies::checkRank($rank, 'B会員')}
    <h2>機械取扱説明書</h2>
    <li><a href="admin/manuals.php">機械情報センター 機械取扱説明書について</a></li>
  {/if}

  <h2>会社情報</h2>
  <li>
    <a href="admin/company_form.php">会社情報変更</a> >>
    <a href="/company_detail.php?c={$_user.company_id}" target="_blank">会社情報ページ(確認用)</a>
  </li>
  <li>
    <a href="admin/company_form.pdf" target="_blank"><div class="label pdf">ヘルプ資料</div>会社情報変更手順</a>
  </li>

  <h2>ユーザ情報</h2>
  <li><a href="admin/passwd_form.php">パスワード変更</a></li>

  <h2>会員ページヘルプ</h2>
  <li><a href="admin/help.php?p=linkbunner">リンクバナーについて</a></li>


  <h2>全機連マシンライフ</h2>
  <li><a href="{$_conf.website_uri}" target="_blank">全機連ウェブサイト</a></li>
  <li><a href="{$_conf.machine_uri}" target="_blank">{$_conf.site_name}</a></li>

  {if Companies::checkRank($rank, 'B会員')}
    <li><a href="{$_conf.catalog_uri}" target="_blank">電子カタログ</a></li>
  {/if}
</ul>
<br clear="both">
{/block}
