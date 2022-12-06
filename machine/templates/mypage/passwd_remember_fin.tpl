{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="d-grid gap-2 col-8 mx-auto my-3">
    <h2>パスワード再設定を行うメールを送信しました。</h2>
    <p>
      メールアドレスにメールを送信しましたので、<br />
      メール本文の確認リンクをクリックして表示される変更フォームから、<br />
      パスワード変更を行ってください。<br /><br />
      今後とも、マシンライフ Web入札会をよろしくお願いいたします。
    </p>
  </div>

  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/mypage/sign_up.php" class="btn btn-outline-secondary">
      <i class="fas fa-user-plus"></i> 入札に参加するには - 入札会ユーザ登録
    </a>
    <a href="/mypage/passwd_remember.php" class="btn btn-outline-secondary">
      <i class="fas fa-clipboard-question"></i> パスワードを忘れましたか？ - パスワード再設定
    </a>
    <a href="/mypage/mail_resend.php" class="btn btn-outline-secondary">
      <i class="far fa-paper-plane"></i>
      確認メーが届いていませんか？ - 確認メールの再送信
    </a>
  </div>
{/block}