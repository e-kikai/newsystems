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
      $('input[required], textarea[required]').each(function() {
          if ($(this).val() == '') {
              error = '必須項目が入力されていません';
              return false;
          }
      });
      if (!confirm('保存しますよろしいですか')) { return false; }

      $.post('/admin/ajax/urikai.php',
          {"target": "system", "action": "set", "data": {
              'id'        : $('input#id').val(),
              'goal'      : $('select#goal').val(),
              'contents'  : $('textarea#contents').val(),
          }},
          function(data) {
              if (data == 'success') {
                  alert('売りたし買いたしを保存しました');
                  location.href = '/admin/urikai_list.php';
              } else {
                  alert(data);
              }
          }
      );

      return false;
  });
});
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
      {if empty($id)}新規{else}{$urikai.created_at|date_format:'%Y/%m/%d %H:%M'}{/if}
    </td>
  </tr>

  <tr class="target">
    <th>売り買い<span class="required">(必須)</span></th>
    <td>
      {html_options name=goal id=goal options=$goalList selected=$urikai.goal}
    </td>
  </tr>

  <tr class="contents">
    <th>内容<span class="required">(必須)</span></th>
    <td>
      <textarea name="contents" id="contents" required>{$urikai.contents}</textarea>
    </td>
  </tr>
</table>

<button type="button" name="submit" class="submit" value="member">変更を保存</button>

</form>
{/block}
