{extends file='include/layout.tpl'}

{block name='header'}
<link href="{$_conf.libjs_uri}/css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="{$_conf.libjs_uri}/login.js"></script>

{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

<div class="terms_title">
  電子カタログは現在、全機連会員にのみ公開されています。一般には公開されておりません<br />
  下記の規約に同意の上、ログインしてください
</div>
<div class="terms">
  ログインする会員（以下甲という）は、ログインした内容及び情報（以下秘密情報という）を
  全日本機械業連合会（以下乙という）の事前の書面による承諾なく
  第３者に対して開示または漏洩してはならないものとする。
  ただし、次の各号に該当する情報についてはこの限りではない。<br /><br />
  
  １：公知の情報<br />
  ２：乙から甲が開示を受けた後、甲の責によらないで公知となった情報<br />
  ３：開示について甲乙による事前の合意がある場合<br /><br />
  
  甲及び乙は秘密情報を本件業務の遂行のために必要な限りにおいて利用できるものとし、
  事前に相手方の書面による承諾を得ない限りは、本件業務遂行以外の目的には
  一切使用または利用してはならないものとする。<br /><br />
  
  甲が本契約に違反して秘密情報を外部に漏洩したり、外部に持ち出したりしたことで
  損害を被った場合には、乙は甲に対して損害賠償を請求し、かつ乙が
  適当と考える必要な措置をとる事ができるものとする。<br /><br />
  
  甲は乙から要求があった場合には、
  乙から開示・提供をうけた秘密情報を乙に返却するものとし、
  また乙の事前の承諾を得て作成した複製物を廃棄するものとする。<br /><br />
  
  甲及び乙は、あらかじめ相手方の書面による承諾がない限り、
  本契約の権利または義務の全部または一部を
  他に譲渡してはならないものとする。<br /><br />
  
  本条の規約は、本契約終了後も存続する。
</div>

<form class="login" method="post" action="login_do.php">
  <fieldset class="login_form">
    <legend>ログイン</legend>
    <dl>
      <dt><label for="account">アカウント</label></dt>
      <dd><input type="text" name="mail" id="account" placeholder="アカウントを入力してください" required /></dd><br />
      <dt><label for="passwd">パスワード</label></dt>
      <dd><input type="password" name="passwd" id="passwd" placeholder="ログインパスワード" required /></dd>
    </dl>
  </fieldset>
  
  <button type="submit" name="submit" class="login_submit" value="login">
    規約に同意してログイン
  </button>
</form>
{/block}
