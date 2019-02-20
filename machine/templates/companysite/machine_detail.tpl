{extends file='companysite/layout.tpl'}

{block 'header'}
<meta name="description" content="" />
<meta name="keywords" content="中古機械" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
<link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// @ba-ta 2011/12/27 画像処理 ////
    $(".zoom").jqzoom({
        zoomType      : 'standard',
        lens          : true,
        preloadImages : true,
        alwaysOn      : false,
        zoomWidth     : 400,
        zoomHeight    : 300,
        xOffset       : 24,
        yOffset       : 0,
        position      : 'right',
        title         : false
    });

    $(".zoom").click(function() {
        window.open($(this).attr('href'));
    });

    // ロード時に、拡大縮小を生成
    $('.img a:first').click();

    //// スクロール ////
    $('a[href*=#]').click(function() {
        var target = $(this.hash);
        if (target) {
            var targetOffset = target.offset().top;
            $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
            return false;
        }
    });
});
</script>
<style type="text/css">
/*** 機械詳細 ***/


/* 画像枠 */
#viewport {
  overflow : visible;
  width    : 400px;
  height   : 300px;
  margin   : 0;
}

.zoomWrapperImage img {
  max-width: none;
  max-height: none;
}

.img_area {
  float: left;
  width: 400px;
}

.images {
  width: 400px;
  margin-top: 4px;
}

.images a.img {
  display: block;
  float: left;
  max-width: 76px;
  max-height: 57px;
  border: 0;
  margin: 2px;
}

.images a.img img {
  display: block;
  max-width: 76px;
  max-height: 57px;
  margin: 0 auto;
}

/* 詳細テーブル */
.spec_area {
  width: 552px;
  float: right;
}

table.spec {
  width: 552px;
  margin: 0;
}

div.top_image {
  width: 400px;
  height: 300px;
  margin: 0 0 8px 0;
}

.top_image img.zoom_img {
  max-width: 400px;
  max-height: 300px;
}

table.others th,
table.spec th {
  width: 120px;
}

/* お問い合わせ */
.contact_info {
  float: right;
}

.contact_area {
  text-align: center;
}

.contact_area a {
  display : block;
  margin : auto;
}

.contact_area .tel,
.contact_area .fax {
  color : #C00;
  font-size : 20px;
  margin: 3px 0 3px 16px;
  float: left;
}

.contact_link {
  float: left;
}

/* 動画 */
.youtube {
  margin-top: 8px;
}

/* 機械情報 */
table.machine {
  width: 552px;
  margin: 0 0 4px 0;
}
table.machine .no {
  width: 80px;
}

table.machine .name,
table.machine .model {
  width: 130px;
}

table.machine .year {
  width: 60px;
}

/*** 地図表示 ***/
.gmap_detail {
  width : 552px;
  height : 414px;
  border : 1px solid #AAA;
  margin : 16px auto;
}

</style>
{/literal}
{/block}

{block 'main'}

<h1>{$machine.maker} {$machine.name} {$machine.model} 機械詳細</h1>

