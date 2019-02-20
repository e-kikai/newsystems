{extends file='include/layout.tpl'}

{block 'header'}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
//// 変数の設定 ////
{literal}
$(function() {
  //// 一括削除 ////
  $('button.delete').click(function() {
      return confirm("売りたし買いたしの削除を行います。よろしいですか？");
  });

  //// 処理 ////
  $('button.end').click(function() {
      var error = '';
      var id = $(this).val();
      if (!confirm('書き込みを解決済みにします。よろしいですか')) { return false; }

      $.post('/admin/ajax/urikai.php',
          {"target": "system", "action": "set_end_date", "data": { 'id' : id, }},
          function(data) {
              if (data == 'success') {
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
table.list .count {
  width: 60px;
}

table.list td.count {
  text-align: right;
}

td.button,
th.button,
button.copy {
  width: 50px;
}

.goal {
  width: 100px;
  font-weight: bold;
}

.goal.cell {
  color: #C00;
}

.goal.buy {
  color: #00C;
}
</style>
{/literal}
{/block}

{block 'main'}

<a class="new" href="admin/urikai_form.php">売りたし買いたしを書き込む</a>

{if empty($urikaiList)}
  <div class="error_mes">まだ売りたし買いたしの書きこみはありません</div>
{/if}

{*** ページャ ***}
{include file="include/pager.tpl"}

{foreach $urikaiList as $uk}
  {if $uk@first}
  <table class="machines list">
    <tr>
      <th class='id'>No.</th>
      <th class="goal">売り買い</th>
      <th class="">内容</th>
      <th class="info_date">書き込み日付</th>
      <th class="">解決</th>

    </tr>
  {/if}
  <tr>
    <td class='id'>{$uk.id}</td>
    <td class="goal {$uk.goal}">
      {if $uk.goal == "cell"}売りたし{else}買いたし{/if}
    </td>
    <td>{$uk.contents|escape|auto_link|nl2br nofilter}</td>
    <td class="">{$uk.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
    <td class="">
      {if empty($uk.end_date)}
        <button type="button" name="end" class="end" value="{$uk.id}">解決済みにする</button>
      {else}
        解決済み {$uk.end_date|date_format:'%Y/%m/%d %H:%M'}
      {/if}
    </td>
  </tr>

  {if $uk@last}
  </table>
  {/if}
{/foreach}

{*** ページャ ***}
{include file="include/pager.tpl"}

{/block}
