{extends file='include/layout.tpl'}

{block name='header'}
<meta name="robots" content="noindex, nofollow" />

<link href="{$_conf.libjs_uri}/css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="{$_conf.libjs_uri}/login.js?1"></script>

{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
<form class="login" method="post" action="login_do.php">
  <fieldset class="login_form">
    <legend>ログイン</legend>
    <dl>
      <dt><label for="account">アカウント</label></dt>
      <dd><input type="text" name="mail" id="account" placeholder="アカウントを入力してください" required /></dd><br />
      <dt><label for="passwd">パスワード</label></dt>
      <dd><input type="password" name="passwd" id="passwd" placeholder="ログインパスワード" required /></dd>
    </dl>
    <label class="check"><input type="checkbox" name="check" /> ログイン状態を保持する</label>
  </fieldset>
  
  <button type="submit" name="submit" class="login_submit" value="login">ログイン</button>
</form>
{/block}
