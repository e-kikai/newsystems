{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.host}{$_conf.css_dir}/toppage.css?20120607" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
  $(function() {
    /// 型式で検索ボタン ////
    $('#model_form').submit(function() {
        if (!$('input.model').val() || $('input.model').val() == $('input.model').attr('title')) {
            alert('型式が入力されていません。');
            return false;
        }
        return true;
    });
    
    //// 提供会社(フェード) ////
    var fadeInt   = 1000;
    var switchInt = 5000;
    
    $('li.banner').css({opacity:'0'});
    $('li.banner:first').stop().animate({opacity:'1'}, fadeInt);
    
    setInterval(function(){
        $('li.banner:first')
            .animate({opacity:'0'}, fadeInt)
            .appendTo('#banner_carousel');
        $('li.banner:first').animate({opacity:'1'}, fadeInt)
    }, switchInt);
});
</script>
<style type="text/css">
  .cjf_new {
    display: inline-block;
    margin-right: 4px;
    background: #F33;
    color: #FFF;
    width: 40px;
    height: 15px;
    line-height: 15px;
    font-size: 11px;
    text-align: center;
    border-radius: 3px;
    text-shadow: 0 -1px 2px rgba(0, 0, 0, 0.2);
    font-family: 'Verdana';
  }

  .model_area .submit {
    height: 28px;
    font-weight: normal;
  }
</style>
{/literal}
{/block}

{block 'main'}
<div class="count">現在のカタログ件数
  <span class="count_no">{$count|number_format}</span>件
</div>

<div class="maker_count">登録メーカー数
  <span class="count_no">{$makerCount|number_format}</span>メーカー
</div>

{*
<div class="goal">目標（１万部）まで、あと
  <span class="count_no">{(10000 - $count)|number_format}</span>件
</div>
*}

{*** お知らせ ***}

<div class="top_area">
  <h2 class="infotitle">書きこみ</h2>
  <div class="info_area">
    <div class="infomations">
      {if !empty($miniblogList)}
      {foreach $miniblogList as $mi}
      <div class="info">
        {if strtotime($mi.created_at) > strtotime('-1week')}
        <div class="cjf_new">NEW!</div>
        {/if}
        <div class="info_name">{$mi.user_name}</div>
        <div class="info_date">{$mi.created_at|date_format:'%Y/%m/%d %H:%M'}</div>
        <div class="info_contents">{$mi.contents}</div>
      </div>
      {/foreach}
      {/if}
    </div>
  </div>

  <div class="banner_area">
    <ul id="banner_carousel" class="jcarousel-skin-tango">
      <li class="banner"><img src="{$_conf.media_dir}banner/22_shiba.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/20_presshozen.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/21_hagiwara.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/18_masuda.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/19_mekani.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/14_yutaka.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/15_sanwa.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/16_deguchi.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/17_kawahara.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/01_okuma.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/02_mazak.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/03_okabe.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/04_yamazakig.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/05_kobayashi.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/06_semba.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/07_kusumoto.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/08_katae.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/09_horikawa.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/10_dainichi.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/11_takizawa.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/12_nomura.png" /></li>
      <li class="banner"><img src="{$_conf.media_dir}banner/13_okamoto.png" /></li>
    </ul>
  </div>
</div>

{*** 型式で検索 ***}
<div class="model_area">
  <div class="label">型式で検索</div>
  <form method='get' id='model_form' action='catalog_list.php'>
    <input type='search' name='mo' class='model' value='{$mo}' placeholder='型式を入力してください' required />
    <button type='submit' class='submit' value='submit'>検索する</button>
    {* {$modelRes} *}
  </form>
</div>

{*** メーカー一覧 ***}
<div class='maker_area'>
  <div class="label">メーカ一覧から選択</div>
  {foreach from=$maker50onList key=row item=ma50on}
  <div class="maker_row">
    <div class="row_title">{$row}</div>
    <div class="row_list">
      {foreach from=$ma50on item=ma}
      {if !$ma.count}
      <span class='none'>{$ma.maker}</span>
      {else}
      <a href='catalog_list.php?ma={$ma.maker|urlencode}'>
        {$ma.maker}({$ma.count})
      </a>
      {/if}
      {/foreach}
    </div>
  </div>
  {/foreach}
</div>
{/block}