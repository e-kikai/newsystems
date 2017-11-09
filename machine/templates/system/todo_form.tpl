{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
<link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.textresizer.js"></script>

<script type="text/JavaScript">
{literal}
$(function() {
    //// 処理 ////
    $('button.submit').click(function() {
        var error = '';
        $('input[required]').each(function() {
            if ($(this).val() == '') {
                error = '必須項目が入力されていません';
                return false;
            }
        });
        if (!confirm('保存しますよろしいですか')) { return false; }
        
        $.post('/system/ajax/todo.php',
            {"target": "system", "action": "set", "data": {
                'id'       : $('input#id').val(),
                'title'    : $('input#title').val(),
                'target'   : $('select#target').val(),
                'contents' : $('textarea#contents').val(),
            }},
            function(data) {
                if (data == 'success') {
                    alert('開発TODOを保存しました');
                    location.href = '/system/todo_list.php';
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
</style>
{/literal}
{/block}

{block 'main'}
<div class="form_comment">
  <span class="alert">※</span>
  　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
</div>

<form class="todo" method="POST" action="">
<table class="form todo">
  <tr class="id">
    <th>ID</th>
    <td>
      {if empty($id)}新規{else}{$id}<input type="hidden" name="id" id="id" value="{$id}" />{/if}
    </td>
  </tr>
  
  <tr class="target">
    <th>対象<span class="required">(必須)</span></th>
    <td>
      {html_options name=target id=target options=$targetList selected=$todo.target}
    </td>
  </tr>
  
  <tr class="info_date">
    <th>タイトル<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="title" id="title" value="{$todo.title}"
        placeholder="作業の概要" required />
    </td>
  </tr>
  
  <tr class="state">
    <th>進捗状況</th>
    <td>{if !empty($todo.state)}{$todo.state}{/if}</td>
  </tr>
  
  <tr class="contents">
    <th>内容<span class="required">(必須)</span></th>
    <td>
      <textarea name="contents" id="contents" required>{$todo.contents}</textarea>
    </td>
  </tr>
  
  <tr class="contents">
    <th>登録日</th>
    <td>{if !empty($todo.created_at)}{$todo.created_at|date_format:'%Y/%m/%d'}{/if}</td>
  </tr>
</table>

<button type="button" name="submit" class="submit" value="member">変更を保存</button>

</form>
{/block}
