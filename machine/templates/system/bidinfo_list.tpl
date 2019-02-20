{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 削除処理 ////
    $('button.delete').click(function() {
        $_parent = $(this).closest('tr');
        var data = {
            'id': $.trim($(this).val()),
        }

        // 送信確認
        if (!confirm($.trim($_parent.find('td.bid_name').text()) + "\nこの入札会バナー情報を削除します。よろしいですか。")) { return false; }

        $.post('/system/ajax/bidinfo.php', {
            'target': 'system',
            'action': 'delete',
            'data'  : data,
        }, function(res) {
            if (res != 'success') { alert(res); return false; }

            // 登録完了
            alert($.trim($_parent.find('td.bid_name').text()) + "\nの削除が完了しました");
            $_parent.remove();
            return false;
        }, 'text');

        return false;
    });
});
</script>
<style type="text/css">
.select_area {
  margin: 8px 0;
}

td.banner img {
  width: 120px;
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
  <a href="/system/bidinfo_form.php">新規登録</a> ::
  <a href="/system/bidinfo_list.php">表示中</a> |
  <a href="/system/bidinfo_list.php?e=all">すべて</a>
</div>

{if empty($bidinfoList)}
  <div class="error_mes">現在表示中の入札会バナーはありません。</div>
{else}
<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="banner">入札会バナー/リンク</th>
      <th class="bid_name">入札会名</th>
      <th class="organizer">主催者名</th>
      <th class="place">入札会場</th>
      <th class="created_at">下見期間</th>
      <th class="created_at">入札日時</th>
      <th class="delete"></th>
    </tr>
  </thead>

  {foreach $bidinfoList as $b}
    <tr>
      <td class='id'>{$b.id}</td>
      <td class='banner'>
        <a href="{$b.uri}" target="_blank">
          {if !empty($b.banner_file)}
            <img src="{$_conf.media_dir}banner/{$b.banner_file}" />
          {else}
            バナー表示なし<br />(新着メールのみ)
          {/if}
        </a>
      </td>
      <td class='bid_name'>
        <a href="/system/bidinfo_form.php?id={$b.id}">{$b.bid_name}</a>
      </td>
      <td class='organizer'>{$b.organizer}</td>
      <td class='place'>{$b.place|escape|nl2br nofilter}</td>
      <td class='created_at'>
        {$b.preview_start_date|date_format:'%Y/%m/%d'} 〜 {$b.preview_end_date|date_format:'%m/%d'}
      </td>
      <td class='created_at'>{$b.bid_date|date_format:'%Y/%m/%d %H:%M'}</td>
      <td class="delete"><button class="delete" value="{$b.id}">削除</button></td>
    </tr>
  {/foreach}
</table>
{/if}
{/block}
