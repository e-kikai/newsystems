{extends file='include/layout.tpl'}

{block 'header'}
  {literal}
    <script type="text/javascript">
      $(function() {
        //// 一括削除処理 ////
        $('button.delete_button').click(function() {
          // チェック情報を取得
          var vals = $('input.id:visible:checked').map(function() {
            return $(this).val();
          }).get();

          if (!vals.length) {
            alert('処理を行いたいお知らせにチェックを入れてください');
            return false;
          }

          if (!confirm("チェックした " + vals.length + "件 のお知らせを削除しますか？")) { return false; }

          // 処理を実行
          $.post('/system/ajax/info.php',
            {"target": "system", "action": "delete", "data": vals},
            function(data) {
              if (data == 'success') {
                alert('お知らせを削除しました');
                location.href = '/system/info_list.php';
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

      table.list .check,
      table.list .id {
        width: 30px;
      }

      table.list td.id,
      table.list td.group_id {
        text-align: right;
      }

      table.list .target {
        width: 100px;
      }

      table.list .group_id {
        width: 60px;
      }

      table.list .info_date {
        width: 5em;
      }

      table.list .created_at {
        width: 8em;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <a href="system/info_form.php">新規登録</a>
  <button class="delete_button">チェックしたお知らせを削除</button>

  <table class='info list'>
    <thead>
      <tr>
        <th class="check"></th>
        <th class='id'>ID</th>
        <th class="info_date">日付</th>
        <th class="target">対象</th>
        <th class="group_id">団体ID</th>
        <th class="contents">内容</th>
        <th class="created_at">登録日</th>
      </tr>
    </thead>

    {foreach $infoList as $i}
      <tr class='{cycle values='even, odd'}'>
        <td class="check"><input type="checkbox" class="id" value="{$i.id}" /></td>
        <td class='id'>{$i.id}</td>
        <td class='info_date'>
          <a href="/system/info_form.php?id={$i.id}">{$i.info_date|date_format:'%Y/%m/%d'}</a>
        </td>
        <td class='target'>{$i.target}</td>
        <td class='group_id'>{$i.group_id}</td>
        <td class='contents'>{$i.contents|escape|nl2br nofilter}</td>
        <td class='created_at'>{$i.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
      </tr>
    {/foreach}
  </table>
{/block}