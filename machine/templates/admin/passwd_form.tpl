{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
      $('.passwd_change').click(function() {
          var error = '';
          $('input[required]').each(function() {
            if ($(this).val() == '') {
              error = '必須項目が入力されていません';
              return false;
            }
          });

          if ($('input#passwd').val() != $('input#passwdChk').val()) {
            error = '確認用パスワードが違っています';
          }

          if (error != '') { alert(error); return false; }

          if (!confirm('パスワードを変更してよろしいですか')) { return false; }

          $.post('../ajax/passwd.php',
            {"target": "catalog", "action": "changePasswd", "data": {
            'account': $('input#account').val(),
            'nowPasswd': $('input#nowPasswd').val(),
            'passwd': $('input#passwd').val(),
            'passwdChk': $('input#passwdChk').val(),
          }
        },
        function(data) {
          if (data == 'success') {
            alert('パスワードを変更しました');
            location.href = '/admin/'
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
    </style>
  {/literal}
{/block}

{block 'main'}
  <table class="login form">
    <tr>
      <th>アカウント</th>
      <td><input type="text" name="account" id="account" placeholder="アカウント" required /></td>
    </tr>
    <tr>
      <th>現在のパスワード</th>
      <td><input type="password" name="nowPasswd" id="nowPasswd" placeholder="現在のパスワード" required /></td>
    </tr>
    <tr>
      <th>新しいパスワード</th>
      <td><input type="password" name="passwd" id="passwd" placeholder="新しいパスワード" required /></td>
    </tr>
    <tr>
      <th>新しいパスワード(確認)</th>
      <td><input type="password" name="passwdChk" id="passwdChk" placeholder="新しいパスワード(確認)" required /></td>
    </tr>
  </table>

  <button name="submit" class="passwd_change submit">パスワード変更</button>
{/block}