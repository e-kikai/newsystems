{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.host}{$_conf.js_dir}/catalog.js"></script>
<link href="{$_conf.host}{$_conf.css_dir}/catalog.css?1" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// ソート処理 ////
    $('a.sort').click(function() {
        $(this).attr('href').match(/#([a-z_]+)-([a-z]+)/);
        var order = RegExp.$1;
        var dir   = RegExp.$2;

        $('table.catalogs .catalog').sort( function(a, b) {
            var da = $(a).find('.' + order).text();
            var db = $(b).find('.' + order).text();

            if (da == db)     { return $(a).find('.index').text() > $(b).find('.index').text() ? 1 : -1; }
            if (da == '')     { return 1; }
            if (db == '')     { return -1; }
            if (dir == 'asc') { return da > db ? 1 : -1; }
            else              { return da > db ? -1 : 1; }
        }).each(function() {
            $('table.catalogs').append($(this));
        });

        // Lazyload用スクロール
        $(window).triggerHandler('scroll');

        return false;
    });

    //// ドラッグアンドドロップでの保存(for Chrome) ////
    $('td.img a.catalog_image, td.img a.button')
        .attr('draggable','true')
        .each(function() {
            var el = $(this).get()[0];

            el.addEventListener("dragstart", function(e) {
                var data = "application/pdf:" +
                     $(this).data('name') + ".pdf:" +
                    "http://catalog2.etest.wjg.jp:81/" + $(this).attr('href');
                e.dataTransfer.setData("DownloadURL", data);
            }, false);
        });

    $('.find_area button.req_open').click(function() {
        $('.req_area').dialog({
            title: 'カタログのリクエスト',
            modal: true,
            width: 530,
            zIndex: 3000,
            show : "fade",
            hide : "fade",
            buttons:[
            {
                text: "リクエストを送信する",
                class: "req_submit",
                click: function(){
                    $_self = $(this);
                    var data = {
                        'maker': $.trim($('input.req_maker').val()),
                        'model': $.trim($('input.req_model').val()),
                        'comment': $.trim($('textarea.req_comment').val()),
                    }

                    //// 入力のチェック ////
                    var e = '';
                    if (data.maker == '') { e += "メーカーが入力されていません\n"; }
                    if (data.model == '') { e += "型式が入力されていません\n"; }

                    //// エラー表示 ////
                    if (e != '') { alert(e); return false; }

                    // 送信確認
                    if (!confirm('リクエストを送信します。よろしいですか。')) { return false; }


                    $('.req_submit').attr('disabled', 'disabled');
                    $('.req_submit .ui-button-text').text('リクエスト送信処理中、終了までそのままお待ち下さい');

                    $.post('/ajax/mail.php', {
                        'target': 'catalog',
                        'action': 'sendCatalogReq',
                        'data'  : data,
                    }, function(res) {
                        if (res != 'success') {
                            $('.req_submit').removeAttr('disabled');
                            $('.req_submit .ui-button-text').text('リクエストを送信する');
                            alert(res);
                            return false;
                        }

                        // リクエスト送信完了
                        alert(
                            "リクエスト送信が完了しました\n" +
                            "送信されたリクエストは、全機連事務局より、全機連会員に向けて調査依頼メールを配信いたします。"
                        );
                        $_self.dialog( "close" );
                        return false;
                    }, 'text');

                    return false;
                }
            }
            ],
            open: function(event) {
                $('.req_maker').focus();
            },
        });
    });
});
</script>
<style type="text/css">
div.uid {
  margin-top:8px;
}

.find_area {
  background: #D0FFB0;
  border: #006600 2px solid;

  padding:  4px 8px;
  border-radius: 8px;

  top: -60px;
  position: absolute;

  left: 380px;
  width: 543px;
  height: 46px;
  margin-left: 0;
}

.find_area .title {
  color: #CC0000;
  font-size: 16px;
  font-weight: bold;
  line-height: 1.6;
}

.find_area button.close {
  position: absolute;
  top: 4px;
  right: 4px;
}

.find_area .announce {
  line-height: 1.6;
  font-size: 12px;
}

