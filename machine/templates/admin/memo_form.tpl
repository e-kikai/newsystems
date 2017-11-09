{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
<link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />


<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.fancybox.js"></script>
<link href="{$_conf.libjs_uri}/css/jquery.fancybox.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
//// 変数の初期化 ////
var makerList  = [];
var genreList  = [];
var officeList = [];
var tmp = {};

var locationList = [];
var genre = {};

var ncMakerList = ["ファナック","メルダス","トスナック","OSP","プロフェッショナル","マザトロール"];

$(function() {

    //// フォームのエラーチェック(HTML5対応)
    $('form.machine').submit(function() {
        if (!Modernizr.input.required) {
            var result = true;;
            $('input[required]').each(function() {
                if ($(this).val() == '') {
                    alert('必須項目が入力されていません。');
                    result = false;
                }
            });
            if (!result) { return false; }
        }
        
        if (confirm('在庫機械情報の変更を反映します。よろしいですか。')) {
            $(this).attr('action', 'admin/machine_do.php');
            return true;
        } else {
            return false;
        }
    });
    

    
    /*
    //// 顧客フォームの表示 ////
    $('select.category').change(function() {
        $('.options').hide();
        if ($(this).val() == '引合') {
            $('.options.hikiai').show();
        }
    });
    */
    // 詳細ページ用
    $("#machine_heritage").fancybox({
        'width'       : 720,
        'height'      : '85%',
        'autoSize'    : false,
        'padding'     : 1,
        'openEffect'  : 'fade',
        'closeEffect' : 'fade',
        'type'        : 'iframe',
        'href'        : '/admin/machine_form.php',
        'afterShow'   : function() {
            var src = $('.fancybox-iframe').attr('src');
            if (src) {
                /*
                // 全画面表示ボタン
                $('<a id="fancybox-fullsize" style="display:inline;" target="_blank">全画面表示</a>')
                    .insertBefore($(".fancybox-close"))
                    .attr('href', src)
                    .click( function() { $.fancybox.close(); })
                    .show();
                */
            }
            
            var $_iframe = $('.fancybox-iframe:first').contents();
            $_iframe.find('header, .header_mypage, .pankuzu, h1, .description, footer').hide();
            $_iframe.find('.main_container, .center_container').css('width', 700);
            $_iframe.find('tr.spec ~ tr').hide();
        },
        'beforeClose' : function() { $('#fancybox-fullsize').hide(); },

        
        
    });
    
});

//// アップロード後のコールバック ////
function upload_callback (target, data)
{
    if (target == "imgs") {
        $.each(data, function(i, val) {
            var h = 
                '<div class="img">' +
                '<label><input name="imgs_delete[]" type="checkbox" value="' + val + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val + '" target="_blank">' +
                '<img src="/media/tmp/' + val + '" />' + 
                '</a>' +
                '<input name="imgs[]" type="hidden" value="' + val + '" />'
                '</div>';
            $('.imgs .upload_img').append(h);
        });
    } else if (target == "top_img") {
        $.each(data, function(i, val) {
            var h = 
                '<div class="img">' +
                '<label><input name="top_img_delete" type="checkbox" value="' + val + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val + '" target="_blank">' +
                '<img src="/media/tmp/' + val + '" />' + 
                '</a>' +
                '<input name="top_img" type="hidden" value="' + val + '" />'
                '</div>';
            $('.top_img .upload_img').html(h);
        });
    } else if (target == "pdf") {
        $.each(data, function(i, val) {
            var h = 
                '<div class="pdf">' +
                '<a href="/media/tmp/' + val + '" target="_blank">PDF</a>' +
                '<input name="pdfs_label[]" type="text" value="" placeholder="ラベル" />' +
                '<label><input name="pdfs_delete[]" type="checkbox" value="' + val + '" />削除</label><br />' +
                '<input name="pdfs[]" type="hidden" value="' + val + '" />' +
                '</div>';
            $('.pdfs .upload_pdf').append(h);
        });
    }
}
</script>
<style type="text/css">
table.form td input.title {
  width: 300px;
}

table.form td textarea.contents {
  height: 120px;
}

table.memo {
  margin-top: 4px;
}

/*** 機械メモ ***/
table.form td input.title,
table.form td input.customer_name,
table.form td input.customer_address,
table.form td input.customer_tel,
table.form td input.customer_mail {
  width: 300px;
}


div.machine {
  background: #FFFFCC;
  border: 1px solid #AAA;
  margin: 2px;
  padding: 4px;
  border-radius: 4px;
}

input.machines_maker,
input.machines_model,
input.machines_year {
  width: 110px;
  margin-right: 4px;
}

textarea.memo {
  width: 360px;
  height: 50px;
  margin-top: 4px;
}

/*** 顧客フォーム ***/
.customer dt {
  display: inline-block;
  width: 90px;
}

.customer dd {
  display: inline-block;
  width: 250px;
}

.options {
  display: none;
}

#machine_heritage {
  width: 240px;
}
</style>
{/literal}
{/block}

