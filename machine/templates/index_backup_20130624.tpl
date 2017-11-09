{extends file='include/toppage_layout.tpl'}

{block 'header'}
{*
<meta name="description" content="中古機械情報のサイト。半世紀の歴史を持つ、全国唯一の機械商社の全国組織「全機連」会員の信頼と安心の中古機械情報をお届け致します" />
<meta name="keywords" content="中古機械,全機連,全日本機械業連合会,used machine,中古旋盤,中古鍛圧" />
*}

<meta name="description" content="マシンライフは、全国機械業連合会(全機連)が運営する中古機械のインターネット情報サイトです。中古機械のスペシャリスト同士が利用、非会員の方には会員による仲介も可能です。また購入後もサポートが受けられ、万が一の場合も全機連が仲介いたします。" />
<meta name="keywords" content="中古機械,全機連,中古旋盤,中古フライス,マシンライフ" />

<link href="{$_conf.site_uri}{$_conf.css_dir}toppage.css" rel="stylesheet" type="text/css" />
{literal}
<script type="text/javascript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
{*
<ul id="mycarousel" class="jcarousel-skin-tango">
  {if !empty($newMachineList)}
    {foreach from=$newMachineList item=m name='ml'}
      <li>
        {if !empty($m.top_img)}
          <img src='{$_conf.media_dir}machine/{$m.top_img}' />
        {else}
          <img src='img/noimage.jpg' />
        {/if}
        <div class='title'>新着情報</div>
        <div class='sub'>
          {$m.name} {$m.maker}<br />
          {$m.model}
        </div>
        <a class='button' href='machine_detail.php?m={$m.id}'>もっと見る</a>
      </li>
    {/foreach}
  {/if}
  
  <li class="ad">
    <a href="company_detail?c=26">
      <img src="img/ibuki.png" alt="伊吹産業" />
    </a>
  </li>
  
  <li class="ad">
    <a href="company_list.php">
      <img src="img/kikaidanchikaiin.png" alt="機械団地機械業会会員" />
    </a>
  </li>
  
  <li class="ad">
    <a href="http://www.omdc.or.jp/?page_id=434" target="_blank">
      <img src="img/omdc_nyusatukai.png" alt="機械団地入札会" />
    </a>
  </li>
</ul>
*}

{*
<div class='genre_discription'>
  下記のジャンルからお探しの機械をお選びください。

  （複数選択できます）お探しの機械が見つからないときは、
  <a href='kaitashi.php'>買いたし情報</a>を
  ご利用ください。

</div>
*}

{*** ジャンル一覧選択用 ***}
{include file="include/genre_list_check.tpl"}

{*** 入札会 ***}
<div class="premium_bid">
{*
  <a href="http://www.zenkiren.net/zennyusatsu/20130123okabe/">
   <img src="./media/banner/okabe20130123.gif"
     alt="入札会情報 大型歯切機械" title="入札会情報 大型歯切機械" target="_blank" />
  </a>

  <a href="http://www.omdc.or.jp/?page_id=434"  target="_blank"
    onClick="_gaq.push(['_trackEvent', 'banner', 'bid', 'omdc162', 1, true]);">
   <img src="./media/banner/omdc162.gif"
     alt="第162回 機械工具入札会 大阪機械卸業団地協同組合" title="第162回 機械工具入札会 大阪機械卸業団地協同組合" />
  </a>

  <a href="http://www.k-smk.co.jp/nyuusatu/"  target="_blank"
    onClick="_gaq.push(['_trackEvent', 'banner', 'bid', 'smk', 1, true]);">
   <img src="./media/banner/smk.gif" alt="" />
  </a>

  <a href="http://www.tachikawa-kikai.com/nyusatsu_info.html"  target="_blank"
    onClick="_gaq.push(['_trackEvent', 'banner', 'bid', 'tachikawa', 1, true]);">
   <img src="./media/banner/tachikawa.gif" alt="" />
  </a>

  <a href="http://www.omdc.or.jp/?page_id=434"  target="_blank"
    onClick="_gaq.push(['_trackEvent', 'banner', 'bid', 'omdc163', 1, true]);">
   <img src="./media/banner/omdc163.gif" alt="" />
  </a>
*}
  <a href="http://www.intexkikai.com/user/tender_11/"  target="_blank"
    onClick="_gaq.push(['_trackEvent', 'banner', 'bid', 'intex_02', 1, true]);">
   <img src="./media/banner/intex_02.gif" alt="" />
  </a>
</div>

{*
<h1>新着情報</h1>
<div class="news_area">  
  {if !empty($newMachineList)}
    <table class="news list">
      <tr>
        <th class="check"></th>
        <th class="img">画像</th>
        <th class="name">機械名</th>
        <th class="maker">メーカー</th>
        <th class="model">型式</th>
        <th class="year">年式</th>
        <th class="capacity">能力</th>
        <th class="location">在庫場所</th>
        <th class="company">掲載会社</th>
        <th class="created_at">登録日</th>
        <th class="button"></th>
      </tr>
    {foreach $newMachineList as $m}
      <tr class="machine {cycle values="even,odd"}">
        <td class="check">
          <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
        </td>
        <td class="img">
          <a href='machine_detail.php?m={$m.id}'>
          {if !empty($m.top_img)}
            <img src='{$_conf.media_dir}machine/{$m.top_img}' />
          {else}
            <img src='imgs/noimage.jpg' />
          {/if}
          </a>
        </td>
        <td class="name">{$m.name}</td>
        <td class="maker">{$m.maker}</td>
        <td class="model">{$m.model}</td>
        <td class="year">{$m.year}</td>
        <td class="capacity">
          {if !empty($m.capacity) && !empty($m.capacity_unit)}
            {$m.capacity}{$m.capacity_unit}
          {else}
            -
          {/if}
        </td>
        <td class="company">
          <a href='/company_detail.php?c={$m.company_id}'>{$m.company}</a>
        </td>
        <td class="location">
          <div class="addr1">{$m.addr1}</div>
          <div class="location">({$m.location})</div>
        </td>
        <td class="created_at">{$m.created_at|date_format:'%Y/%m/%d'}</td>
        <td class="button">
          <a class='contact' href='/contact.php?m={$m.id}'>問い<br />合わせ</a>
        </td>
      </tr>
    {/foreach}
    </table>
  {else}
    <div class="message">現在新着情報はありません</div>
  {/if}
</div>
*}

<div class="left_area">
  <h2><div>新着中古機械情報(最新50件)</div></h2>
  <a class="news_link" href="news.php?pe=3">>> そのほか新着中古機械情報</a>
  <ul class="news2_area resized">
  
  {foreach $newMachineList as $m}
   <a href="machine_detail.php?m={$m.id}">
     [{$m.created_at|date_format:'%m/%d'}] {$m.name} {$m.maker} {$m.model} {if !empty($m.year)}{$m.year}年式{/if} : {'/(株式|有限|合.)会社/'|preg_replace:'':$m.company}
   </a>
  {/foreach}
  </ul>
</div>

<div class="right_area">
  <h2><div>全機連事務局からのお知らせ</div></h2>
  <div class="infomations">
    {if !empty($infoList)}
      {foreach $infoList as $i}
        <div class="info">
          {if strtotime($i.created_at) > strtotime('-1week')}
            <div class="cjf_new">NEW!</div>
          {/if}
          <div class="info_date">{$i.info_date|date_format:'%Y/%m/%d'}</div>
          <div class="info_contents">{$i.contents|escape|nl2br nofilter}</div>
        </div>
      {/foreach}
    {else}
      書きこみはありません
    {/if}
  </div>
</div>
<br class="clear" />

{/block}
