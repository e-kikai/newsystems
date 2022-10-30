{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
.formula_area {
  padding: 8px 0;
}

.formula_area p {
  padding: 8px;
}

ol.lanking {
  margin: 4px 45px;
}

hr {
  margin-top: 10px;
  margin-bottom: 10px;
  border: 0;
  border-top: 1px solid #eeeeee;
}
</style>
{/literal}
{/block}

{block 'main'}
<form action="system/formula.php" method=="get">
  表示月 :
  {html_select_date prefix='month' time=$month end_year='2013'
    display_days=false field_separator=' / ' month_format='%m' reverse_years=true field_order="YMD"}
  <input type="submit" value="表示月変更" />
</form>


<h2>{$monthYear}年{$monthMonth}月の集計</h2>
<div class="formula_area">
  <p>
    在庫情報について、<br/>
    登録総数は {$res.machinesInto|number_format}件、<br />
    うち、当月の新規登録数は {$res.machinesCreate|number_format}件 (一日平均約 {($res.machinesCreate / $dateCount)|number_format:0|floatval}件)、
    登録を行った会員会社数は {$res.machinesCreateCompany|number_format}社でした。<br />
    登録数上位{$lank|number_format}位のジャンルは、以下のとおりです。

  </p>

  {*
  <ol class="lanking">
    {foreach $res.machinesCreateCompanyRanking as $c}
      <li>{$c.company|regex_replace:'/(株式|有限|合.)会社/u':''} の {$c.count|number_format}件</li>
    {/foreach}
  </ol>
  *}

  <ol class="lanking">
    {foreach $res.machinesCreateGenreRanking as $c}
      <li>{$c.large_genre} の {$c.count|number_format}件</li>
    {/foreach}
  </ol>


  <p>
    削除(売却)数は {$res.machinesDelete|number_format}件 (一日平均約 {($res.machinesDelete / $dateCount)|number_format:0|floatval}件)、
    削除(売却)を行った会員会社数は {$res.machinesDeleteCompany|number_format}社
    でした。<br />
    削除(売却)数上位{$lank|number_format}位のジャンルは、以下のとおりです。
  </p>

  <ol class="lanking">
    {foreach $res.machinesDeleteGenreRanking as $c}
      <li>{$c.large_genre} の {$c.count|number_format}件</li>
    {/foreach}
  </ol>

  <hr />

  <p>
    問合せについて、<br/>
    問合せ総数は {$res.contactsAll|number_format}件
    (一日平均約 {($res.contactsAll / $dateCount)|number_format:0|floatval}件)、<br />
    (年間累計問合せ数 {$res.contactsTotal|number_format}件)<br />
    問い合わせを行ったユーザ数は {$res.contactsUser|number_format}人 (一人平均約 {($res.contactsAll / $res.contactsUser)|number_format:0|floatval}件)でした。
  </p>

  <p>
    うち、在庫情報についての問合せは {$res.contactsMachine|number_format}件 (一日平均約 {($res.contactsMachine / $dateCount)|number_format:0|floatval}件)、<br />
    問合せ数上位{$lank|number_format}位の情報は、以下のとおりです。
  </p>

  <ol class="lanking">
    {foreach $res.contactsMachinesRanking as $c}
      <li>{$c.name} {$c.maker} {$c.model} {$c.year} の {$c.count|number_format}件</li>
    {/foreach}
  </ol>

  <p>
    登録会社への問合せは {$res.contactsCompany|number_format}件 (一日平均約 {($res.contactsCompany / $dateCount)|number_format:0|floatval}件)、<br />
    事務局への問合せは {$res.contactsSystem|number_format}件 (一日平均約 {($res.contactsSystem / $dateCount)|number_format:0|floatval}件)でした。
  </p>

  <p>
    問合せ数上位{$lank|number_format}位の都道府県(無記入を除く)は、以下のとおりです。
  </p>
  <ol class="lanking">
    {foreach $res.contactsAddr1Ranking as $a}
      <li>{$a.addr1} の {$a.count|number_format}件</li>
    {/foreach}
  </ol>

  <p>
    (※ 問合せ件数は、ウェブサイトの問い合わせフォームからの問合せの件数で、電話等で直接問合せした件数は含まれません)
  </p>

  <hr />

  <p>
    機械詳細ページアクセス数について、<br />
    総アクセス数は {$res.ActionlogMachine|number_format}アクセス (一日平均約 {($res.ActionlogMachine / $dateCount)|number_format:0}件)、<br />
    アクセスしたユーザ数は {$res.ActionlogMachineUniq|number_format}人 (一人平均約 {($res.ActionlogMachine / $res.ActionlogMachineUniq)|number_format:0|floatval}件)、<br />
    年間累計ユーザ数(月累計の合算値)は、 {$res.ActionlogMachineUniqTotal|number_format}人、<br />
    アクセス数上位{$lank|number_format}位の機械は、以下のとおりです。
  </p>
  <ol class="lanking">
    {foreach $res.ActionlogMachineRanking as $c}
      <li>{$c.name} {$c.maker} {$c.model} {$c.year} の {$c.count|number_format}件</li>
    {/foreach}
  </ol>

  <hr />

  <p>
    電子カタログについて、<br />
    PDFアクセス数は {$res.ActionlogPDF|number_format}アクセス (一日平均約 {($res.ActionlogPDF / $dateCount)|number_format:0}件)、<br />
    利用ユーザ数は {$res.ActionlogPDFUniq|number_format}人 (一人平均約 {($res.ActionlogPDF / $res.ActionlogPDFUniq)|number_format:0|floatval}件)でした。
  </p>


  {foreach $res.bids as $bi}
    <hr />
    <p>
      また今月は、{$bi.open.title}が開催されていました。
      (開催期間:{$bi.open.bid_start_date|date_format:'%Y年%m月%d日'}〜{$bi.open.bid_end_date|date_format:'%Y年%m月%d日'})<br />

      出品会社数 {$bi.sums.company_num} 社、出品点数 {$bi.sums.count} 件、うち落札点数は {$bi.sums.result_count} 件、<br />
      入札総数は {$bi.bidCount} 件、入札に参加した会社数は {$bi.bidCompanyCount}社、<br />
      最低入札金額合計は {$bi.sums.min_price|number_format} 円、落札金額合計 {$bi.sums.result_price|number_format} 円、<br />
      開催期間中の総アクセス数は {$bi.log|number_format}アクセス (一日平均約 {($bi.log / $dateCount)|number_format:0}件)、
      アクセスしたユーザ数は {$bi.logUniq|number_format}人 (一人平均約 {($bi.log / $bi.logUniq)|number_format:0|floatval}件)、<br />
      アクセス数上位{$lank|number_format}位の商品は、以下のとおりです。
    </p>

    <ol class="lanking">
      {foreach $bi.logBMRanking as $c}
        <li>{$c.name} {$c.maker} {$c.model} {$c.year}(最低入札価格:{($c.min_price/1000)|number_format}千円)の {$c.count|number_format}件</li>
      {/foreach}
    </ol>

  {/foreach}



</div>

{/block}
