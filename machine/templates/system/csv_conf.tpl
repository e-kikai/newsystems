{extends file='include/layout.tpl'}
{block 'header'}
<link href="{$_conf.libjs_uri}/css/login.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 一括削除処理 ////
    $('button.csv_submit').click(function() {
        if (!confirm("一括登録を開始します。よろしいですか？")) { return false; }

        // 処理を実行
        $.post('/system/ajax/csv.php',
            {"target": "system", "action": "setCsv", "data": ''},
            function(data) {
                if (data == 'success') {
                    alert('一括登録が完了しました');
                    location.href = '/system/';
                } else {
                    alert(data);
                }
            }
        );
    });
});
</script>
<style type="text/css">
table.list {
  width: 100%;
  margin: 8px auto;
}

table.list td,
table.list th {
  padding: 2px;
  border: 1px dotted #BBB;
  vertical-align: middle;
  background: #FFF;
}

table.list th {
  text-align: center;
  color: #EFE;
  background: #040;
}

table.list tr:nth-child(even) td {
  background: #EFE
}


table.list .no,
table.list .capacity,
table.list .price {
  width: 50px;
}

table.list .id,
table.list .imgs,
table.list .year {
  width: 40px;
}

table.list .genre,
table.list .name,
table.list .maker,
table.list .model {
  width: 80px;
}

table.list td.id,
table.list td.no,
table.list td.capacity,
table.list td.year,
table.list td.price {
  text-align: right;
}

img.thumbnail {
  max-width: 60px;
  max-height: 60px;
}

/*******/
.table_area {
  overflow: scroll;
  width: 100%;
  height: 360px;
}

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
    <legend>CSVファイル(再アップロード)</legend>
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
        <option value="{$c.id}"{if $c.id  == $company.id}selected="selected"{/if}>{'/(株式|有限|合.)会社/'|preg_replace:'':$c.company}</option>
        {if $c@last}
          <optgroup label="{$c.treenames}">
        {/if}
      {/foreach}
    </select>
    <input type='submit' name='submit' class='submit' value='アップロード開始' />
  </fieldset>
</form>

<ul>
  <li>「在庫場所」は、新規登録の場合は全て「本社」になります</li>
  <li>既に登録された機械(IDが表示されているもの)は、変更されません</li>
  <li>リストにない機械が登録されていた場合、削除されます</li>
  <li>「能力」「試運転」「表示オプション」は登録されませんので、一括登録後各自変更してください</li>
</ul>

<button class="csv_submit">一括登録を反映する</button>
<div class="company">{$company.company} 新規登録 : {$createCount}件、変更なし : {$updateCount}件、削除 : {$deleteCount}件</div>
<div class="table_area">
  <table class='csv list'>
    <thead>
      <tr>
        <th class="id">ID</th>
        <th class="no">管番</th>
        <th class="genre">ジャンル</th>
        <th class="name">機械名</th>
        <th class="capacity">主能力</th>
        <th class="maker">メーカー</th>
        <th class="model">型式</th>
        <th class="year">年式</th>
        <th class="spec">仕様</th>
        <th class="accessory">附属品</th>
        <th class="price">価格</th>
        <th class="imgs">画像</th>
      </tr>
    </thead>

    {foreach $machineList as $m}
      {* (変更)変更しない、処理を飛ばす *}
      <tr class='{cycle values='even, odd'}'>
        <td class="id">
          {if empty($m.id)}登録{else}{$m.id}{/if}
        </td>
        <td class="no">{$m.no}</td>
        <td class="genre">{$m.genre}</td>
        <td class="name">{$m.name}</td>
        <td class="capacity">{$m.capacity}{$m.capacity_unit}</td>
        <td class="maker">{$m.maker}</td>
        <td class="model">{$m.model}</td>
        <td class="year">{$m.year}</td>
        <td class="spec">{$m.spec}</td>
        <td class="accessory">{$m.accessory}</td>
        <td class="price">{if !empty($m.price)}{$m.price|number_format}{/if}</td>
        <td class="imgs">
          {if !empty($m.used_imgs)}
            {foreach $m.used_imgs as $i}
              <a href="https://www.jp.usedmachinery.bz/assets/images/jpmachines/{$i}" target="_blank">◎</a>            
            {/foreach}
          {/if}
        </td>
      </tr>
    {/foreach}
  </table>
</div>
{/block}
