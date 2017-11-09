{extends file='include/layout.tpl'}

{block 'header'}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
    //// 数値のみに自動整形 ////
    $('input.price').change(function() {
        var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9]/g, '');
        $(this).val(price ? parseInt(price) : '');
    });

    //// datepicker ////
    $('input.date').datepicker({
        showAnim    : 'fadeIn',
        prevText    : '',
        nextText    : '',
        dateFormat  : 'yy/mm/dd',
        altFormat   : 'yy/mm/dd',
        changeMonth : true,
        appendText  : '',
        maxDate     : '',
        minDate     : ''
    });

    //// 時間コンボボックス ////
    var timeArray = [];
    for (i=13; i<24; i++) {
        timeArray.push(i + ":00");
        timeArray.push(i + ":30");
    }
    for (i=0; i<13; i++) {
        timeArray.push(i + ":00");
        timeArray.push(i + ":30");
    }
    $('input.time').autocomplete({
        source :  function(req, res) { res(timeArray);},
        minLength : 0
    }).click(function() {
        $(this).autocomplete('search');
    });


});

//// アップロード後のコールバック ////
function upload_callback (target, data)
{
    if (target == "top_img") {
        $.each(data, function(i, val) {
            var h =
                '<div class="img">' +
                '<label><input name="top_img_delete" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
                '<img src="/media/tmp/' + val.filename + '" />' +
                '</a>' +
                '<input name="top_img" type="hidden" value="' + val.filename + '" />'
                '</div>';
            $('.top_img .upload_img').html(h);
        });
    } else if (target == "img_01") {
        $.each(data, function(i, val) {
            var h =
                '<div class="img">' +
                '<label><input name="img_01_delete" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
                '<img src="/media/tmp/' + val.filename + '" />' +
                '</a>' +
                '<input name="img_01" type="hidden" value="' + val.filename + '" />'
                '</div>';
            $('.img_01 .upload_img').html(h);
        });
    } else if (target == "img_02") {
        $.each(data, function(i, val) {
            var h =
                '<div class="img">' +
                '<label><input name="img_02_delete" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
                '<img src="/media/tmp/' + val.filename + '" />' +
                '</a>' +
                '<input name="img_02" type="hidden" value="' + val.filename + '" />'
                '</div>';
            $('.img_02 .upload_img').html(h);
        });
    } else if (target == "img_03") {
        $.each(data, function(i, val) {
            var h =
                '<div class="img">' +
                '<label><input name="img_03_delete" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
                '<img src="/media/tmp/' + val.filename + '" />' +
                '</a>' +
                '<input name="img_03" type="hidden" value="' + val.filename + '" />'
                '</div>';
            $('.img_03 .upload_img').html(h);
        });
    }
}
</script>
<style type="text/css">
table.form td textarea {
    width: 492px;
    height: 9.6em;
    line-height: 1.2;
}

</style>
{/literal}
{/block}

{block 'main'}

{if !empty($flyer.id)}
  <a href="admin/flyer_menu.php?id={$flyer.id}" class="back_link">← 操作メニューに戻る</a>
{else}
  <a href="admin/flyer_list.php" class="back_link">← チラシメール一覧に戻る</a>
{/if}
<form class="machine" method="post" action="admin/flyer_do.php" enctype="multipart/form-data">
  <input type="hidden" name="id" class="id" value="{$flyer.id}" />

