{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        //// 削除処理 ////
        $('button.delete').click(function() {
          $_parent = $(this).closest('tr');

          // 送信確認
          var m = "\n\nこの中ジャンルを削除します。\n\n※ 中ジャンルを削除すると、それ以下の中ジャンル、ジャンルも削除されます。\nよろしいですか。";
          if (!confirm($.trim($_parent.find('td.large_name').text()) + m)) {
            return false;
          }

          $.post('/system/ajax/post.php', {
            _target: 'largeGenre',
            _action: 'delete',
            id: $.trim($(this).val()),
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
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="select_area">
    <a href="/system/large_genre_form.php?x={$xlGenreId}">新規登録</a>
  </div>

  {if empty($largeList)}
    <div class="error_mes">中ジャンルはありません。</div>
  {else}
    <table class='list contact'>
      <thead>
        <tr>
          <th class='id'>ID</th>
          <th class="large_name">中ジャンル名</th>
          <th class="change">ジャンル一覧</th>
          <th class="hide_option">非表示オプション</th>
          <th class="order_no">並び順</th>
          <th class="delete"></th>
        </tr>
      </thead>

      {foreach $largeList as $l}
        <tr>
          <td class='id'>{$l.id}</td>
          <td class='large_name'>
            <a href="/system/large_genre_form.php?id={$l.id}">{$l.large_genre}</a>
          </td>
          <td class='bid_name'>
            <a href="/system/genre_list.php?l={$l.id}">ジャンル一覧 >> </a>
          </td>
          <td class='hide_option'>
            {if $l.hide_option == 1}非表示
            {elseif $l.hide_option == 2}カタログ専用
            {/if}
          </td>
          <td class='order_no'>{$l.order_no}</td>
          <td class="delete"><button class="delete" value="{$l.id}">削除</button></td>
        </tr>
      {/foreach}
    </table>
  {/if}
{/block}