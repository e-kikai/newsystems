{extends file='include/layout.tpl'}
{block name='header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.validate.min.js"></script>
{literal}
<script type="text/JavaScript">
$(function() {
    //// フォームバリデータ初期化 ////
    $_form = $('#form');
    $_form.validate();

    //// 送信処理 ////
    $('button.submit').click(function() {
        ///// バリデーション ////
        if (!$_form.valid()) { return false; }
    });
});
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

<form id="form" action="system/company_list.php" method="get" target="_blank">
<input type="hidden" name="output" value="pdf" />

<table class="member form">
   <tr class="">
    <th>支払日<span class="required">(必須)</span></th>
    {*
    <td><input type="text" name="date" value="平成{date('Y')-1988}年{date('n月t日')}" required /></td>
    *}
    <td><input type="text" name="date" value="{date('Y年n月t日')}" required /></td>
  </tr>
</table>
<button type="submit" class="submit" value="">PDFをダウンロード</button>
</form>
{/block}