{block 'main'}
<div class="form_comment">
  <span class="alert">※</span>
  　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
</div>

<form class="memo" method="post" action="">
  <input type="hidden" name="id" class="id" value="{$id}" />
<table class="card form">
  {*
  <tr class="genre">
    <th>タイプ</th>
    <td>
      {html_options class=category name=category values=$categoryList output=$categoryList selected=$memo.category}
    </td>
  </tr>
  *}

    
  <tr class="title">
    <th>タイトル</th>
    <td>
      <input type="text" name="title" class="title" value="{$memo.title}"
        placeholder="買いのタイトル" />
    </td>
  </tr>
  
  <tr class="title">
    <th>担当者</th>
    <td>
      {$_user.user_name}
    </td>
  </tr>
  
  <tr class="datetime">
    <th>日時</th>
    <td>
      <input type="datetime" name="datetime" class="datetime" value="{$memo.datetime}"
        placeholder="日時" />
    </td>
  </tr>

    
  <tr class="customer_name">
    <th>顧客名</th>
    <td>
      <input type="text" name="customer_name" class="customer_name" value="{$memo.customer_name}"
        placeholder="顧客の会社名・担当者名" />
    </td>
  </tr>

  <tr class="customer_address">
    <th>顧客住所</th>
    <td>
      <input type="text" name="customer_address" class="customer_address" value="{$memo.customer_address}"
        placeholder="顧客の会社名住所" />
    </td>
  </tr>
  
  <tr class="customer_tel">
    <th>顧客TEL</th>
    <td>
      <input type="text" name="customer_tel" class="customer_tel" value="{$memo.customer_tel}"
        placeholder="顧客の連絡先TEL" />
    </td>
  </tr>
  
  <tr class="customer_mail">
    <th>顧客メールアドレス</th>
    <td>
      <input type="text" name="customer_mail" class="customer_mail" value="{$memo.customer_mail}"
        placeholder="顧客の連絡先メールアドレス" />
    </td>
  </tr>
  {*
  <tbody class="options hikiai">
    <tr class="customer">
      <th>顧客</th>
      <td>
        <dl>
          <dt>仕入先</dt>
          <dd><input type="text" name="customer" value="" /></dd>
          <dt>TEL</dt>
          <dd><input type="text" name="tel" value="" /></dd>
          <dt>住所</dt>
          <dd><input type="text" name="address" value="" /></dd>
        </dl>
      </td>
    </tr>
  </tbody>
  *}
  
  {*
  <tr class="imgs">
    <th>添付ファイル(複数可)</th>
    <td>
      <iframe name="upload" class="upload" src="../ajax/upload.php?c=imgs&t=image/jpeg&m=1"
        frameborder="0" allowtransparency="true"></iframe>
      <div class="upload_img">
        {if !empty($company.imgs)}
          {foreach $company.imgs as $i}
            <div class="img">
              <label><input type="checkbox" name="imgs_delete[]" value="{$i}" />削除</label>
              <br />
              <a href='{$_conf.media_dir}company/{$i}' target="_blank">
                <img src='{$_conf.media_dir}company/{$i}' />
              </a>
              <input type="hidden" name="imgs[]" value="{$i}" />
            </div>
          {/foreach}
        {/if}
      </div>
    </td>
  </tr>
  
  <tr class="machines">
    <th>機械(複数可)</th>
    
    <td>
    *}
    {*
      {if !empty($company.machines)}
        {foreach $company.machines as $m}
          <div class="machine">
            <input type="text" name="machines_maker[]" class="machines_maker" 
              value="{$m.maker}" placeholder="メーカー" />
            <input type="text" name="machines_model[]" class="machines_model" 
              value="{$m.model}" placeholder="型式" />
            <input type="text" name="machines_year[]" class="machines_year" 
              value="{$m.year}" placeholder="年式" />
            <input type="text" name="machines_memo[]" class="machines_memo" 
              value="{$m.memo}" placeholder="この機械についてのメモ" />  
          </div>
        {/foreach}
      {/if}
      
      <div class="machine">
        <input type="text" name="machines_maker[]" class="machines_maker" 
          value="" placeholder="メーカー" />
        <input type="text" name="machines_model[]" class="machines_model" 
          value="" placeholder="型式" />
        <input type="text" name="machines_year[]" class="machines_year" 
          value="" placeholder="年式" />
        <input type="text" name="machines_memo[]" class="machines_memo" 
          value="" placeholder="この機械についてのメモ" />  
      </div>
      <button id="machines_add">機械フォームを追加</button>
    *}
    {*
      <button id="machine_heritage">買い機械を登録</button>      
    </td>
  </tr>
  *}
</table>

<table class="memo form">
  <tr class="memo">
    <th>メモ</th>
    <td>
      <textarea name="memo" class="memo"
        placeholder="メモ内容を入力してください"
      >{$memo.memo}</textarea>
    </td>
  </tr>
</table>

<button type="submit" name="submit" class="submit" value="member">保存</button>

</form>

{/block}
