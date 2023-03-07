{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}help.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block name='main'}
  <div class="bid_help_area">

    <h2 id="1-web-%E5%85%A5%E6%9C%AD%E4%BC%9A%E3%81%B8%E3%81%AE%E5%8F%82%E5%8A%A0">1. Web 入札会への参加</h2>
    <p><em>マシンライフのWeb入札会にご参加ありがとうございます。</em></p>
    <h3 id="11-%E5%85%A5%E6%9C%AD%E3%83%A6%E3%83%BC%E3%82%B6%E7%99%BB%E9%8C%B2">1.1. 入札ユーザ登録</h3>
    <p>Web入札会の入札を行うには、まず <strong>入札ユーザ登録</strong> を行います。<br />
      (初回のみ。次回以降は→ 「1.2. マイページ ログイン」をご覧ください)</p>
    <div style="color:darkorange;font-weight:bold;">(( 手順 ))</div>
    <ol>
      <li>マシンライフのトップページから、 <a href="bid_door.php?o={$bidOpenId}">Web入札会のトップページ</a> アクセスしてください。</li>
      <li>Web入札会ページにある <kbd>Web入札会 マイページにログイン</kbd> をクリックしてください。<br />
        <img src="./imgs/bid_help/uimg_01_02.png" alt="画像">
      </li>
      <li>マイページ - ログインフォームの下にある <kbd>入札に参加するには - 入札会ユーザ登録</kbd> をクリックしてください。<br />
        <img src="./imgs/bid_help/uimg_01_03.png" alt="画像">
      </li>
      <li>入札会ユーザ登録フォームが表示されます。<br />
        メールアドレス_ 、 <em>パスワード</em> 、 氏名、会社名、連絡先などを入力して<br />
        <kbd>ユーザ登録する</kbd> をクリックしてください。<br />
        <img src="./imgs/bid_help/uimg_01_09.png" alt="画像">
      </li>
      <li>登録メールアドレスに、 <strong>登録確認メール</strong> が送信されますので、<br />
        メール内の <em>メールアドレスの確認</em> リンクをクリックします。<br />
        <img src="./imgs/bid_help/uimg_01_08_02.png" alt="画像">
      </li>
      <li>ログインフォームに戻ってきて <strong>ユーザ認証が完了しました。</strong> と表示されれば、登録完了です。<br />
        <img src="./imgs/bid_help/uimg_01_07.png" alt="画像">
      </li>
    </ol>

    <h4
      id="%E2%97%86-%E7%A2%BA%E8%AA%8D%E3%83%A1%E3%83%BC%E3%83%AB%E3%81%8C%E5%B1%8A%E3%81%8B%E3%81%AA%E3%81%84%E7%B4%9B%E5%A4%B1%E3%81%97%E3%81%9F%E5%A0%B4%E5%90%88%E3%81%AF---omit-in-toc">
      ◆ 確認メールが届かない、紛失した場合は？
      <!-- omit in toc -->
    </h4>
    <p>マイページ - ログインフォームの下にある <kbd>確認メールが届いていませんか？ - 確認メールの再送信</kbd> をクリックしてください。
    </p>
    <p><img src="./imgs/bid_help/uimg_01_03.png" alt="画像"></p>
    <p>フォームに <strong>登録したメールアドレスを入力</strong> して <kbd>確認メール再送信</kbd>をクリックしてください。</p>
    <p><img src="./imgs/bid_help/uimg_01_06.png" alt="画像"></p>
    <p>確認メール再送信されます。</p>

    <h3 id="12-%E3%83%9E%E3%82%A4%E3%83%9A%E3%83%BC%E3%82%B8-%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3">1.2. マイページ ログイン</h3>
    <p>マシンライフ Web入札会ページにある <kbd>Web入札会 マイページにログイン</kbd> をクリックしてください。</p>
    <p><img src="./imgs/bid_help/uimg_01_02.png" alt="画像"></p>
    <p>登録したメールアドレスとパスワードを入力して、 <kbd>ログイン</kbd> をクリックしてください。</p>
    <p><img src="./imgs/bid_help/uimg_01_03_02.png" alt="画像"></p>
    <p>ログインに成功すると、 <strong>マイページ</strong> が表示されます。</p>
    <p><img src="./imgs/bid_help/uimg_01_01.png" alt="画像"></p>
    <p>
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>についての
      詳しい機能については、→ 「2. マイページ」以降のページをご覧ください。
    </p>
    <h3 id="13-%E3%83%91%E3%82%B9%E3%83%AF%E3%83%BC%E3%83%89%E3%82%92%E5%BF%98%E3%82%8C%E3%81%9F%E5%A0%B4%E5%90%88">1.3.
      パスワードを忘れた場合</h3>
    <p>Web入札会に参加するためのパスワードを忘れてしまった場合、<br />
      <kbd>パスワードを忘れましたか?- パスワード再設定</kbd>から、パスワードの再発行が行なえます。
    </p>
    <div style="color:darkorange;font-weight:bold;">(( 手順 ))</div>
    <ol>
      <li>マイページ - ログインフォームの下にある <kbd>パスワードを忘れましたか? - パスワード再設定</kbd> をクリックしてください。<br />
        <img src="./imgs/bid_help/uimg_01_03.png" alt="画像">
      </li>
      <li>フォームに <strong>登録したメールアドレスを入力</strong> して <kbd>送信する</kbd>をクリックしてください。<br />
        <img src="./imgs/bid_help/uimg_01_04.png" alt="画像">
      </li>
      <li>登録メールアドレスに、 <strong>パスワード変更方法を記述したメール</strong> が送信されますので、<br />
        メール内の <em>パスワード変更</em> をクリックすると、 <strong>パスワードの変更フォーム</strong> へリンクします。</li>
      <li>フォームに新しいパスワードを入力して <kbd>パスワードを変更する</kbd>をクリックしてください。<br />
        <img src="./imgs/bid_help/uimg_05_03.png" alt="画像">
      </li>
    </ol>

    <h2 id="2-%E3%83%9E%E3%82%A4%E3%83%9A%E3%83%BC%E3%82%B8">2. マイページ</h2>
    <p>
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>では、
      各入札会の入札、ウォッチリストの管理などを行えます。
    </p>
    <p><img src="./imgs/bid_help/uimg_01_01.png" alt="画像"></p>
    <h3 id="21-%E7%8F%BE%E5%9C%A8%E9%96%8B%E5%82%AC%E4%B8%AD%E3%81%AE%E5%85%A5%E6%9C%AD%E4%BC%9A">2.1. 現在開催中の入札会</h3>
    <p>現在開催中の入札会について、 <em>開催期間の詳細情報</em> と、 <em>各機能のメニュー</em> が表示されます。</p>
    <h4 id="1-web%E5%85%A5%E6%9C%AD%E4%BC%9A%E3%83%88%E3%83%83%E3%83%97%E3%83%9A%E3%83%BC%E3%82%B8">1) Web入札会トップページ</h4>
    <p>
      <a href="bid_door.php?o={$bidOpenId}">Web入札会のトップページ</a>です。
    </p>
    <p><img src="./imgs/bid_help/uimg_02_06.png" alt="画像"></p>

    <h4 id="2-%E5%87%BA%E5%93%81%E5%95%86%E5%93%81%E3%83%AA%E3%82%B9%E3%83%88---%E5%8D%B0%E5%88%B7pdf">2) 出品商品リスト - 印刷PDF
    </h4>
    <p>この入札会に出品されている商品の <strong>印刷用PDFリスト</strong> です。</p>
    <p><img src="./imgs/bid_help/uimg_02_01.png" alt="画像"></p>
    <p>Web入札会では、 <em>紙のリストの配布を行っておりません</em> ので、<br />
      代わりに本PDFをダウンロードしていただいて、閲覧および印刷を行ってください。</p>
    <h4 id="3-%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81%E3%83%AA%E3%82%B9%E3%83%88">3) ウォッチリスト</h4>
    <p>現在までに、ウォッチリストに登録した商品の一覧を表示します。</p>
    <p><img src="./imgs/bid_help/uimg_04_01.png" alt="画像"></p>
    <p>ウォッチリストについての機能の詳細は、 → 「4. ウォッチリストについて」をご覧ください。</p>

    <h4 id="4-%E5%85%A5%E6%9C%AD%E4%B8%80%E8%A6%A7-%E8%90%BD%E6%9C%AD%E4%B8%80%E8%A6%A7">4) 入札一覧 (落札一覧)</h4>
    <p>現在までに行った、入札の一覧を表示します。<br />
      下見・入札期間中は、ここで <strong>入札の取消</strong> を行えます。</p>
    <p><img src="./imgs/bid_help/uimg_03_01.png" alt="画像"></p>
    <p>入札を行う方法についての詳細は、 → 「3. 入札を行う」をご覧ください。</p>
    <hr>
    <p>また、入札期間終了後は <strong>落札一覧</strong> となり、ここで出品会社と <strong>落札した商品の取引</strong> を行えます。</p>
    <p><img src="./imgs/bid_help/uimg_05_05.png" alt="画像"></p>
    <p>出品会社と落札した商品の取引を方法についての詳細は、<br />
      → 「5. 商品を落札した場合は → 取引を行う」をご覧ください。</p>
    <h3 id="22-%E9%81%8E%E5%8E%BB%E3%81%AE%E5%85%A5%E6%9C%AD%E4%BC%9A%E4%B8%80%E8%A6%A7">2.2. 過去の入札会一覧</h3>
    <p>過去に開催された入札会の一覧を表示します。<br />
      ここから、各入札会の結果を閲覧することができます。</p>
    <p><img src="./imgs/bid_help/uimg_05_01.png" alt="画像"></p>

    <h3 id="23-%E3%83%A6%E3%83%BC%E3%82%B6%E6%83%85%E5%A0%B1%E5%A4%89%E6%9B%B4">2.3. ユーザ情報変更</h3>
    <p>登録したユーザ情報を変更します。</p>
    <p>フォームに変更内容を入力して <kbd>ユーザ情報を変更する</kbd>をクリックしてください。</p>
    <p><img src="./imgs/bid_help/uimg_02_05.png" alt="画像"></p>
    <h3 id="24-%E3%83%91%E3%82%B9%E3%83%AF%E3%83%BC%E3%83%89%E5%A4%89%E6%9B%B4">2.4. パスワード変更</h3>
    <p>
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>のログインパスワードを変更します。
    </p>
    <p>フォームに新しいパスワードを入力して <kbd>パスワードを変更する</kbd>をクリックしてください。</p>
    <p><img src="./imgs/bid_help/uimg_05_03.png" alt="画像"></p>
    <h3 id="25-%E3%83%AD%E3%82%B0%E3%82%A2%E3%82%A6%E3%83%88">2.5. ログアウト</h3>
    <p>
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>からログアウトします。
    </p>

    <h2 id="3-%E5%85%A5%E6%9C%AD%E3%82%92%E8%A1%8C%E3%81%86">3. 入札を行う</h2>
    <h3 id="31-%E5%95%86%E5%93%81%E3%82%92%E3%81%95%E3%81%8C%E3%81%99">3.1. 商品をさがす</h3>
    <p>
      <a href="./" target="_blank">マシンライフのトップページ</a>、もしくは
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>から
      <a href="bid_door.php?o={$bidOpenId}">Web入札会のトップページ</a> へリンクします。
    </p>
    <p><img src="./imgs/bid_help/uimg_03_02.png" alt="画像"></p>
    <p>Web入札会では、以下のような方法で商品をさがすことができます。</p>
    <ul>
      <li>出品番号・キーワードでさがす … 商品名や出品番号から直接商品を検索します。</li>
      <li>地域会場とジャンルからさがす … お住いの地域とおさがしの商品ジャンルから商品を検索します。</li>
      <li>人気商品 … ここまででよく見られている商品リストです。</li>
    </ul>

    <p>
      商品のさがし方についてくわしくは、
      <a href="bid_help_01.php?o={$bidOpenId}"><i class="fas fa-circle-info"></i> Web入札会 商品のさがし方</a> をご覧ください。
    </p>

    <h3 id="32-%E8%A9%B3%E7%B4%B0%E3%83%9A%E3%83%BC%E3%82%B8-%E2%86%92-%E5%85%A5%E6%9C%AD%E3%81%AE%E6%96%B9%E6%B3%95">3.2.
      詳細ページ → 入札の方法</h3>
    <p>商品の詳細情報、画像を表示します。 <strong>入札</strong> もこちらで行います。</p>
    <p><img src="./imgs/bid_help/uimg_03_03.png" alt="画像"></p>
    <h4 id="1-%E5%95%86%E5%93%81%E6%83%85%E5%A0%B1---omit-in-toc">1) 商品情報
      <!-- omit in toc -->
    </h4>
    <p>商品の出品番号、最低入札金額、商品名、メーカー、型式や、詳細仕様など、<br />
      出品会社の情報や在庫場所、商品画像を閲覧できます。</p>
    <p>入札の前に、特に送料負担や引取留意事項などをよくご確認よろしくお願いいたします。</p>
    <h4 id="2-%E5%95%8F%E3%81%84%E5%90%88%E3%82%8F%E3%81%9B---omit-in-toc">2) 問い合わせ
      <!-- omit in toc -->
    </h4>
    <p>出品会社へ問い合わせを行えます。</p>
    <p><kbd>フォームから問い合わせ</kbd> から、メールでのお問い合わせが、<br />
      <kbd>電話で問い合わせ</kbd> から、お問い合わせ電話番号を表示することができます。
    </p>
    <p>入札する商品のより詳しい仕様などのお問い合わせが行なえます。</p>
    <h4 id="3-%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81%E3%83%AA%E3%82%B9%E3%83%88---omit-in-toc">3) ウォッチリスト
      <!-- omit in toc -->
    </h4>
    <p><kbd>ウォッチリストに登録</kbd> をクリックすると、ウォッチリストに登録できます。(下見・入札期間のみ)<br />
      ウォッチリストについてくわしくは、 → 「4. ウォッチリストについて」をご覧ください。</p>
    <h3 id="33-%E5%85%A5%E6%9C%AD">3.3. 入札</h3>
    <p>詳細ページの <strong>入札フォーム</strong> より、入札を行います。</p>
    <p><img src="./imgs/bid_help/uimg_03_04.png" alt="画像"></p>
    <p>入札フォームに <strong>入札金額</strong> を入力して、<kbd>規約に同意して入札する</kbd> をクリックしてください。(下見・入札期間のみ)</p>
    <ul>
      <li>
        入札フォームの表示および入札は、 <strong>マイページにログイン</strong> が必要です。<br />
        入札への参加、<a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>については
        → 「1. Web 入札会への参加」をご覧ください。
      </li>
      <li>入札金額は、最低入札金額以上、 <em>100円単位</em> で行えます。</li>
      <li>備考欄は、出品会社にも公開されません。入札に関するメモなどにご利用ください。</li>
    </ul>
    <div style="color:red;font-weight:bold;">(( 入札に関する注意事項 ))</div>
    <ul>
      <li>入札は、下見・入札期間内であれば、 取消・再入札を行うことができます。</li>
      <li>入札の結果は、 <strong>入札締め切り後に確定・公開</strong> されます。<br />
        (入札締切後は、入札の取り消しを行うことはできません)</li>
      <li>同額の入札があった場合は、 <strong>同額入札から落札者をシステムで自動的に決定</strong> いたします。<br />
        予めご了承ください。</li>
      <li>落札された場合は、各自 <strong>出品会社と直接取引</strong> を行ってください。<br />
        取引のくわしい方法は、→ 「5. 商品を落札した場合は → 取引を行う」をご覧ください。</li>
    </ul>
    <p>
      皆様の入札へのご参加、お待ちしております。<br /><br />

      <strong>
        ※ 入札には締切時間がありますので、時間の余裕を持って入札を依頼することをお勧めいたします。
      </strong>
    </p>

    <h3 id="34-%E3%83%9E%E3%82%A4%E3%83%9A%E3%83%BC%E3%82%B8-%E5%85%A5%E6%9C%AD%E4%B8%80%E8%A6%A7">3.4. マイページ 入札一覧</h3>
    <p>
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>の
      <em>入札一覧</em> をクリックしてください。
    </p>
    <p>現在までに行った入札の履歴を表示します。<br />
      入札の取り消しもこちらから行います。</p>
    <p><img src="./imgs/bid_help/uimg_03_01.png" alt="画像"></p>
    <h3 id="35-%E5%85%A5%E6%9C%AD%E3%81%AE%E5%8F%96%E3%82%8A%E6%B6%88%E3%81%97">3.5. 入札の取り消し</h3>
    <p>マイページの入札一覧で、取り消したい入札の <kbd>取消</kbd> をクリックし、確認表示で <kbd>OK</kbd> をクリックします。<br />
      (下見・入札期間のみ)</p>
    <ul>
      <li>入札は、 <strong>下見・入札期間内</strong> であれば、 <strong>何度でも入札および取消を行うことができます。</strong></li>
      <li>また、同じ商品に対して、複数回入札を行うことも可能です。<br />
        (例えば、複数の担当者が同じアカウントを使って入札を行う場合など)<br />
        その場合は、 <em>一番高い金額の入札のみが有効</em> になります。</li>
    </ul>

    <h2 id="4-%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81%E3%83%AA%E3%82%B9%E3%83%88%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6">4.
      ウォッチリストについて</h2>
    <p>ウォッチリストとは、気になる商品を登録しておいて、後でまとめて一覧表示する機能です。<br />
      <strong>商品の比較検討</strong> を行うときなどに利用することができます。
    </p>
    <p>
      <span style="color:red;">※</span> ウォッチリストの登録、ご利用には、
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>
      へのログインが必要です。<br />
      入札への参加、<a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>
      については → 「1. Web 入札会への参加」をご覧ください。
    </p>
    <h3
      id="41-%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81%E3%83%AA%E3%82%B9%E3%83%88%E3%81%AB%E7%99%BB%E9%8C%B2%E3%81%99%E3%82%8B">
      4.1. ウォッチリストに登録する</h3>
    <p>各商品の詳細ページにある、 <kbd>★ ウォッチリストに登録</kbd> をクリックすると、登録が行なえます。<br />
      (下見・入札期間のみ)</p>
    <p><img src="./imgs/bid_help/uimg_04_02.png" alt="画像"></p>
    <h3
      id="42-%E3%83%9E%E3%82%A4%E3%83%9A%E3%83%BC%E3%82%B8-%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81%E3%83%AA%E3%82%B9%E3%83%88%E3%82%92%E8%A1%A8%E7%A4%BA">
      4.2. マイページ ウォッチリストを表示</h3>
    <p>
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>の
      <em>ウォッチリスト</em> をクリックしてください。
    </p>
    <p><img src="./imgs/bid_help/uimg_04_01.png" alt="画像"></p>

    <h3 id="43-%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81%E3%83%AA%E3%82%B9%E3%83%88%E8%A7%A3%E9%99%A4">4.3. ウォッチリスト解除</h3>
    <p>各商品の詳細ページにある、 <kbd>★ ウォッチリスト登録済 (解除する)</kbd> をクリックしてください。</p>
    <p><img src="./imgs/bid_help/uimg_04_03.png" alt="画像"></p>
    <p>
      もしくは、<a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>の
      ウォッチリスト(→ 「4.2. マイページ ウォッチリスト一覧」)で、<br />
      ウォッチリストの登録を解除したい商品の <kbd>解除</kbd> をクリックすると、登録を解除できます。
    </p>
    <p>(いずれも下見・入札期間のみ)</p>
    <p><img src="./imgs/bid_help/uimg_04_01.png" alt="画像"></p>
    <hr>
    <p>下見・入札期間内であれば、<strong>いつでも何回でも</strong> ウォッチリスト登録・解除は行なえますので、<br />
      ちょっと気になる商品は、どんどんウォッチリストに登録してみてください。</p>

    <h2
      id="5-%E5%95%86%E5%93%81%E3%82%92%E8%90%BD%E6%9C%AD%E3%81%97%E3%81%9F%E5%A0%B4%E5%90%88%E3%81%AF-%E2%86%92-%E5%8F%96%E5%BC%95%E3%82%92%E8%A1%8C%E3%81%86">
      5. 商品を落札した場合は → 取引を行う</h2>
    <p>入札期間終了後に行える処理について説明します。</p>
    <p><img src="./imgs/bid_help/uimg_05_04.png" alt="画像"></p>
    <h3 id="51-%E8%90%BD%E6%9C%AD%E7%B5%90%E6%9E%9C%E3%82%92%E8%A6%8B%E3%82%8B">5.1. 落札結果を見る</h3>
    <p>自分が入札した商品の落札結果は、マイページの <em>入札一覧(落札一覧)</em> をクリックしてください。</p>
    <p>それぞれ入札についての <em>入札件数</em> 、 <em>落札金額</em> と <strong>落札の可否</strong> を確認することができます。</p>
    <p><img src="./imgs/bid_help/uimg_05_05.png" alt="画像"></p>
    <p>落札ができた商品について、 <kdb>取引</kbd> より、 <strong>出品会社との取引</strong> が行なえます。</p>
    <p>くわしくは、→ 「5.2. 落札した商品の出品会社と取引を行う」をご覧ください。</p>
    <h3
      id="52-%E8%90%BD%E6%9C%AD%E3%81%97%E3%81%9F%E5%95%86%E5%93%81%E3%81%AE%E5%87%BA%E5%93%81%E4%BC%9A%E7%A4%BE%E3%81%A8%E5%8F%96%E5%BC%95%E3%82%92%E8%A1%8C%E3%81%86">
      5.2. 落札した商品の出品会社と取引を行う</h3>
    <p>「入札一覧(落札一覧)」の各落札商品の <kbd>取引</kbd> をクリックすると、 以下のようなフォームが表示されます。</p>
    <p>落札した商品の引取方法や入金方法などは、落札会社とこのフォームでやりとりを行います。</p>
    <p>左側に <strong>落札された商品情報</strong> 、 と <strong>出品会社情報</strong> が、<br />
      右側に、実際に取引を行う <strong>取引フォーム</strong> が表示されます。</p>
    <p><img src="./imgs/bid_help/uimg_05_06.png" alt="画像"></p>
    <div style="color:darkorange;font-weight:bold;">(( 取引の方法 ))</div>
    <ol>
      <li>右上のフォームに内容を入力して <kbd>投稿する</kbd> をクリックすると、書き込むことができます。</li>
      <li>書き込まれた内容は、右下に時系列順(新しいものが上)で表示されます。<br />
        また、書き込まれた内容は、 <strong>出品会社にメールで通知</strong> されます。</li>
      <li>出品会社から返信があった場合も、右下に返信が表示され、<br />
        また、 <strong>返信の内容が登録したメールアドレスに通知</strong> されます。</li>
    </ol>
    <p>これを繰り返して、出品会社と取引を行ってください。</p>
    <div style="color:red;font-weight:bold;">(( 取引に関する注意事項 - 必ずお読みください ))</div>
    <ul>
      <li>取引開始は、 <strong>下見・入札期間終了後1週間以内</strong> にお願いいたします。</li>
      <li>落札金額には、送料・梱包費・諸経費などが含まれていない場合があります。<br />
        ご入金の前に、 <strong>発送方法、送料、梱包などの確認</strong> は必ず行ってください。</li>
      <li>入金確認後に商品の発送します。商品到着後、 <strong>受取確認・評価</strong> を行ってください。</li>
    </ul>

    <h3 id="53-%E5%85%A8%E4%BD%93%E3%81%AE%E8%90%BD%E6%9C%AD%E7%B5%90%E6%9E%9C%E3%82%92%E8%A6%8B%E3%82%8B">5.3. 全体の落札結果を見る
    </h3>
    <p>
      入札会のすべての落札結果を確認したい場合は、<br />
      <a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>の
      <em>全体の落札結果一覧</em> をクリックしてください。
    </p>
    <p><img src="./imgs/bid_help/uimg_05_04.png" alt="画像"></p>
    <p>入札会のすべての出品商品の結果として、 <em>入札件数</em> と <em>落札金額</em> を確認することができます。</p>
    <p><img src="./imgs/bid_help/uimg_05_02.png" alt="画像"></p>
    <p>
      また、<a href="./mypage" target="_blank"><i class="fas fa-right-to-bracket"></i> マイページ</a>の
      <em>全体の落札結果一覧 - 印刷CSV</em> をクリックすると、<br />
      この内容をExcelで加工・印刷することができる <em>CSVファイル</em> としてダウンロードすることができます。
    </p>

  </div>

  <hr />
  <div class="d-grid gap-2 col-6 mx-auto my-3">

    <a href="/mypage/login.php" class="btn btn-outline-secondary">
      <i class="fas fa-right-to-bracket"></i> マイページ - ログイン
    </a>
    <a href="bid_help_01.php?o={$bidOpenId}" class="btn btn-outline-secondary">
      <i class="fas fa-circle-info"></i> Web入札会 商品のさがし方
    </a>
    <a href="bid_help.php?o={$bidOpenId}" class="btn btn-outline-secondary">
      <i class="fas fa-circle-question"></i> Web入札会 よくある質問
    </a>
  </div>
{/block}