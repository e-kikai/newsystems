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
  <form class="login" method="post" action="/mypage/passwd_update_do.php">
    <input type="hidden" name="id" value="{$my_user_id}" />
    <input type="hidden" name="token" value="{$token}" />

    <div class="d-grid gap-2 col-6 mx-auto mt-3">
      <dl>
        <dt><label for="passwd" class="form-label">新しいパスワード<span class="required">(必須)</span></label></dt>
        <dd><input type="password" name="data[passwd]" id="passwd" class="form-control" placeholder="新しいログインパスワード"
            required /></dd>
        <dt><label for="passwd" class="form-label">新しいパスワード(確認)<span class="required">(必須)</span></label></dt>
        <dd><input type="password" name="passwd_02" id="passwd" class="form-control" placeholder="パスワード確認" required />
        </dd>
      </dl>

      <button type="submit" name="submit" class="submit btn btn-primary" value="login">
        <i class="fas fa-lock"></i> パスワードを変更する
      </button>
    </div>
  </form>
{/block}