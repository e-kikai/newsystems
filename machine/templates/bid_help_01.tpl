{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}help.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
      p {
        font-size: 15px;
      }

      p strong {
        color: #933;
      }

      .bid_help_area img {
        width: 80%;
        display: block;
        margin: 8px auto 64px auto;
        border: 1px solid #333;
      }

      .bid_help_area {
        margin: 32px auto;
      }
    </style>
  {/literal}
{/block}

{block name='main'}
  <div class="bid_help_area">
    <h2>商品のさがし方</h2>
    <p>
      <a
        href="bid_door.php?o={$bidOpenId}">Web入札会のトップページ</a>の、<strong>地域会場とジャンルからさがす</strong>から、Web入札会に出品されている商品をさがすことができます。<br />

      まず、商品をさがしたい<strong>地域</strong>を選択します。(「全国」を選択することもできます)
    </p>
    <img src="/imgs/bid_help_01_01.png" />
    <p>

      続いて、さがしたい商品の<strong>ジャンル</strong>を選択します。<br />
    </p>
    <img src="/imgs/bid_help_01_02.png" />
    <p>
      すると、選択した「地域」「ジャンル」に該当する商品の一覧が表示されます。<br />
      一覧では「出品番号」や「最低入札金額」などで並び替えをすることもできます。
    </p>
    <img src="/imgs/bid_help_01_03.png" />
    <p>
      一覧から、<strong>商品名</strong>をクリックすると、商品の詳細情報と画像を表示することができます。
    </p>

    <img src="/imgs/bid_help_01_06.png" />

    <h2>商品についての問い合わせ</h2>
    <p>
      「商品の状態を知りたい」「送料を知りたい」「下見や試運転は可能か」など、商品についての質問がありましたら、出品者に商品についての問い合せを行うことができます。<br />

      メールで問い合わせをする場合は、<strong>フォームから問い合わせ</strong>をクリックしてください。
    </p>
    <img src="/imgs/bid_help_01_04.png" />


    <p>
      問い合わせフォームから出品者に対して質問を送ることができます。<br />
    </p>
    <img src="/imgs/bid_help_01_07.png" />


    <p>
      電話で問い合わせを行う場合は、<strong>電話で問い合わせ</strong>をクリックすると問い合わせTELが表示されますので、そちらに問い合わせください。
    </p>
    <img src="/imgs/bid_help_01_05.png" />


    <h2>入札方法について</h2>
    <p>
      Web入札会への入札は、全機連の会員会社が行うことができます。<br />
      入札を行いたい場合は、<strong>フォームから問い合わせ</strong>から出品者入札を依頼するか、電話で出品者に入札の依頼を行って下さい。<br />
      (入札する商品の商品番号、商品名、入札金額をお伝え下さい。)<br /><br />

      また、もし既にお取引のある全機連会員がある場合、そちらの会社に入札を依頼することもできます。<br /><br />

      <strong>
        ※ 入札には締切時間がありますので、時間の余裕を持って入札を依頼することをお勧めいたします。
      </strong>
    </p>
  </div>
{/block}