.find_area button.req_open {
  position: absolute;

  width: 160px;
  font-size: 15px;
  height: 37px;
  line-height: 37px;
  top: 8px;
  right: 10px;
}

button.set_mylist, button.delete_mylist {
  font-size: 11px;
}

/*** リクエストエリア ***/
.req_area label {
  display: block;
  font-size: 14px;
  text-align: right;
  margin: 3px auto;
  vertical-align: top;
}

.req_area label input {
  width: 350px;
  margin-left: 16px;
}

.req_area label textarea {
  width: 350px;
  margin-left: 16px;
  height: 50px;
  padding: 3px 6px;
}

span.require {
  color: #FF0033;
  vertical-align: top;
}

button.req_open.highlight {
  color: #FF0033;
}

div.req_area a {
  color: #076AB6;
}

.ui-front {
  z-index: 3000;
}
</style>
{/literal}
{/block}

{block 'main'}
<div class='catalog_area'>
{if !empty($catalogList)}

  {*** 型式で検索 ***}
  {*
  <div class="model_area">
    <div class="label">型式で検索</div>
    <form method='get' id='model_form' action='catalog_list.php'>
      <input type="hidden" name="ma" value='{$ma}' />
      <input type='search' name='mo' class='model' value='{$mo}' placeholder='型式を入力してください' required />
      <button type='submit' class='submit' value='submit'>検索する</button>
    </form>
  </div>
  *}

  {*** メーカー絞り込み ***}
  {if !empty($makerList)}
    <div class='maker_area'>
      <li>
        <span class="area_label">メーカー</span>：
        <a class="maker_all" href='{$cUrl}'>すべて表示</a>
      </li>
      {foreach $makerList as $ma}
        {if $ma.count}
          <li>
            <label>
              <input type="checkbox" name="ma[]" id="maker_{$ma.maker}" value="{$ma.maker}">
              <label for="maker_{$ma.maker}">{$ma.maker|truncate:9:"…"}({$ma.count})
            </label>
          </li>
        {/if}
      {/foreach}
    </div>
  {/if}

  {*** ジャンル絞り込み ***}
  {if !empty($genreList)}
    <div class='genre_area'>
      <li>
        <span class="area_label">ジャンル</span>：
        <a class="genre_all" href='{$cUrl}'>すべて表示</a>
      </li>
      {foreach $genreList as $g}
        {if $g.count}
          <li>
            <label>
              <input type="checkbox" name="g[]" id="genre_{$g.id}" value="{$g.id}">
              {$g.genre|truncate:9:"…"}({$g.count})
            </label>
          </li>
        {/if}
      {/foreach}
    </div>
  {/if}

  <div class='model2_area'>
    <span class="area_label">型式</span>：
    <input type="text" class="model2" value="" />
  </div>

  {*** 表示切り替え ***}
  <div class='catalog_view'>
    <a href='{$cUrl}&v=list'  class="list {if $v=='list'} selected{/if}">リストで表示</a>
    <a href='{$cUrl}&v=image_l' class="image_l {if $v=='image_l'} selected{/if}">写真で表示</a>
  </div>

  {*** 画像表示 ***}
  <div class='catalogs image_l' {if $v!='image_l'}style='display:none;'{/if}>
    {foreach $catalogList as $c}
      {if $c.file && $c.thumbnail}
        {*
        <a href='{$c.file}' target='_blank' class='catalog catalog_image'>
        *}
        <div class="catalog">
          <a href='catalog_pdf.php?id={$c.id}' target='_blank'  class='catalog_image' data-name="{$c.maker}_{$c.id}">
            <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}catalog_thumb/{$c.thumbnail}" alt='PDF' />
            <noscript><img src="{$c.thumbnail}" alt='PDF' /></noscript>
          </a>
          <div class='hidden genre_id'>{$c.genre_ids}</div>
          <div class='hidden maker'>{$c.maker}</div>
          <div class='hidden model2'>{$c.keywords}</div>
          {if $smarty.server.PHP_SELF == '/mylist_catalog.php'}
            <button class="delete_mylist" value="{$c.id}">マイリスト削除</button>
          {else}
            <button class="set_mylist" value="{$c.id}">マイリスト追加</button>
          {/if}
          <a href='catalog_pdf.php?id={$c.id}&dl=1'  class='button'>Download</a>
        </div>
      {else}
        <div class='catalog_image'>ファイルがありません</div>
      {/if}
    {/foreach}
  </div>

