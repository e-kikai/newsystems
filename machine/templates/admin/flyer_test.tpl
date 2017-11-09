{extends file='include/layout.tpl'}

{block 'header'}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
});

</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
<a href="admin/flyer_menu.php?id={$flyer.id}" class="back_link">← 操作メニューに戻る</a>

<form class="machine" method="post" action="admin/flyer_test_do.php">
  <input type="hidden" name="id" class="id" value="{$flyer.id}" />

<table class="machine form">
  <tr class="mail">
    <th>テスト送信先メールアドレス<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="mail" class="mail" value="{$flyer.from_mail}"
        placeholder="xxx@yy.com" required />
    </td>
  </tr>


</table>

<button type="submit" name="submit" class="submit" value="member">テスト送信を行う</button>

</form>
{/block}
