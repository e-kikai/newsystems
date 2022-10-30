{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 削除処理 ///
        $('button.delete').click(function() {
          $_parent = $(this).closest('tr');

          // 送信確認
          var m = "\n\nこの大ジャンルを削除します。\n\n大ジャンルを削除すると、それ以下の中ジャンル、ジャンルも削除されます。\nよろしいですか。";
          if (!confirm($.trim($_parent.find('td.xl_name').text()) + m)) {
            return false;
          }

          $.post('/system/ajax/post.php', {
            _target: 'xlGenre',
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
    <a href="/system/xl_genre_form.php">新規登録</a>
  </div>

  {if empty($xlList)}
    <div class="error_mes">大ジャンルはありません。</div>
  {else}
    <table class='list contact'>
      <thead>
        <tr>
          <th class='id'>ID</th>
          <th class="xl_name">大ジャンル名</th>
          <th class="change">中ジャンル一覧</th>
          <th class="order_no">並び順</th>
          <th class="delete"></th>
        </tr>
      </thead>

      {foreach $xlList as $x}
        <tr>
          <td class='id'>{$x.id}</td>
          <td class="xl_name xs_{$x.id}">
            <a href="/system/xl_genre_form.php?id={$x.id}">{$x.xl_genre}</a>
          </td>
          <td class='bid_name'>
            <a href="/system/large_genre_list.php?x={$x.id}">中ジャンル一覧 >> </a>
          </td>
          <td class='order_no'>{$x.order_no}</td>
          <td class="delete"><button class="delete" value="{$x.id}">削除</button></td>
        </tr>
      {/foreach}
    </table>
  {/if}
{/block}