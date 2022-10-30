{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}contact.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.cookie.js"></script>
  {literal}
    <script type="text/javascript">
      $(function() {});
    </script>
    <style type="text/css">
      tr.header th {
        background: #EDFDFF;
        font-weight: bold;
        text-align: center;
        width: 220px;
      }

      tr.header td {
        background: #EDFDFF;
        font-weight: bold;
        text-align: center;
        width: 560px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  {include "include/bid_timer.tpl"}
  <table class='contact'>
    <tr class='header'>
      <th>ご質問</th>
      <td>回答</td>
    </tr>

    <tr class=''>
      <th>Web入札会とは？</th>
      <td>
        全日本機械業連合会が主催する、中古機械・工具等の入札会です。<br />
        全国の信頼と実績を持つ全日本機械業連合会会員が、中古機械情報サイト「マシンライフ」上で実施するもので、
        全国の中古機械ネットワークを駆使した、業界初のWeb入札会です。
      </td>
    </tr>

    <tr class=''>
      <th>Web入札会の日程は？</th>
      <td>
        中古機械情報サイト「マシンライフ」で年間日程をお知らせしています。<br /><br />

        <a href="http://www.zenkiren.net/">中古機械情報サイト マシンライフは、こちら</a>
      </td>
    </tr>

    <tr class=''>
      <th>入札するには？</th>
      <td>
        入札は全日本機械業連合会会員を通じての参加となります。<br />
        会員以外の方が、直接、入札することはできません。<br />
        お取引のある会員へご相談下さい。<br />
        会員とお取引がない方は、「入札資格会員一覧」からお探し頂き、ご相談ください。<br /><br />

        <a href="bid_company_list.php?o={$bidOpenId}">入札資格会員一覧は、こちら</a>
      </td>
    </tr>

    <tr class=''>
      <th>出品商品を探すには？</th>
      <td>
        マシンライフの検索リストから出品商品を探すことができます。<br />
        「ジャンル別」「出品地域別」から検索ができます。<br />
        出品商品リストはWeb上から印刷することできます。
      </td>
    </tr>

    <tr class=''>
      <th>出品商品を確認するには？</th>
      <td>
        下見期間中であればいつでもご覧いただけます。<br />
        依頼された会員とご相談下さい。<br />
        出品商品は、置き場有姿のままとしますので、必ずご覧いただき作動等のご確認をお願いします。
      </td>
    </tr>

    <tr class=''>
      <th>試運転は可能ですか？</th>
      <td>
        機械の状態で、可能でない場合がありますので、依頼された会員とご相談下さい。
      </td>
    </tr>

    <tr class=''>
      <th>取扱説明書はありますが？</th>
      <td>
        取扱説明書等はない場合がほとんどですので、ご了承下さい。
      </td>
    </tr>

    <tr class=''>
      <th>入札手順は？</th>
      <td>
        「出品商品を確認する」⇒「入札価格を決める」⇒「会員へ入札を依頼する」の手順でお願いします。
      </td>
    </tr>

    <tr class=''>
      <th>最低入札金額とは？</th>
      <td>
        最低入札金額とは、商品に表示された価格です。<br />
        入札ではそれ以上の金額で入札を依頼して下さい。
      </td>
    </tr>
    <tr class=''>
      <th>落札金額に消費税は含まれますか？</th>
      <td>
        落札者には落札金額に対して別途消費税を加算させていただきます。
      </td>
    </tr>


    <tr class=''>
      <th>入札額の目安は？</th>
      <td>
        目安は特にありません。
      </td>
    </tr>

    <tr class=''>
      <th>保証金は必要ですか？</th>
      <td>
        必要な場合があります。<br />
        入札を依頼された会員とご相談下さい。
      </td>
    </tr>

    <tr class=''>
      <th>キャンセルは出来ますか？</th>
      <td>
        落札後のキャンセルは一切できません。十分検討して入札を依頼して下さい。
      </td>
    </tr>

    <tr class=''>
      <th>落札の結果はいつわかりますか？</th>
      <td>
        入札締切日の午後には、依頼された会員より連絡があります。
      </td>
    </tr>

    <tr class=''>
      <th>商品の引取方法は？</th>
      <td>
        下見時に予め搬出手順を決めておいて下さい。
      </td>
    </tr>

    <tr class=''>
      <th>商品の引取はいつでもよい？</th>
      <td>
        定められた期間内に引取をして下さい。<br />
        依頼された会員の立ち会いが必要となる場合があります。
      </td>
    </tr>

    <tr class=''>
      <th>その他お問い合わせ</th>
      <td>
        お問い合わせ先 全機連マシンライフ委員会 事務局<br />
        TEL : 06-6747-7521<br />
        Mail : <a href="contact.php">お問い合わせフォーム</a>
      </td>
    </tr>
  </table>

  <table class='contact'>
    <tr class='header'>
      <th>ご質問</th>
      <td>回答</td>
    </tr>

    <tr class=''>
      <th>輸入に関するお願い</th>
      <td>
        落札された商品を輸入等する場合は、「外国為替及び外国貿易法」等の輸出関連法規の定めに従い、
        必要な手続きをお願いいたします。
      </td>
    </tr>
  </table>
{/block}