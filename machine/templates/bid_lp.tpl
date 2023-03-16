{extends file='include/layout.tpl'}

{block name='header'}
  {literal}
    <script type="text/javascript">
      $(function() {
        /// マイリスト登録 ///
        $('a.mylist').click(function() {
          $('.preuser_form_area').dialog({
            show: "fade",
            hide: "fade",
            closeText: '閉じる',
            title: 'メールアドレス登録',
            width: 540,
            height: 240,
            resizable: false,
            modal: true,
          });

          $('input.mail').focus();

          return false;
        });

        /// ユーザ登録処理 ///
        $('button.preuser_submit').click(function() {
          var data = {
            'mail': $.trim($('input.mail').val()),
            'user_name': $.trim($('input.user_name').val()),
          };

          /// 入力のチェック ///
          var e = '';
          if (data.mail == '') {
            e += "メールアドレスが入力されていません\n";
          } else if (!data.mail.match(/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/)) {
            e += "メールアドレスが間違っている可能性があります。\nもう一度お確かめください\n";
          }

          /// エラー表示 ///
          if (e != '') { alert(e); return false; }

          $('button.preuser_submit').attr('disabled', 'disabled').text('処理中、そのままお待ち下さい');

          $.post('./ajax/bid_mylist.php', {
            'target': 'machine',
            'action': 'setPreuser',
            'data': data,
          }, function(res) {
            $('button.preuser_submit').removeAttr('disabled').text('メールアドレスを登録する');

            if (res != 'success') {
              alert(res);
              return false;
            }
            // cookie登録
            // $.cookie('bid_preuser_check', 1, { expires: 31 });
            $('.preuser_form_area').dialog('close');
            $('button.mylist[value=' + $('input.preuser_bid_machine_id').val() + ']').click();

            // 登録完了
            return false;
          });

          return false;
        });

        if ($('input.preview_flag').val() != '') {
          $('a.link_button')
            .attr('href', 'javascript:void(0);')
            .append('<div class="link_before">' + $('input.preview_flag').val() + 'OPEN!</div>');

          $('.link_label, a.link_button img').css('opacity', 0.5);
        }
      });
    </script>
    <style>
      a.sp_bid_link {
        display: block;
        width: 860px;
        margin: 8px auto;
        background: #27367B;
        color: #FFF;
        font-size: 23px;
        font-weight: bold;
        height: 48px;
        line-height: 48px;
        text-align: center;
        text-decoration: none;
      }

      a.sp_bid_link span.highligeht {
        color: #FFFF33;
        border-bottom: 1px dotted #FFFF33;
        padding: 0;
        line-height: 1;
      }

      a.sp_bid_link img {
        vertical-align: top;
      }

      img.banner_half {
        display: block;
        margin: 8px auto;
      }

      /*** Web入札会開催日程 以下を追加 ***/
      table.tender_schedule {
        width: 890px;
        padding: 20px 0px 0px 0px;
        margin: 20px auto 0 auto;
        margin-bottom: 5px;
        border: 1px solid #00A0E8;
      }

      table.tender_schedule th {
        font-size: 16px;
        padding: 10px;
        text-align: center;
        color: #000;
        background: #C8E7FB;
        border: 1px solid #00A0E8;
      }

      table.tender_schedule td {
        font-size: 16px;
        padding: 10px;
        text-align: center;
        border: 1px solid #00A0E8;
        background: #FFF;
      }

      .right {
        width: 890px;
        text-align: right;
      }

      div.lp_01_cont5tit {
        height: 49px;
      }

      img.step {
        object-fit: cover;
        object-position: 0 0;
        width: 200px;
        height: 478px;
        display: block;
        margin: 0 auto 20px 0;
      }
    </style>
  {/literal}

  <meta name="description" content="全機連が主催する全国展開の中古工作機械・工具のWeb入札会。開催日程や入札への参加方法などをご案内。" />
  <meta name="keywords" content="中古機械,工具,Web,Web入札会,マシンライフ,全機連,全日本機械業連合会" />
  <link rel="stylesheet" href="./imgs/bid201403/default.css" type="text/css" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}bid_mylist.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="{$_conf.site_uri}{$_conf.css_dir}/lpdesign.css" type="text/css" />

