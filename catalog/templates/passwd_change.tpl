{extends file='include/layout.tpl'}

{block name='header'}
  {literal}
    <script language="JavaScript" type="text/javascript">
      $(function() {
      $('.passwd_change').click(function() {
          var error = '';
          $('input[required]').each(function() {
            if ($(this).val() == '') {
              error = '必須項目が入力されていません';
              return false;
            }
          });
          if (error != '') {
            alert(error);
            return false;
          }

          if (!confirm('パスワードを変更してよろしいですか')) { return false; }

          $.post('../ajax/passwd.php',
            {"target": "catalog", "action": "changePasswd", "data": {
            'account': $.trim($('input#account').val()),
            'nowPasswd': $.trim($('input#nowPasswd').val()),
            'passwd': $.trim($('input#passwd').val()),
            'passwdChk': $.trim($('input#passwdChk').val()),
          }
        },
        function(data) {
          if (data == 'success') {
            alert('パスワードを変更しました');
            location.href = '../'
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
      .login_form {
        width: 460px;
        border: 1px solid #AAA;
        margin: 16px auto;
        padding: 4px 16px;
        border-radius: 8px;
      }

      .login_form legend {
        padding: 0 4px;
      }

      .login_form dt {
        display: inline-block;
        /display: inline;
        /* for IE6 */
        /zoom: 1;
        /* for IE6 */
        width: 150px;
        margin: 4px 10px;
        vertical-align: middle;
        font-size: 14px;
      }

      .login_form dd {
        display: inline-block;
        /display: inline;
        /* for IE6 */
        /zoom: 1;
        /* for IE6 */
        width: 240px;
        margin: 4px 10px;
        vertical-align: middle;
        font-size: 14px;
      }

      .login_form dd input {
        width: 220px;
      }

      .login_form dd input:focus {
        background: #fffacd
      }

      button.passwd_change {
        display: block;
        position: relative;
        width: 200px;
        height: 23px;
        margin: 16px auto;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <fieldset class="login_form">
    <legend>パスワード変更</legend>
    <dl>
      <dt><label for="account">アカウント</label></dt>
      <dd><input type="text" name="account" id="account" placeholder="アカウント" required /></dd><br />
      <dt><label for="nowPasswd">現在のパスワード</label></dt>
      <dd><input type="password" name="nowPasswd" id="nowPasswd" placeholder="現在のパスワード" required /></dd>

      <dt><label for="passwd">新しいパスワード</label></dt>
      <dd><input type="password" name="passwd" id="passwd" placeholder="新しいパスワード" required /></dd>
      <dt><label for="passwdChk">新しいパスワード(確認)</label></dt>
      <dd><input type="password" name="passwdChk" id="passwdChk" placeholder="新しいパスワード(確認)" required /></dd>
    </dl>
  </fieldset>

  <button name="submit" class="passwd_change">パスワード変更</button>
{/block}