<table class="machine form">
  <tr class="name">
    <th>タイトル<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="title" class="name default" value="{$flyer.title}"
        placeholder="タイトル" required />
    </td>
  </tr>

  <tr class="name">
    <th>メール表題<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="subject" class="name default" value="{$flyer.subject}"
        placeholder="メール表題" required />
    </td>
  </tr>

  <tr class="name">
    <th>送信元名<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="from_name" class="from_name" value="{$flyer.from_name}"
        placeholder="送信元名" required />
    </td>
  </tr>
  <tr class="mail">
    <th>送信元メールアドレス<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="from_mail" class="from_mail" value="{$flyer.from_mail}"
        placeholder="xxx@yyy.com" required />
    </td>
  </tr>

  <tr class="bid">
    <th>送信スケジュール</th>
    <td>
      <span class="alert">※</span> 時間指定しない場合は、即時送信されます<br />
      <input type="text" name="send_date" class="send_date date" value="{$flyer.send_date|date_format:'%Y/%m/%d'}" />
      <input type="text" name="send_time" class="send_time time" value="{$flyer.send_date|date_format:'%H:%M'}" />
    </td>
  </tr>

  {*** チラシ内容 ***}
  <tr class="top_img">
    <th>TOP画像</th>
    <td>
      <span class="alert">※</span> 登録できる画像ファイル形式はJPEG,GIF,PNGです<br />
      <iframe name="upload" class="upload" src="../ajax/upload.php?c=top_img&t=image/*"
        frameborder="0" allowtransparency="true"></iframe>
      <div class="upload_img">
        {if !empty($flyer.design_top_img)}
          <div class="img">
            <label><input type="checkbox" name="top_img_delete" value="{$flyer.design_top_img}" />削除</label>
            <br />
            <a href='{$_conf.media_dir}flyer/{$flyer.design_top_img}' target="_blank">
              <img src='{$_conf.media_dir}flyer/{$flyer.design_top_img}' />
            </a>
            <input type="hidden" name="top_img" value="{$flyer.design_top_img}" />
          </div>
        {/if}
      </div>
    </td>
  </tr>

  <tr class="spec">
    <th>メイン本文</th>
    <td>
      <textarea name="design_main_text" class="design_main_text"
        placeholder="大きい文字で表示される、メインの内容を記述してください"
        >{$flyer.design_main_text}</textarea>
    </td>
  </tr>

  <tr class="spec">
    <th>サブ本文</th>
    <td>
      <textarea name="design_sub_text" class="design_sub_text"
        placeholder="小さい文字でメインの次に表示される内容を記述してください"
        >{$flyer.design_sub_text}</textarea>
    </td>
  </tr>

  <tr class="name">
    <th>リンクボタン<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="design_button" class="design_button default" value="{$flyer.design_button}"
        placeholder="リンクボタンに表示される文字" required />
    </td>
  </tr>

  <tr class="name">
    <th>リンク先URL<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="design_url" class="design_url default" value="{$flyer.design_url}"
        placeholder="リンク先のURL" required />
    </td>
  </tr>

  <tr class="spec">
    <th>リンクボタン下文章</th>
    <td>
      <textarea name="design_bottom_text" class="design_bottom_text"
        placeholder="リンクボタンの下に表示される内容を記述してください"
        >{$flyer.design_bottom_text}</textarea>
    </td>
  </tr>

  <tr class="img_01">
    <th rowspan="3">画像(3枚まで)</th>
    <td>
      <span class="alert">※</span> 登録できる画像ファイル形式はJPEG,GIF,PNGです<br />
      <iframe name="upload" class="upload" src="../ajax/upload.php?c=img_01&t=image/*"
        frameborder="0" allowtransparency="true"></iframe>
      <div class="upload_img">
        {if !empty($flyer.design_img_01)}
          <div class="img">
            <label><input type="checkbox" name="img_01_delete" value="{$flyer.design_img_01}" />削除</label>
            <br />
            <a href='{$_conf.media_dir}flyer/{$flyer.design_img_01}' target="_blank">
              <img src='{$_conf.media_dir}flyer/{$flyer.design_img_01}' />
            </a>
            <input type="hidden" name="img_01" value="{$flyer.design_img_01}" />
          </div>
        {/if}
      </div>
    </td>
  </tr>

  <tr class="img_02">
    <td>
      <iframe name="upload" class="upload" src="../ajax/upload.php?c=img_02&t=image/*"
        frameborder="0" allowtransparency="true"></iframe>
      <div class="upload_img">
        {if !empty($flyer.design_img_02)}
          <div class="img">
            <label><input type="checkbox" name="img_02_delete" value="{$flyer.design_img_02}" />削除</label>
            <br />
            <a href='{$_conf.media_dir}flyer/{$flyer.design_img_02}' target="_blank">
              <img src='{$_conf.media_dir}flyer/{$flyer.design_img_02}' />
            </a>
            <input type="hidden" name="img_02" value="{$flyer.design_img_02}" />
          </div>
        {/if}
      </div>
    </td>
  </tr>

  <tr class="img_03">
    <td>
      <iframe name="upload" class="upload" src="../ajax/upload.php?c=img_03&t=image/*"
        frameborder="0" allowtransparency="true"></iframe>
      <div class="upload_img">
        {if !empty($flyer.design_img_03)}
          <div class="img">
            <label><input type="checkbox" name="img_03_delete" value="{$flyer.design_img_03}" />削除</label>
            <br />
            <a href='{$_conf.media_dir}flyer/{$flyer.design_img_03}' target="_blank">
              <img src='{$_conf.media_dir}flyer/{$flyer.design_img_03}' />
            </a>
            <input type="hidden" name="img_03" value="{$flyer.design_img_03}" />
          </div>
        {/if}
      </div>
    </td>
  </tr>

</table>

<button type="submit" name="submit" class="submit" value="member">入力内容を保存</button>

</form>
{/block}
