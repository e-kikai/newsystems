{extends file='include/layout.tpl'}
{block name='header'}
<link href="{$_conf.libjs_uri}/css/login.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    $('input.submit').click(function() {
        var e = '';
        
        if ($('select.company').val() == '') {
            e += '会社を選択してください';
        }
        
        if ($('input#csv').val() == '') {
            e += 'ファイルが選択されていません';
        }
        
        if (e != '') { alert(e); return false; }
        
        return true;
     });
});
</script>
<style type="text/css">
.csv_form {
  width: 460px;
  border: 1px solid #AAA;
  margin: 8px auto;
  padding: 4px 16px;
  border-radius: 8px;
}

select.company {
  display: block;
  margin: 4px 0;
}
</style>
{/literal}
{/block}

{block 'main'}
<form class='csv' method='post' action='system/csv_conf.php' enctype="multipart/form-data">
  <fieldset class='csv_form'>
    <legend>CSVファイル</legend>
    <input type='file' name='csv' id='csv' />
    <select class="company" name="company">
      <option value="">▼会社を選択▼</option>
      {foreach $companyList as $key => $c}
        {if $c@first}
          <optgroup label="{$c.treenames}">
        {elseif $companyList[$key-1]['treenames'] !=  $c.treenames}
          </optgroup>
          <optgroup label="{$c.treenames}">
        {/if}
        <option value="{$c.id}">{'/(株式|有限|合.)会社/'|preg_replace:'':$c.company}</option>
        {if $c@last}
          <optgroup label="{$c.treenames}">
        {/if}
      {/foreach}
    </select>
    <input type='submit' name='submit' class='submit' value='アップロード開始' />
  </fieldset>
</form>

{/block}
