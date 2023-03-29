{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}toppage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="help_contents">
    <h2>マシンライフ会員区分別利用サービスについて</h2>
    <p>
      マシンライフ事業は全日本機械業連合会（以下全機連）の会員様を対象にしたサービスで会員区分ごとに
      {*
    ご利用いただけるサービスが異なりますので、<br />
    会員区分の変更をご希望の場合は、下記リンク先の『会員区分変更届』をご利用下さい。<br />
    *}
      ご利用いただけるサービスが異なります。<br /><br />
      全機連の会員様であれば、自動的にC会員のサービスがご利用可能となっています。<br />
      尚、アカウント、パスワードがご不明な場合は、事務局へお問い合せ下さい。
    </p>

    <h2>会員区分と年会費及び参加可能事業</h2>
    <table class="list rand_table">
      <tr>
        <th class="rank">会員区分</th>
        <th class="price">年会費(税込)</th>
        <th>参加可能事業</th>
      </tr>
      <tr>
        <th class="rank">A会員</th>
        <td class="price">30,000円</td>
        <td>下記のマシンライフ事業全てに参加出来ます</td>
      </tr>
      <tr>
        <th class="rank">B会員</th>
        <td class="price">12,000円</td>
        <td>マシンライフ事業の内、下記1)の在庫情報発信以外の事業に参加出来ます</td>
      </tr>
      <tr>
        <th class="rank">C会員</th>
        <td class="price">無料</td>
        <td>
          下記マシンライフ事業には参加できません。<br />
          ただし、Web入札会の「入札」のみ参加出来ます
        </td>
      </tr>
    </table>

    <h2>マシンライフ事業の内容</h2>
    <ul>
      <ol>1) 中古機械在庫情報の配信</ol>
      <ol>2) カタログの電子化 (電子カタログの閲覧が出来ます)</ol>
      <ol>3) Web入札会の開催 (出品、入札の参加が出来ます)</ol>
      <ol>4) 営業支援情報（売れ筋情報等の見える化）の提供・・・今後システムを実装予定</ol>
    </ul>

    {*
  <h2>会員区分の変更について</h2>
  <p>
    会員区分変更をご希望の場合は下記『会員区分変更届』にご記入、ご捺印の上事務局へご提出下さい。<br /><br />
    <a href="{$_conf.media_dir}pdf/help_rank.pdf" style="padding-left:20px;background: url('/imgs/pdficon_small.png') no-repeat;">会員区分変更届(PDF)</a>
  </p>
  *}
  </div>
{/block}