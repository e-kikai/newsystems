{extends file='include/layout.tpl'}

{block 'header'}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
  //// 処理 ////
  $('button.submit').click(function() {
      var error = '';
      var $_self = $(this);

      $('input[required], textarea[required]').each(function() {
          if ($(this).val() == '') {
              error = '必須項目が入力されていません';
              return false;
          }
      });
      if (!confirm('保存しますよろしいですか')) { return false; }

      $_self.prop("disabled", true);
      $('button.submit').text('メール送信中、しばらくお待ちください、、、');

      $.post('/admin/ajax/urikai.php',
          {"target": "system", "action": "set", "data": {
              'id'          : $('input#id').val(),
              'goal'        : $('input.goal:checked').val(),
              'contents'    : $('textarea#contents').val(),
              'tel'         : $('input#tel').val(),
              'fax'         : $('input#fax').val(),
              'mail'        : $('input#mail').val(),
              'imgs'        : $('input.imgs').map(function() { return $(this).val(); }).get(),
              'imgs_delete' : $('input.imgs_delete:checked').map(function() { return $(this).val(); }).get(),
          }},
          function(data) {
              if (data == 'success') {
                  alert('売りたし買いたしを保存しました');
                  location.href = '/admin/urikai_list.php';
              } else {
                  alert(data);
                  $('button.submit').text('書き込む・メールを送信');
                  $_self.prop("disabled", false);
              }
          }
      );

      return false;
  });
});

//// アップロード後のコールバック ////
function upload_callback (target, data)
{
    if (target == "imgs") {
        $.each(data, function(i, val) {
            var h =
                '<div class="img">' +
                '<label><input class="imgs_delete" name="imgs_delete[]" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
                '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
                '<img src="/media/tmp/' + val.filename + '" />' +
                '</a>' +
                '<input class="imgs" name="imgs[]" type="hidden" value="' + val.filename + '" />'
                '</div>';
            $('.imgs .upload_img').append(h);
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

tr.target td label {
  margin-right: 8px;
  font-weight: bold;
}

input.goal {
  margin-right: 4px;
}

tr.target td label:nth-child(1) {
  color: #C00;
}

tr.target td label:nth-child(2) {
  color: #00C;
}
</style>
{/literal}
{/block}

{block 'main'}

<a href="admin/urikai_list.php" class="back_link">← 売りたし買いたし一覧に戻る</a>

<form class="info" method="POST" action="">
<table class="info form">
  <tr class="id">
    <th>No.</th>
    <td>
      {if empty($id)}新規{else}{$id}<input type="hidden" name="id" id="id" value="{$id}" />{/if}
    </td>
  </tr>

  <tr class="info_date">
    <th>書きこみ日時</th>
    <td>
      {if empty($id)}{$smarty.now|date_format:'%Y/%m/%d %H:%M'}{else}{$urikai.created_at|date_format:'%Y/%m/%d %H:%M'}{/if}
    </td>
  </tr>

  <tr class="target">
    <th>売り買い<span class="required">(必須)</span></th>
    <td>
      {html_radios name=goal class=goal options=$goalList selected=$urikai.goal}
    </td>
  </tr>

  <tr class="contents">
    <th>内容<span class="required">(必須)</span></th>
    <td>
      <textarea name="contents" id="contents" required>{$urikai.contents}</textarea>
    </td>
  </tr>

  <tr class="tel">
    <th>問い合わせTEL</th>
    <td><input type="text" name="tel" id="tel" value="{$urikai.tel}" /></td>
  </tr>

  <tr class="fax">
    <th>問い合わせFAX</th>
    <td><input type="text" name="fax" id="fax" value="{$urikai.fax}" /></td>
  </tr>

  <tr class="mail">
    <th>問い合わせメールアドレス</th>
    <td><input type="text" name="mail" id="mail" value="{$urikai.mail}" /></td>
  </tr>

  <tr class="imgs">
    <th>画像(複数可)</th>
    <td>
      <iframe name="upload" class="upload" src="../ajax/upload.php?c=imgs&t=image/jpeg&m=1"
        frameborder="0" allowtransparency="true"></iframe>
      <div class="upload_img">
        {foreach $urikai.imgs as $i}
          <div class="img">
            <label><input type="checkbox" name="imgs_delete[]" value="{$i}" />削除</label>
            <br />
            <a href='{$_conf.media_dir}machine/{$i}' target="_blank">
              <img src='{$_conf.media_dir}machine/{$i}' />
            </a>
            <input type="hidden" name="imgs[]" value="{$i}" />
          </div>
        {/foreach}
      </div>
    </td>
  </tr>
</table>

<button type="button" name="submit" class="submit" value="member">書き込む・メールを送信</button>

</form>
{/block}
