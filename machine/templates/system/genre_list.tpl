{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 削除処理 ////
    $('button.delete').click(function() {
        $_parent = $(this).closest('tr');
        
        // 送信確認
        var m = "\n\nこのジャンルを削除します。\n\nジャンルを削除すると、登録されている機械も削除されます。\nよろしいですか。";
        if (!confirm($.trim($_parent.find('td.genre').text()) + m)) {
            return false;
        }
        
        $.post('/system/ajax/post.php', {
            _target : 'genre',
            _action : 'delete',
            id      : $.trim($(this).val()),
        }, function(res) {
            if (res != 'success') { alert(res); return false; }
            
            $_parent.remove(); // 削除完了・項目削除
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
.select_area {
  margin: 8px 0;
}

table th.delete,
table td.delete {
  width: 50px;
  text-align: center;;
}

button.delete {
  width: 50px;
}
</style>
{/literal}
{/block}

{block 'main'}
<div class="select_area">
  <a href="/system/genre_form.php?l={$largeId}">新規登録</a>
</div>

{if empty($genreList)}
  <div class="error_mes">中ジャンルはありません。</div>
{else}
<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="genre_name">ジャンル名</th>
      <th class="capacity">能力</th>
      <th class="hide_option">非表示オプション<br />(中ジャンルで設定)</th>      
      <th class="order_no">並び順</th>
      <th class="delete"></th>
    </tr>
  </thead>
  
  {foreach $genreList as $g}
    <tr>
      <td class='id'>{$g.id}</td>
      <td class='genre_name'>
        <a href="/system/genre_form.php?id={$g.id}">{$g.genre}</a>
      </td>
      <td class='capacity'>{if !empty($g.capacity_unit)}{$g.capacity_label}({$g.capacity_unit}){/if}
      </td>
      <td class='hide_option'>
        {if $g.hide_option == 1}非表示
        {elseif $g.hide_option == 2}カタログ専用
        {elseif preg_match("/^その他/", $g.genre)}(「その他〜」は、ジャンル検索非表示){/if}
      </td>
      <td class='order_no'>{$g.order_no}</td>
      <td class="delete"><button class="delete" value="{$g.id}">削除</button></td>
    </tr>
  {/foreach}
</table>
{/if}
{/block}