{*** 一覧表示 ***}
<table class='catalogs list main_list' {if $v!='list'}style='display:none;'{/if}>
  <thead>
    <tr>
      <th class="img"></th>
      <th class="genre"><a class="sort" href="#index-asc">ジャンル</a></th>
      <th class='maker'>メーカー</th>
      <th class='model'>型式</th>
      <th class='year_td'><a class="sort" href="#year-asc">作成年・カタログNo</a></th>
      <th class='button'></th>
    </tr>
  </thead>

  {foreach $catalogList as $c}
    <tbody class="catalog">
      <tr class="separator"><td colspan="5"></td></tr>
      <tr>
        <td class='img'>
          {if $c.file && $c.thumbnail}
            <a href='catalog_pdf.php?id={$c.id}' target='_blank' class='catalog_image' data-name="{$c.maker}_{$c.id}">
              <img class="lazy" src='/imgs/blank.png' data-original="{$_conf.media_dir}catalog_thumb/{$c.thumbnail}" alt='PDF' />
              <noscript><img src="{$_conf.media_dir}catalog_thumb/{$c.thumbnail}" alt='PDF' /></noscript>
            </a>
            <a href='catalog_pdf.php?id={$c.id}&dl=1' class='button' data-name="{$c.maker}_{$c.id}">Download</a>

            {*** test ***}
            {*
            {if preg_match('/^(213[5-9]|214[01]|222[2-9]|2230)/', $c['uid']) }
              <a href='catalog_pdf.php?id={$c.id}&s=1' target='_blank'>仕様</a>
            {/if}
            {if preg_match('/^(213[5-9]|214[01]|222[2-9]|2230)/', $c['uid']) }
              <a href='catalog_pdf.php?id={$c.id}&s=2' target='_blank'>印刷用</a>
            {/if}
            *}

          {/if}
        </td>
        <td class='genre'>
          {$c.genres|regex_replace:'/\|/':'<br />' nofilter}
          <div class='hidden genre_id'>{$c.genre_ids}</div>
          <div class='hidden index'>{$c@index}</div>
          {if Auth::check('system')}
            <div class="uid">UID: {$c.uid}</div>
          {/if}
        </td>
        <td class='maker'>{$c.maker}</td>
        <td class='model'>
          {$c.models}
          <div class='hidden model2'>{$c.keywords}</div>
        </td>
        <td class='year_td'>
          <div class="year">{$c.year}</div>
          <div class="catalog_no">{$c.catalog_no}</div>
        </td>
        <td class='button'>
          {if $smarty.server.PHP_SELF == '/mylist_catalog.php'}
            <button class="delete_mylist" value="{$c.id}">マイリスト<br />削除</button>
          {else}
            <button class="set_mylist" value="{$c.id}">マイリスト<br />追加</button>
          {/if}
        </td>
      </tr>
    </tbody>
  {/foreach}
</table>
{/if}
</div>

<div class="find_area">
  <div class="title">お探しのカタログは見つかりましたか？</div>
  <div class="announce">カタログが見つからない時は「カタログ探してます」をご利用下さい</div>
  <button class="req_open">カタログ探してます</button>
  {*
  <button class="close">閉じる</button>
  *}
</div>

<div class="req_area" style="display:none;">
  お探しのカタログのメーカー、型式をご記入下さい。<br />
  全機連事務局より、全機連会員に向けて調査依頼メールを配信いたします。<br />
  {*
  <a href="help.php?c=request" target="_blank">詳しくはこちら</a>
  *}
  <label>メーカー<span class="require">(必須)</span><input type="text" class="req_maker" value="" /></label>
  <label>型式<span class="require">(必須)</span><input type="text" class="req_model" value="" /></label>
  <label>コメント<textarea class="req_comment"></textarea></label>
</div>
{/block}
