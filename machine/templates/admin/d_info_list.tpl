{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    //// 変数の設定 ////
    {literal}
      $(function() {
        /// 削除 ///
        $('button.delete').click(function() {
          $_parent = $(this).closest('tr');
          var data = {
            'id': $.trim($(this).val()),
          }
          console.log(data);

          // 送信確認
          if (!confirm("お知らせの削除を行います。よろしいですか？")) { return false; }

          $.post('/admin/ajax/d_info.php', {
            'target': 'admin',
            'action': 'delete',
            'data': data,
          }, function(res) {
            if (res == 'success') {
              alert('お知らせを削除しました');
              location.href = '/admin/d_info_list.php';
            } else {
              alert(res);
            }
          });

          return false;
        });
      });
    </script>
    <style type="text/css">
      td.button,
      th.button,
      button.copy {
        width: 50px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <a class="new" href="admin/d_info_form.php">新規お知らせ作成</a>

  {if empty($dInfoList)}
    <div class="error_mes">お知らせはありません</div>
  {/if}

  {*** ページャ ***}
  {* {include file="include/pager.tpl"} *}

  {foreach $dInfoList as $di}
    {if $di@first}
      <table class="machines list">
        <tr>
          <th class="name">日付</th>
          <th class="name">タイトル</th>
          <th class="">内容</th>
          <th class="name">作成日時</th>
          <th class="button">削除</th>
        </tr>
      {/if}

      <tr>
        <td class="name">{$di.info_date|date_format:'%Y/%m/%d'}</td>
        <td class="name"><a href="admin/d_info_form.php?id={$di.id}">{$di.title}</a></td>
        <td class="">{$di.contents|escape|nl2br nofilter}</td>
        <td class="name">{$di.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
        <td class="delete"><button class="delete" value="{$di.id}">削除</button></td>
      </tr>


      {if $di@last}
      </table>
    {/if}
  {/foreach}

  {*** ページャ ***}
  {* {include file="include/pager.tpl"} *}

{/block}