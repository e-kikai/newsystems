{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>

  {literal}
    <script type="text/javascript">
      $(function() {
        /// フォーム入力の確認 ///
        $('form.login').submit(function() {
          if (!$('input#mail').val()) {
            alert('メールアドレス、パスワードを入力してください。');
            return false;
          }
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <form class="login" method="post" action="passwd_remember_do.php">
    <div class="d-grid gap-2 col-6 mx-auto mt-3">
      <dl>
        <dt><label for="mail" class="form-label">メールアドレス</label></dt>
        <dd><input type="email" name="mail" id="mail" class="form-control" placeholder="メールアドレスを入力してください" required /></dd>
      </dl>

      <div class="g-recaptcha" data-sitekey="6LfkPfkiAAAAACTK3yNXM34tTTTdIt5bAZaDQlv9"></div>

      <button type="submit" name="submit" class="submit btn btn-primary" value="login">
        <i class="fas fa-paper-plane"></i> パスワード再設定メール送信
      </button>
    </div>
  </form>

  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/mypage/login.php" class="btn btn-outline-secondary">
      <i class="fas fa-right-to-bracket"></i> ログインページ
    </a>
    <a href="/mypage/sign_up.php" class="btn btn-outline-secondary">
      <i class="fas fa-user-plus"></i> 入札に参加するには - 入札会ユーザ登録
    </a>
    <a href="/mypage/mail_resend.php" class="btn btn-outline-secondary">
      <i class="far fa-paper-plane"></i> 確認メーが届いていませんか？ - 確認メールの再送信
    </a>
  </div>
{/block}