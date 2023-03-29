{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}toppage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
      .form_button:link,
      .form_button:visited,
      .form_button:active,
      .form_button {
        display: block;
        margin: 32px auto;
        font-size: 18px;
        text-align: center;
        width: 300px;
        height: 40px;
        line-height: 40px;
        color: #FFF;
        text-decoration: none;
        background: #3973E1;
        box-shadow: 3px 3px 3px rgba(0, 0, 0, 0.6);
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="help_contents banner">
    <h2>広告バナー掲載</h2>
    <p>
      貴社の企業広告バナーをマシンライフ中古機械情報のトップページ上段に掲載し、貴社サイトへリンク致します。<br />
      広告バナーサイズは、大バナー(横234px×縦60px)、
      小バナー(横88px×縦31px)に指定させていただいております。<br />
      また、バナー画像の作成も承っております。お申し込みの際ご相談下さい。(制作料：5,000円～)
    </p>

    <img class="banner_sample" src="imgs/banner_half_sample.png" alt="大バナーサンプル" />
    <img class="banner_sample" src="imgs/banner_micro_sample.png" alt="小バナーサンプル" />

    <br style="clear:both;" />

    <h2>入札会バナー掲載</h2>
    <p>
      貴社の入札会バナー広告をマシンライフ中古機械情報のトップページに掲載します。<br />
      バナークリックにより入札会ご案内ページへリンク致します。<br />
      バナー画像はご希望により作成致しますので(作成費用は別途見積り)、ご相談下さい。<br /><br />

      また、マシンライフのユーザに向けて、入札会情報をメールにて一括配信することもできます。<br />
      メール配信を希望される場合は、フォーム「メール配信」の「希望する」を選択してください。
    </p>

    {*
  <img class="banner_sample" src="imgs/banner_bid_sample.png" alt="入札会バナーサンプル" />
  *}
    <img class="banner_sample" src="imgs/banner_half_sample.png" alt="入札会バナーサンプル" />

    <br style="clear:both;" />

    <h2>入札会ご案内ページの作成</h2>

    <p>
      貴社の入札会のご案内ページ(トップページ、商品一覧、商品詳細ページ)を作成いたします。<br /><br />

      入札会ご案内ページの情報(入札案内、入札規約、入札機械リスト)は、<br />
      Excel・Word等で原稿を作成し、メールにてお送り下さい。<br />
      機械写真(jpeg)はメ-ル添付、容量が多い場合はCD-R等で郵送をお願い致します。<br /><br />

      [作成ページサンプル]<br />
    <div>
      <img src="./imgs/companybid_sample_01.png" class="companybid_sample" />
      <img src="./imgs/companybid_sample_02.png" class="companybid_sample" />
      <br style="clear:both;" />

    </div>
    </p>


    <h2>料金</h2>
    <div class="price_box">
      <div class="price_title">広告バナー掲載料金</div>
      <div class="price_sub">月額基本料金</div>
      <div class="price_contents">大バナー<br />50,000円 (税込) /月</div>
      <div class="price_contents">小バナー<br />10,000円 (税込) /月</div>
    </div>

    <div class="price_box">
      <div class="price_title">入札会バナー掲載料金</div>
      <div class="price_sub">基本料金</div>
      <div class="price_contents">入札会期間中<br />30,000円 (税込) /回</div>
      {*
    <div>入札会案内ページ等作成費用は<br />別途見積りいたします</div>
    *}
    </div>

    <div class="price_box">
      <div class="price_title">入札会ご案内ページの作成</div>
      <div class="price_sub">基本料金</div>
      <div class="price_contents">入札会期間中<br />80,000円 (税込) /回</div>
      <div>その他ご要望は<br />別途見積りいたします</div>
    </div>

    <br style="clear:both;" />

    <h2>お申し込みからご掲載の流れ</h2>
    <dl class="bannerinfo">
      <dt>フォーム申し込み</dt>
      <dd>
        バナー掲載、入札会ご案内ページ作成は、申込みフォームよりお申し込み下さい。<br />
        お申し込み直後、お申し込み内容の確認メールを自動送信致しますので、ご確認下さい。
      </dd>

      <dt class="odd">ご案内・詳細ご連絡</dt>
      <dd>
        掲載につきましてのご確認と詳細のご連絡をさせて頂きます。<br /><br />
        また、バナー画像制作、入札会案内ページ作成をご希望の場合は、<br />
        この際詳細をお伺いさせて頂きます。
      </dd>

      <dt>バナー画像のご用意</dt>
      <dd>
        お申し込みのサイズのバナー画像をご用意下さい。<br />
        入稿方法はメールにバナー画像データを添付してお送り下さい。
      </dd>

      <dt class="odd">請求書送付</dt>
      <dd>
        半年分（前払い）の請求書を送付させて頂きます。
      </dd>

      <dt>お支払い</dt>
      <dd>
        指定の銀行口座にお振込願います。
      </dd>

      <dt class="odd">広告掲載開始</dt>
      <dd>
        ご入金確認後、広告の掲載を開始致します。
      </dd>
    </dl>

    <br style="clear:both;" />

    <h2>お申し込みフォーム</h2>

    <p>
      お申し込みはこちらから！<br />
      お申込フォームに必要事項をご記入の上、送信して下さい。<br />
      送信後、内容確認のメールが自動送信されます。
    </p>

    <div class="d-grid gap-3 col-4 mx-auto">
      <a class="btn btn-primary btn-lg" href="help_banner_form.php">
        <i class="fas fa-paper-plane"></i> お申し込みフォーム
      </a>
    </div>
  </div>

{/block}