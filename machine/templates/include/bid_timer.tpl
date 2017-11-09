<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}bid_batch.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}bid_mylist.css" rel="stylesheet" type="text/css" />

{*
<div class="bid_timer">
  {if preg_match('/(admin|system)/', $smarty.server.PHP_SELF)}
    <input type="hidden" class="end_time" value="{$bidOpen.bid_end_date|strtotime}" />
    <input type="hidden" class="now_time" value="{time()}" />
  {else}
    <input type="hidden" class="end_time" value="{$bidOpen.user_bid_date|strtotime}" />
    <input type="hidden" class="now_time" value="{time()}" />
  {/if}

  {if $bidOpen.status == 'bid'}<span class="times">残り時間計算中</span>
  {else}{BidOpen::statusLabel($bidOpen.status)}
  {/if}
</div>
*}

<div class="bid_head">

{if !empty($machine)}
{*
<p class="contents">
  お問い合せフォーム、TEL、FAXより、出品会社へお問い合せください。
</p>
*}

{*
<div class='contact_area'>
  {if !empty($company.contact_mail)}
    <a class="contact_link" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank"><img src='./imgs/contact_button.png' /></a>
  {/if}
  {if !empty($company.contact_tel)}<div class='tel'>TEL : {$company.contact_tel}</div>{/if}
  {if !empty($company.contact_fax)}<div class='fax'>FAX : {$company.contact_fax}</div>{/if}
</div>
*}
{/if}

<div class="header_preview_date">
  下見期間 :
  {$bidOpen.preview_start_date|date_format:'%Y/%m/%d'} 〜
  {$bidOpen.preview_end_date|date_format:'%m/%d'}<br />
  入札締切 : {$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}
</div>

<div class="head_search_no">
  <form method="GET" id="company_list_form" action="bid_list.php">
    出品番号でさがす
    <input type="hidden" name="o" value="{$bidOpenId}" />
    <input type="text" class="m number" name="no" value="" placeholder="出品番号" />
    <button type="submit" class="company_list_submit">検索</button>
  </form>
</div>

<input type="hidden" class="bid_open_id" value="{$bidOpenId}" />

{*
<a class="mylist_link" href="bid_list.php?o={$bidOpenId}&mylist=1">
  お気に入り({if !empty($smarty.session.bid_mylist)}{count($smarty.session.bid_mylist)}{else}0{/if})
</a>
*}

<a class="mylist_link" href="contact.php?batch={$bidOpenId}">
  一括問い合わせ({if !empty($smarty.session.bid_batch)}{count($smarty.session.bid_batch)}{else}0{/if})
</a>

<div class="bid_help_area" style="display:none;">
  <div class="bid_arrow_00">中古機械をチェック</div>
  <div class="bid_01">全機連会員とお取引のある方</div>
  <div class="bid_arrow_01">全機連会員に直接お問い合せ</div>

  <div class="bid_sepa"></div>

  <p class="bid_01_contents">
    現在お取引されている全機連会員の方に、<br />
    入札締切日時までに、<br />
    入札のご依頼を行って下さい。
  </p>
  <div class="bid_02">全機連会員とお取引のない方</div>
  <div class="bid_arrow_02_1">お近くの全機連会員にお問い合せ</div>
  <div class="bid_arrow_02_2">出品会社にお問い合せ</div>
  <p class="bid_02_contents">
    「全機連会員一覧」より、<br />
    最寄りの全機連会員を探していただき、<br />
    入札締切日時までに、<br />
    入札のご依頼を行って下さい。
  </p>

  <p class="bid_03_contents">
    商品詳細ページの<br />
    「商品詳細についてのお問い合せ」より、<br />
    入札締切日時までに、<br />
    入札のご依頼を行って下さい。
  </p>
  <a href="bid_company_list.php?o={$bidOpenId}&m={$machineId}" class="company_list_button">全機連会員一覧</a>
</div>

{*
<div class="preuser_form_area" style="display:none;">
  <p class="preuser_01">
    マシンライフWeb入札会をご利用下さいましてありがとうございます。<br />
    マイリストをご利用される前に、メールアドレス登録をお願いいたします。<br />
    登録されたメールアドレスには、今後のWeb入札会のご案内等をお送りいたします。
  </p>

  <input type="hidden" class="preuser_bid_machine_id" value="" />
  <label>メールアドレス<span class="require">(必須)</span><input class="mail" value="" /></label>
  <label>会社名、氏名<input class="user_name" value="" /></label>

  <div class="privacy">
    <p>
      個人情報の利用目的<br />
      ・ 本件に関してご提供いただいた個人情報は本件の実施のために利用させて頂きます。<br />
      ・ ご登録いただいたお客様の情報は、全日本機械業連合会にて個人情報として厳重に管理いたします。<br />
      ・ ご記入された内容についての照会、変更または削除については問合せ窓口までご連絡下さい。<br />
      なおその際にご本人である旨の確認をさせていただく場合がありますのでご了承ください。<br />
      ・ なお、全日本機械業連合会による利用（お客様に対するお知らせの発信を含みます）にあたり<br />、
      お客様の情報に関する機密保持契約を締結したうえで、必要な情報を委託先に預託することがあります。<br /><br />

      ご入力いただく前に、全日本機械業連合会のプライバシーポリシーをご一読下さい。<br />
      [お問い合わせ窓口]<br />
      本件に関するお問い合わせは、<a href="contact.php" target="_blank">お問い合せ</a>からお願い致します。
    </p>
  </div>
  <label class="checke_area"><input type="checkbox" class="privacy_check" checked="checked">プライバシーポリシーに同意する</label>
  <button class='preuser_submit'>メールアドレスを登録してマイリストを使う</button>
</div>
*}
</div>