{if !empty($machine)}
<div class='detail_container'>



  {*** 画像 ***}
  <div class="img_area">
  {if empty($machine.top_img) && empty($machine.imgs)}
    {*
    <div class="message">画像は登録されていません</div>
    *}
    <img class='noimage' src='{$_conf.site_uri}imgs/noimage.png'
      alt="中古{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
  {else}
    <div class='top_image'>
      <div id='viewport'>
      {if !empty($machine.top_img)}
        <a class="zoom" href="{$_conf.media_dir}machine/{$machine.top_img}" rel='gal1'>
          <img class="zoom_img" src="{$_conf.media_dir}machine/{$machine.top_img}" alt="中古{$machine.name} {$machine.maker} {$machine.model}" />
        </a>
      {/if}
      </div>
    </div>

    <div class='images'>
    {if !empty($machine.imgs)}
      {if !empty($machine.top_img)}
        <a class="img" href='javascript:void(0);'
           rel="{literal}{{/literal}
             gallery:'gal1',
             smallimage:'{$_conf.media_dir}machine/{$machine.top_img}',
             largeimage:'{$_conf.media_dir}machine/{$machine.top_img}'
           {literal}}{/literal}">
          <img src="{$_conf.media_dir}machine/{$machine.top_img}" alt="中古{$machine.name} {$machine.maker} {$machine.model}" />
        </a>
      {/if}

      {foreach $machine.imgs as $i}
        <a class="img" href='javascript:void(0);'
           rel="{literal}{{/literal}
             gallery:'gal1',
             smallimage:'{$_conf.media_dir}machine/{$i}',
             largeimage:'{$_conf.media_dir}machine/{$i}'
           {literal}}{/literal}">
          <img src="{$_conf.media_dir}machine/{$i}" alt="中古{$machine.name} {$machine.maker} {$machine.model}" />
        </a>
      {/foreach}
    {/if}
    <br style="clear:both;" />
    </div>
  {/if}

  {*** youtube ***}
  {if !empty($machine.youtube) && preg_match_all('/([\w\-]{11})/', $machine.youtube, $res)}
    <div class="youtube">
      {foreach $res[0] as $y}
        <iframe width="400" height="300"
          src="https://www.youtube.com/embed/{$y}?rel=0"
          frameborder="0" allowfullscreen></iframe>
      {/foreach}
    </div>
  {/if}

  </div>

  <div class="spec_area">

  {*
  <table class='machine'>
    <tr>
      <th class="no">管理番号</th>
      <th class='name'>機械名</th>
      <th class='maker'>メーカー</th>
      <th class='model'>型式</th>
      <th class='year'>年式</th>
    </tr>

    <tr class='machine machine_{$machine.id}'>
      <td class='no'>{$machine.no}</td>
      <td class='name'>{$machine.name}</td>
      <td class='maker'>{$machine.maker}</td>
      <td class='model'>{$machine.model}</td>
      <td class='year'>{$machine.year}</td>
    </tr>
  </table>
  *}

    <table class="spec mysite">
      <tr class="">
        <th>管理番号</th>
        <td class='no'>{$machine.no}</td>
      </tr>
      <tr class="">
        <th>機械名</th>
        <td class='name'>{$machine.name}</td>
      </tr>
      <tr class="">
        <th>メーカー</th>
        <td class='maker'>{$machine.maker}</td>
      </tr>
      <tr class="">
        <th>型式</th>
        <td class='model'>{$machine.model}</td>
      </tr>
      <tr class="">
        <th>年式</th>
        <td class='year'>{$machine.year}</td>
      </tr>

      {if !empty($machine.capacity_label)}
        <tr class="capacity number" >
          <th>{$machine.capacity_label}</th>
          <td>{if empty($machine.capacity)}-{else}{$machine.capacity}{$machine.capacity_unit}{/if}</td>
        </tr>
      {/if}

      <tr class="spec">
        <th>仕様</th>
        <td>
          <div class="others">
          {foreach $machine.spec_labels as $d}
            {if empty($machine.others[$d@key])}
            {elseif !empty($os[$d.type])}
              {$d.label}:
              {foreach $os[$d.type][0] as $key}
                {$machine.others[$d@key][$key]}{if !($key@last)}{$os[$d.type][1]}{/if}
              {/foreach}
              {$d.unit} |
            {else}
              {$d.label}:{$machine.others[$d@key]}{$d.unit} |
            {/if}
          {/foreach}
          </div>
          <div>{$machine.spec}</div>
        </td>
      </tr>

      <tr class="accessory">
        <th>附属品</th>
        <td>{$machine.accessory}</td>
      </tr>

      <tr class="comment">
        <th>コメント</th>
        <td>{$machine.comment}</td>
      </tr>

      <tr class="">
        <th>在庫場所</th>
        <td class='location'>
          <a href="{$smarty.server.REQUEST_URI}#gmap2">
          <div class="location_address">{$machine.addr1} {$machine.addr2} {$machine.addr3}</div>
          {if $machine.location}({$machine.location}){/if}
          </a>
        </td>
      </tr>

      {*
      {if Auth::check('member')}
      <tr class="price">
        <th>金額<span class="memberonly">(会員のみ公開)</span></th>
        <td>
          {if !empty($machine.price)}
            {$machine.price|number_format}円
            ({if empty($machine.price_tax)}税込価格{else}税抜{/if})
          {else}-{/if}
        </td>
      </tr>
      {/if}
      *}

      <tr class="label_area">
        <td colspan="2">
          {if $machine.view_option == 2}<div class="label vo2">商談中</div>{/if}
          {if $machine.commission == 1}<div class="label commission">試運転可</div>{/if}
          {if !empty($machine.pdfs)}
            {foreach $machine.pdfs as $key => $val}
              <a href="{$_conf.media_dir}machine/{$val}"
                class="label pdf" target="_blank">PDF:{$key}</a>
            {/foreach}
          {/if}
          {*
          {if Auth::check('member') && !empty($machine.catalog_id)}
            <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$machine.catalog_id}"
              class="label catalog" target="_blank">電子カタログ(会員のみ公開)</a>
          {/if}
          *}
        </td>
      </tr>
    </table>


    <div class='contact_area'>
      {if !empty($machine.contact_mail)}
        <a class='contact_link' href='contact.php?m={$machine.id}'><img src='{$_conf.site_uri}imgs/contact_button.png' /></a>
      {/if}
      {if !empty($machine.contact_tel)}<div class='tel'>TEL {$machine.contact_tel}</div>{/if}
      {if !empty($machine.contact_fax)}<div class='tel'>FAX {$machine.contact_fax}</div>{/if}
    </div>

    {if $machine.addr3}
    <iframe class="gmap_detail" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
      src="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1} {$machine.addr2} {$machine.addr3}+({$machine.location})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
    <a href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1} {$machine.addr2} {$machine.addr3}+({$machine.location})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m" style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
    {/if}
  </div>

</div>
{else}
    <div class="error_mes">
      指定された方法では、機械情報の特定ができませんでした<br />
      誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
    </div>
{/if}
<br style="clear:both;" />

{/block}
