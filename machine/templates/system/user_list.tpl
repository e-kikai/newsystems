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
            var data = {
              'id': $.trim($(this).val()),
            }

            // 送信確認
            if (!confirm($.trim($_parent.find('td.user_name').text()) + "\nこのユーザ情報を削除します。よろしいですか。")) { return false; }

            $.post('/system/ajax/user.php', {
                'target': 'system',
                'action': 'delete',
                'data': data,
              }, function(res) {
                if (res != 'success') {;
                alert(res);
                return false;
              }

              // 登録完了
              alert($.trim($_parent.find('td.user_name').text()) + "\nの削除が完了しました"); $_parent.remove();
              return false;
            }, 'text');

          return false;
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <a href="system/user_form.php">新規登録</a>|
  <a href="system/user_list.php?output=csv">CSV出力</a>

  <table class='list user'>
    <thead>
      <tr>
        <th class='id'>ID</th>
        <th class="user_name">ユーザ名</th>
        <th class="company">会社名</th>
        <th class="role">権限</th>
        <th class="changed_at">変更日時</th>
        <th class="delete">削除</th>
      </tr>
    </thead>

    {foreach $userList as $u}
      <tr>
        <td class='id'>{$u.id}</td>
        <td class='user_name'>
          <a href="system/user_form.php?id={$u.id}">{$u.user_name}</a>
        </td>
        <td class='company'>{$u.company}</td>
        <td class='company'>{$u.role}</td>
        <td class='changed_at'>
          {if !empty($u.changed_at)}
            {$u.changed_at|date_format:'%Y/%m/%d %H:%M'}
          {else}
            {$u.created_at|date_format:'%Y/%m/%d %H:%M'}
          {/if}
        </td>
        <td class='delete'>
          <button class="delete" value="{$u.id}">削除</a>
        </td>
      </tr>
    {/foreach}
  </table>

{/block}