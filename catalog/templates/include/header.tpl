{**
 * 共通ヘッダ部分
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/04/19
 *}
{* Google Analytics *}

{*
{include file="include/google_analytics.tpl"}
*}

{*
<script type="text/javascript" src="http://www.zenkiren.net/acc/catalog/acctag.js"></script>
*}

{literal}

  <script language="JavaScript" type="text/javascript">
    $(function() {
      //// textresizer ////
      var t = '.catalog td:not(.img), th, .genre_area li, .maker_area li,' +
        '.row_list a, .row_title, .info_area .info, input, textarea';
      $("#textsizer a").textresizer({
        // target: "table.form, table.form input, table.form textarea, table.form label, select",
        target: t,
        type: "fontSize",
        sizes: ["13px", "17px", "21px", "25px"],
        selectedIndex: 1
      }).click(function() { return false; });
    });
  </script>
  <style type="text/css">
    /*** textresizer ***/
    #textsizer {
      text-align: right;
      position: absolute;
      top: 40px;
      right: 0;
    }

    #textsizer p {
      display: inline;
      font-size: 17px;
    }

    ul.textresizer {
      list-style: none;
      display: inline;
      margin: 0px;
      padding: 0px;
    }

    ul.textresizer li {
      display: inline;
      margin: 0px;
      margin-right: 5px;
      padding: 0px;
    }

    ul.textresizer a {
      border: solid 1px #999;
      padding: 2px 3px;
      font-weight: bold;
      text-decoration: none;
      background: #FFF;
    }

    ul.textresizer a:hover {
      background: #e5e5e5;
      border: solid 1px #cccccc;
    }

    ul.textresizer .small-text {
      font-size: 13px;
    }

    ul.textresizer .medium-text {
      font-size: 17px;
    }

    ul.textresizer .large-text {
      font-size: 21px;
    }

    ul.textresizer .larger-text {
      font-size: 25px;
    }

    ul.textresizer a.textresizer-active {
      border: solid 1px #2B562B;
      background: #FFCA6F;
      color: #000000;
    }
  </style>
{/literal}
</head>

<body>

  {*
<a class='sample_bbs' href='http://0bbs.jp/ecatalog/' target='_blank'>電子カタログご意見BBS</a>
*}

  <div class="main_container">

    <header>
      <a href='' class='header_logo'>
        <img src='imgs/logo_catalog.png' alt='信頼と実績 全機連' />
      </a>

      <div class='discription'>機械のカタログをメーカー名・型式から検索できます</div>
      <div class="header_title">電子カタログ</div>

      <div class='sitemap_menu'>
        <a href='passwd_change.php'>パスワード変更</a>
        <a href='logout_do.php'>ログアウト</a>
        {*
      <a href='help.php?p=beginner_01'>初めての方へ</a>
      <a href='sitemap.php'>サイトマップ</a>
      <a href='contact.php'>お問い合わせ</a>
 *}
      </div>

      <div class='header_menu'></div>

      {*** textsizer ***}
      <div id="textsizer">
        <p>文字サイズ</p>
        <ul class="textresizer">
          <li><a href="#nogo" class="small-text" title="小">小</a></li>
          <li><a href="#nogo" class="medium-text" title="中">中</a></li>
          <li><a href="#nogo" class="large-text" title="大">大</a></li>
          <li><a href="#nogo" class="larger-text" title="特大">特大</a></li>
        </ul>
      </div>

    </header>

    {*** マイリスト***}
    <div class='header_mypage'>
      <div class="mylist_menu">
        <a class="mylist" href='mylist_catalog.php'>マイリスト</a>
        <ul>
          <li><a href="mylist_catalog.php">マイリスト（電子カタログ）</a></li>
        </ul>
      </div>
    </div>


    {*** パンくず ***}
    {if !isset($pankuzu) || $pankuzu !== false}
      <div class="pankuzu">
        <a href="./">{$_conf.site_name}</a> &gt;

        {if !empty($pankuzu)}
          {foreach from=$pankuzu key=k item=p name='pun'}
            <a href="{$k}">{$p}</a> &gt;
          {/foreach}
        {/if}

        {if !empty($pankuzuTitle)}
          <strong>{$pankuzuTitle}</strong>
        {elseif !empty($pageTitle)}
          <strong>{$pageTitle}</strong>
        {/if}
      </div>

      {if !empty($h1Title)}
        <h1>{$h1Title}</h1>
      {elseif !empty($pageTitle)}
        <h1>{$pageTitle}</h1>
      {/if}

      {if isset($pageDescription)}
        <div class="description">{$pageDescription}</div>
      {/if}
    {/if}

    {*** メッセージ枠 ***}
    {if isset($message)}
      <div class="message">
        {if is_array($message)}
          {foreach $message as $m}
            <div>{$m}</div>
          {/foreach}
        {else}
          <div>{$message}</div>
        {/if}
      </div>
    {/if}

    {*** エラーメッセージ枠 ***}
    {if isset($errorMes)}
      <div class="error_mes">
        {if is_array($errorMes)}
          {foreach $errorMes as $m}
            <div>{$m}</div>
          {/foreach}
        {else}
          <div>{$errorMes|escape|default:""|nl2br nofilter}</div>
        {/if}
      </div>
    {/if}

<div class="center_container">