{/block}

{block 'main'}
  <div id="wrapper">
    <div id="white_bg">

      <input type="hidden" class="preview_flag"
        value="{if time() < strtotime($bidOpen.preview_start_date)}{$bidOpen.preview_start_date|date_format:'%m月%d日'}({B::strtoweek($bidOpen.preview_start_date)}){/if}">

      <div style="position:relative;height:420px;">
        <img src="./imgs/lp_01_r.png" alt="全機連Web入札会のご案内">
        <div class="lp_01_title" style="position:absolute;top: 22px;left: 48px;text-align:left;width:600px;">
          {$bidOpen.title|escape|regex_replace:'/(Web入札会|([a-zA-Z])+|([^a-zA-Z])+)/':'<span>$1</span>' nofilter}</div>
        <span class="lp_01_title" style="position:relative;top:-360px;left:330px;"><a class="mylist" href="#"
            target="_blank"><img src="./imgs/lp_01_r_bot.png" alt="全機連Web入札会のご案内"></a></span>
        <span class="lp_01_info" style="position:absolute;top:232px;left:70px;text-align:left;">
          下見期間 : {$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.preview_start_date)}) ～
          {$bidOpen.preview_end_date|date_format:'%m月%d日'}({B::strtoweek($bidOpen.preview_end_date)})<br />
          入札締切 : {$bidOpen.user_bid_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.user_bid_date)})
          {$bidOpen.user_bid_date|date_format:'%H:%M'} 締切<br />
          搬出期間 : {$bidOpen.carryout_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.carryout_start_date)}) ～
          {$bidOpen.carryout_end_date|date_format:'%m月%d日'}({B::strtoweek($bidOpen.carryout_end_date)})
        </span>
        <span class="lp_01_sponsorship" style="position:absolute;top:310px;left:730px;text-align:left;">
          主催 : 全日本機械業連合会<br />
          運営者 : マシンライフ委員会</span>
      </div>

      {foreach $bidMachineList as $m}
        <div class="thumb_img"><img src="{$_conf.media_dir}machine/{$m['top_img']}"
            style="max-height:147px;max-width:196px;" /></div>
      {/foreach}

      <div>
        <a href="./bid_lp_photo.php?o={$bidOpenId}"><img src="./imgs/bid201403/img/c_02.png" alt="Webアルバム"></a>
      </div>

      <a class="link_button" href="bid_door.php?o={$bidOpenId}">
        <img src="./imgs/bid201403/img/c_button_r.png" alt="Web入札会 出品機械を下見する">
        <div class="link_label">
          下見期間{$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}～{$bidOpen.preview_end_date|date_format:'%m月%d日'}にて開催!
        </div>
      </a>

      <div style="margin-top:50px;" class="lp_01_htit">全機連の「ウェブ入札会」とは？</div>
      <div class="lp_01_txt">
        <div style="float:right;padding:10px;"><img src="../imgs/lp_01_img01.jpg"></div>
        全日本機械業連合会（略称：全機連）が主催し、中古機械販売のプロ（全機連会員企業）が厳選された中古機械を出品するウェブ形式の中古機械入札会です。複数の会社がウェブで合同で開催する形式は日本で唯一の仕組みで、入札希望企業様にとっては、よりたくさんの機械情報から、最適な機械を希望の価格で入札頂くことができます。また、高額で専門性の高い商品の入札をより円滑に、より安心してご参加頂けるように、全国数百社の機械販売業者により1962年に設立された全日本機械業連合会が主催している点も当ウェブ入札会の大きな特徴になっています。<br
          clear="both">
      </div>


      <div class="lp_01_tokuchotit"><img src="../imgs/lp_01_tokucho1.png"></div>
      <div class="lp_01_tokuchotxt">たくさんの機械販売業者から、<br />たくさんの中古機械が出品されます。</div>
      <br clear="both">

      <div class="lp_01_tokuchotit"><img src="../imgs/lp_01_tokucho2.png"></div>
      <div class="lp_01_tokuchotxt">入札から搬出・搬入の流れ、取引については<br />全機連会員企業が万全のサポートを行います。</div>
      <br clear="both">

      <div class="lp_01_toha">
        <div style="text-align:left;">
          <div style="float:left;padding:10px 10px 0 60px;"><img src="../imgs/lp_01_toha01.png"></div>
          <div style="padding-top:25px;" class="lp_01_tohatit">全機連とは？ <small>http://www.zenkiren.net</small></div>
          <br clear="both">

          <div style="width:850px;" class="lp_01_txt">
            <div style="float:right;padding:10px;"><img src="../imgs/lp_01_img02.jpg"></div>
            全日本機械業連合会（全機連）は、日本全国において工作機械、鍛圧機械を取り扱う事業者、および、事業法人によって運営されている唯一の非営利団体です。全機連は、全国の数百社に及ぶ、機械販売業者により 1962
            年に設立されました。<br /><br />

            私たちは、
          </div>
          <br clear="both">

          <div class="lp_01_tohabtxt">・工作機械、鍛圧機械販売のスペシャリストです。</div>
          <div class="lp_01_tohabtxt">・全機連会員は、あなたの信頼に応える豊富な専門知識を持っています。</div>
          <div class="lp_01_tohabtxt">・全機連会員は、中古機械の価値を熟知しています。</div>
          <div style="margin-bottom:30px;" class="lp_01_tohabtxt">・全機連会員は、長年の信頼と実績であなたの要求にお答えします。</div>
        </div>
      </div>

      <a class="link_button" href="bid_door.php?o={$bidOpenId}">
        <img src="./imgs/bid201403/img/c_button_r.png" alt="Web入札会 出品機械を下見する">
        <div class="link_label">
          下見期間{$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}～{$bidOpen.preview_end_date|date_format:'%m月%d日'}にて開催!
        </div>
      </a>

      <!--
      <img src="./imgs/lp_new_bid_01.png" alt="" style="width: 950px;margin: 8px auto" />
      -->
      <img src="./imgs/bid_lp_news_01.png" alt="" style="width: 760px;margin: 32px auto" />

      <div style="position:relative;">
        <img src="./imgs/lp_01_06_r.png" alt="全機連Web入札会 開催要項">

        <div class="c_06_title">{$bidOpen.title}<br />開催要項</div>
        <div class="c_06_info">
          下見期間 : {$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.preview_start_date)}) ～
          {$bidOpen.preview_end_date|date_format:'%m月%d日'}({B::strtoweek($bidOpen.preview_end_date)})<br />
          入札締切 : {$bidOpen.user_bid_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.user_bid_date)})
          {$bidOpen.user_bid_date|date_format:'%H:%M'}<br />
          搬出期間 : {$bidOpen.carryout_start_date|date_format:'%Y年%m月%d日'}({B::strtoweek($bidOpen.carryout_start_date)}) ～
          {$bidOpen.carryout_end_date|date_format:'%m月%d日'}({B::strtoweek($bidOpen.carryout_end_date)})
          <br /><br />
          主催 : 全日本機械業連合会<br />
          運営者 : マシンライフ委員会<br />
          事務局 : 大阪機械卸業団地協同組合 事務局<br />
          東大阪市本庄西2丁目5番10号 TEL 06-6747-7521
        </div>
      </div>

      <a class="link_button" href="bid_door.php?o={$bidOpenId}">
        <img src="./imgs/bid201403/img/c_button_r.png" alt="Web入札会 出品機械を下見する">
        <div class="link_label">
          下見期間{$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}～{$bidOpen.preview_end_date|date_format:'%m月%d日'}にて開催!
        </div>
      </a>

      <div style="margin-top:50px;" class="lp_01_htit">Web入札会 開催日程表</div>
      <table class="tender_schedule">

        <tr>
          <th>Web入札会</th>
          <th>下見期間</th>
          <th>入札締切・開票日</th>
        </tr>

        {foreach $bidOpenList as $bo}
          <tr itemscope itemtype="http://data-vocabulary.org/Event">
            <td itemprop="summary">
              <a itemprop="url" href="bid_lp.php?o={$bo.id}" target="_blank">{$bo.title}</a>
            </td>
            <td>
              <time itemprop="startDate" datetime="{$bo.preview_start_date|date_format:"%Y-%m-%d"}+09:00">
                {$bo.preview_start_date|date_format:"%Y/%m/%d"}
              </time>～
              <time itemprop="endDate" datetime="{$bo.preview_end_date|date_format:"%Y-%m-%d"}+09:00">
                {$bo.preview_end_date|date_format:"%Y/%m/%d"}
              </time>
            </td>
            <td>
              <div itemprop="location">
                {$bo.user_bid_date|date_format:"%Y/%m/%d"}
                ({B::strtoweek($bo.user_bid_date)})
                {$bo.user_bid_date|date_format:"%H:%M"}
                <span style="display:none;"> 入札締切・開票</span>
              </div>
              <div itemprop="description" style="display:none;">全機連が主催する、マシンライフ{$bo.title}</div>
            </td>
          </tr>
        {/foreach}
      </table>
      <div class="right">
        <a class="form_button" href="./imgs/2023schedule.pdf" target="_blank"><img src="./imgs/2014schedule.png"
            alt="2019年Web入札会日程(スケジュール)"></a>
      </div>


      <div style="margin-top:50px;" class="lp_01_htit">全機連が主催するウェブ入札会の特徴とは？</div>
      <div style="" class="lp_01_cont4tit">日本のモノづくりを陰で支えてきた全日本機械業連合会の会員が<br />
        総力を上げて取り組むWeb入札会!<br />
        自分たちの在庫機械だから実現できた<br />
        最低価格を日々モノづくりに取り組んでおられる皆様に<br />
        お届け致します</div>

      <div class="lp_waku_01">
        <div class="lp_waku_01_tit">ユーザー企業様にとって入札会のメリットは、</div>
        <div class="lp_waku_01_txt">たくさんの中古機械の中から、比較検討することができ、<br />
          ユーザー企業の予算に合わせて、
          {*
          (せり上がり方式でなく) 中古機械のプロがエージェントとなり、<br />
          *}
          欲しい中古機械や機械部品を予算内で購入できる仕組みです！
        </div>
      </div>


      <div style="" class="lp_01_cont5tit">① 希望価格での取引が実現！</div>
      <div style="margin:0 0 20px 50px;width:800px;" class="lp_01_txt">
        オークションと異なり、価格がせり上がっていく仕組みではないので、<br />
        ユーザー企業にとっては、冷静な御判断の元、希望価格で落札していただけるメリットがございます。<br />

        出品会社にお問い合わせすることもできますので、じっくり考えて入札をしてみてください。
      </div>

      {*
      <div style="" class="lp_01_cont5tit">② 面倒な交渉は業者におまかせ！</div>
      <div style="margin:0 0 20px 50px;width:800px;" class="lp_01_txt">
        また、機械業者がユーザー企業に代わって入札を行いますので、価格交渉や専門的な知識を必要とせずに参加いただけることも大きなメリットです。
      </div>
      *}

      <div style="" class="lp_01_cont5tit">② ユーザ登録を行うだけで、どなたでも入札に参加可能</div>
      <div style="margin:0 0 20px 50px;width:800px;" class="lp_01_txt">
        ユーザ登録(初回のみ)して、マイページにログインするだけで、入札に参加可能です。<br />
        ユーザ登録は、どなたでも無料で行なえます(国内事業者のみ)。
      </div>
      <div style="" class="lp_01_cont5tit">③ 信頼と実績のある、全機連の会員会社が出品</div>
      <div style="margin:0 0 20px 50px;width:800px;" class="lp_01_txt">

        また、出品は信頼のある全機連会員の機械業者なので、<br />
        落札後の手続きや専門的な知識を必要する場合などにも対応できることも、大きなメリットです。
      </div>

      <div style="" class="lp_01_cont5tit">④ 掘り出しものもたくさん発見？！</div>
      <div style="margin:0 0 20px 50px;width:800px;" class="lp_01_txt">
        細かな工具や設備棚などの出品もあります。必要なものが見つかればお買い得は間違いなしですね！<br />
        また、工作機械は製造業にとって、「ものづくりの道具」になります。様々な道具を情報収集することで、<br />
        生産コストを大幅に改善できる可能性もございます。
      </div>

      <div style="" class="lp_01_htit">入札会参加のステップ</div>

      <div style="text-align:center;position:relative;font-size:18px;line-height:26px;">
        <img src="../imgs/lp_01_cont05_01.png" class="step">

        {*
        <span style="position:absolute;top:21px;left:208px;width:700px;text-align:left;">
        *}
        <span style="position:absolute;top:21px;left:208px;width:700px;text-align:left;">
          下見期間中に出品中古機械を検索し、入札金額をご検討ください。<br>
          {*
          出品中古機械に関するお問い合わせや不明な点を、専用問合せフォームから直接出品商社にお問い合わせができます。
          *}
          商品に関するお問い合わせや不明な点がありましたら、<br />
          各商品の問合せフォームから直接出品会社にお問い合わせができます。
        </span>

        {*
        <span style="position:absolute;top:170px;left:230px;width:680px;text-align:left;">
        *}

        {*
          入札締切期間までに、希望入札金額や中古機械の状況など全機連会員からの入札のサポートに従い入札の手続きを行ってください。
        </span>
        <span style="position:absolute;top:281px;left:230px;width:680px;text-align:left;">
          入札を希望される中古機械についてのご質問は、<br />
          直接出品企業へお問い合わせフォームよりお問い合わせください。<br />
        *}

        <span style="position:absolute;top:138px;left:208px;width:680px;text-align:left;">

          商品の内容、価格などを比較検討の上、<br />
          ユーザ登録(初回のみ)・マイページログインを行っていただき、 <br />
          各商品の詳細ページにある入札フォームより、入札を行って下さい。<br /><br />

          また、マイページでは、
          ウォッチリストなどの便利機能や、入札の履歴の確認、<br />
          期間内の入札の取り消しなどを行えます。

          {*
          また、入札に関するサポートは、こちらより、最寄りの全機連会員にお問い合わせを頂くか中古機械出品企業へお問い合わせください。
          *}
        </span>
        {*
        <span style="position:absolute;top:400px;left:208px;width:700px;text-align:left;">
          落札結果や、搬出のお打ち合わせなどを全機連商社からサポートさせて頂きます。
        </span>
        *}

        <span style="position:absolute;top:350px;left:208px;width:700px;text-align:left;">

          入札期間が終了したら、落札結果が公開されます。<br /><br />

          商品を落札されましたら、チャット形式の取引フォームから<br />
          出品会社と代金の振り込み、搬出の打ち合わせなどの取引を行って下さい。
        </span>
      </div><br clear=all>

      <div style="font-size:21px;color:brown;text-align:center;margin:32px auto;">
        よりくわしい入札会の参加方法は、Web入札会 マニュアルをごらんください。 <br />
        ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓<br /><br />
      </div>

      <div>
        <a class="bid_help" href="bid_help_01.php?o={$bidOpenId}" style="">
          <i class="fas fa-circle-question"></i> 商品のさがし方
        </a>

        <a class="bid_help" href="bid_help_02.php?o={$bidOpenId}" style="">
          <i class="fas fa-circle-question"></i> 入札方法について
        </a>

        <a class="bid_terms" href="./imgs/terms_2023.pdf" style="" target="_blank">
          <i class="fas fa-file-pdf"></i> 利用規約
        </a>

        <a class="bid_terms" href="./imgs/machinelife_privacy_2023.pdf" style="" target="_blank">
          <i class="fas fa-file-pdf"></i> プライバシーポリシー
        </a>
      </div>

      {*
      <div><img src="../imgs/lp_01_cont05_02.png"  alt="Web入札会参加のステップ"></div>
      *}


      <a class="link_button" href="bid_door.php?o={$bidOpenId}">
        <img src="./imgs/bid201403/img/c_button_r.png" alt="Web入札会 出品機械を下見する">
        <div class="link_label">
          下見期間{$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}～{$bidOpen.preview_end_date|date_format:'%m月%d日'}にて開催!
        </div>
      </a>

      {*
      <div style="" class="lp_01_etc">
        <div style="" class="lp_01_etc_tit">■入札について </div>

        <div style="font-size:21px;color:brown;text-align:center;margin:32px auto;"> ///// ここに規約を表示する (PDFダウンロードリンクも) ////
        </div>
        *}

      {*
        <ol style="" class="lp_01_etc_txt">
          <li>入札資格者は、全日本機械業連合会会員及び大阪機械卸業団地協同組合組合員に限ります。<br>
            ウェブ入札会参加登録会員様マシンライフ会員様は、全機連会員企業を通じて入札参加することができます。</li>
          <li>入札参加者は、入札保証金として金 10 万円を現金又は銀行保証小切手にて納入して下さい。<br>
            ※この保証金は、入札結果発表後落札されなかった方にはお返しします。</li>
          <li>出品商品は、写真掲載の有姿のままとします。</li>
          <li>出品商品に掲載の価格は、最低表示でありますのでそれ以下は無効とし表示価格以上の最高価格を落札といたします。</li>
          <li>落札後の解約は一切お受けできませんので、熟慮の上、入札して下さい。</li>
        </ol>

        <div style="" class="lp_01_etc_tit">■引取について</div>
        <ol style="" class="lp_01_etc_txt">
          <li>引取は、指定期間内に落札商社に対して「引取書」と「指図書」をお渡しします。</li>
          <li>出品商社は、「引取書」と「指図書」により落札商品を落札商社指定の場所へ発送します。</li>
          <li>落札代金を期日までに納入されない場合は、入札は無効とし保証金を没収します。<br>
            又、これにより生じた損害は落札者に負担して頂きます。<br>
            又、以降の入札会参加は認めません。</li>
        </ol>

        <div style="" class="lp_01_etc_tit">■輸出に関するお願い</div>
        <ol style="" class="lp_01_etc_txt">
          <li>落札された商品を輸出等する場合は、「外国為替及び外国貿易法」等の輸出関連法規の定めに従い必要な手続きをお願いいたします。</li>
        </ol>

        <div style="" class="lp_01_etc_tit">■その他</div>
        <ol style="" class="lp_01_etc_txt">
          <li>連絡事項、変更等は Web 上に掲示いたします。</li>
          <li>詳細は Web 入札規程に基づき行います。</li>
          <li>落札者は落札額の 8％を消費税として加算させて頂きます。</li>
        </ol>

        *}

      {*
    </div>

      <a class="link_button" href="bid_door.php?o={$bidOpenId}">
        <img src="./imgs/bid201403/img/c_button_r.png" alt="Web入札会 出品機械を下見する">
        <div class="link_label">
          下見期間{$bidOpen.preview_start_date|date_format:'%Y年%m月%d日'}～{$bidOpen.preview_end_date|date_format:'%m月%d日'}にて開催!
        </div>
      </a>
*}
    </div>
  </div>


  <div class="preuser_form_area" style="display:none;text-align:left;font-size:13px;">
    <div class="preuser_01">
      マシンライフをご利用下さいましてありがとうございます。<br />
      登録されたメールアドレスには、今後のWeb入札会のご案内等をお送りいたします。
    </div>

    <input type="hidden" class="preuser_bid_machine_id" value="" />
    <label>メールアドレス<span class="require">(必須)</span><input class="mail" value="" /></label>
    <label>会社名、氏名<input class="user_name" value="" /></label>
    <button class='preuser_submit'>メールアドレスを登録する</button>
{/block}