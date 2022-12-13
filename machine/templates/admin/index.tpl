{extends file='include/layout.tpl'}

{block name='header'}

  {* ミニブログ *}
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}/miniblog.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}/miniblog.css" rel="stylesheet" type="text/css" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}/admin_index.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="info_area">
    {*
  <div class="count">
    在庫機械の総登録数  <span class="count_no">{$mCountAll|number_format}</span> 件<br />
    {if $mCountAll < 10000}
      目標1万件まで、あと <span class="count_no">{(10000 - $mCountAll)|number_format}</span> 件
    {else}
      <span class="count_no">目標1万件達成！！</span>
    {/if}
  </div>
  *}

    <div class="count">
      <span class="count_label">会員名</span> : {$company}<br />
      <span class="count_label">会員区分</span> : {Companies::getRankLabel($rank)}
      <a href="help_rank.php" style="font-weight:normal;font-size:13px;">会員区分と利用サービスについて</a>
      {*
    マシンライフ参加会社数  <span class="count_no">{$cCountByEntry|number_format}</span> 社<br />
    {if $cCountByEntry < 100}
      目標100社まで、あと <span class="count_no">{(100 - $cCountByEntry)|number_format}</span> 社
    {else}
      <span class="count_no">参加者100社目標達成致しました。ありがとうございます</span>
    {/if}
    *}
    </div>

    <div class="logininfo">
      {*
    {$userName} 様 - {$company}({$treenames}) {Companies::getRankLabel($company.rank)}
    *}
    </div>

    <div class="infotitle">事務局からのお知らせ</div>
    <div class="infomations">
      {if !empty($infoList)}
        {foreach $infoList as $i}
          <div class="info">
            {if strtotime($i.created_at) > strtotime('-1week')}
              <div class="cjf_new">NEW!</div>
            {/if}
            <div class="info_date">{$i.info_date|date_format:'%Y/%m/%d'}</div>
            <div class="info_contents">{$i.contents|escape|auto_link|nl2br nofilter}</div>
          </div>
        {/foreach}
      {else}
        <div class="info">まだ書きこみはありません</div>
      {/if}
    </div>

    {if Companies::checkRank($rank, 'B会員')}
      <div class="infotitle">売りたし買いたし</div>
      <div class="infomations">
        {if !empty($urikaiList)}
          {foreach $urikaiList as $uk}
            <div class="info">
              {if !empty($uk.end_date)}
                <div class="info_end_date">(解決済)</div>
              {elseif strtotime($uk.created_at) > strtotime('-1week')}
                <div class="cjf_new">NEW!</div>
              {/if}
              <div class="info_goal {$uk.goal}">{if $uk.goal == "cell"}売りたし{else}買いたし{/if}</div>
              <div class="info_no">No.{$uk.id}</div>
              <div class="info_name">{'/(株式|有限|合.)会社/u'|preg_replace:'':$uk.company}</div>
              <div class="info_date">{$uk.created_at|date_format:'%Y/%m/%d'}</div>

              <div class="info_contents" data-id="{$uk.id}">
                {$uk.contents|mb_substr:0:26}
                <a href="/admin/urikai_detail.php?id={$uk.id}" class="info_link">→詳細を見る</a>
              </div>
            </div>
          {/foreach}
        {else}
          <div class="info">まだ書きこみはありません</div>
        {/if}
      </div>
    {/if}

    <div class="infotitle">書きこみ</div>
    <div class="infomations miniblog">
      {if !empty($miniblogList)}
        {foreach $miniblogList as $mi}
          <div class="info">
            {if strtotime($mi.created_at) > strtotime('-1week')}
              <div class="cjf_new">NEW!</div>
            {/if}
            <div class="info_name">{'/(株式|有限|合.)会社/u'|preg_replace:'':$mi.user_name}</div>
            <div class="info_date">{$mi.created_at|date_format:'%Y/%m/%d %H:%M'}</div>
            <button type="button" class="miniblog_response" data-id="{$mi.id}">返信</button>
            <div class="info_contents" data-id="{$mi.id}">{$mi.contents|escape|auto_link|nl2br nofilter}</div>
          </div>
        {/foreach}
      {else}
        <div class="info">まだ書きこみはありません</div>
      {/if}
    </div>
  </div>

  <ul class="top_menu">

    {if Companies::checkRank($rank, 'A会員')}
      <h2>在庫機械情報</h2>
      <li>
        <a href="admin/machine_list.php">在庫機械一覧(変更・削除)</a> |
        <a href="admin/machine_form.php">新規登録</a> >>
        <a href="/search.php?c={$_user.company_id}" target="_blank">自社在庫一覧(確認用)</a>
      </li>
      <li>
        <a href="/admin/machine_list.php?output=csv&limit=999999999"><i class="fas fa-file-csv"></i> 在庫機械一覧CSV出力</a>
      </li>

      <li><a href="#" data-youtubeid="UbWiwrTvjiU" class="movie">[ヘルプ動画] Internet Explorerでの在庫情報登録</a></li>
      <li><a href="#" data-youtubeid="pm-Oqemnwz8" class="movie">[ヘルプ動画] Firefox,Safari,GoogleChromeでの在庫情報登録</a></li>
      <li><a href="#" data-youtubeid="9f9tLOLTleg" class="movie">[ヘルプ動画] Youtubeの動画登録</a></li>
    {/if}

    <h2>お問い合わせ</h2>
    <li><a href="admin/contact_list.php"><i class="fas fa-envelope"></i> 問い合わせ一覧</a></li>

    {if Companies::checkRank($rank, 'B会員')}
      <h2><span class="cjf_new" style="text-indent:0;">NEW!</span>売りたし買いたし</h2>
      <li><a href="admin/urikai_form.php">書き込む</a></li>
      <li><a href="admin/urikai_list.php">売りたし買いたし書き込み一覧</a></li>
      <li><a href="imgs/urikai_manual.pdf" target="_blank"><i class="fas fa-file-pdf"></i> 売りたし買いたしマニュアルPDF</a></li>
    {/if}

    {*** Web入札会 ***}
    <h2>Web入札会</h2>
    {if !empty($bidOpenList)}
      <li>▼▼▼現在開催中の入札会▼▼▼</li>
      {foreach $bidOpenList as $b}
        <div class="bid_open">
          <h3>{$b.title} :: {BidOpen::statusLabel($b.status)}</h3>
          <dl class="bid_date">
            <dt>出品期間</dt>
            <dd>{$b.entry_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.entry_end_date|date_format:'%m/%d %H:%M'}</dd><br />
            <dt>下見期間</dt>
            <dd>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</dd><br />
            <dt>入札期間</dt>
            <dd>{$b.bid_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.bid_end_date|date_format:'%m/%d %H:%M'}</dd><br />
            <dt>入札日時(一般向)</dt>
            <dd>{$b.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</dd><br />
            <dt>請求日</dt>
            <dd>{$b.billing_date|date_format:'%Y/%m/%d'}</dd><br />
            <dt>支払日</dt>
            <dd>{$b.payment_date|date_format:'%Y/%m/%d'}</dd><br />
            <dt>搬出期間</dt>
            <dd>{$b.carryout_start_date|date_format:'%Y/%m/%d'} ～ {$b.carryout_end_date|date_format:'%m/%d'}</dd><br />
          </dl>
          {if empty($smarty.session[Auth::getNamespace()].bid_first_flag)}
            <li><a href="/admin/bid_first_help.php"><i class="fas fa-right-to-bracket"></i> Web入札会に参加する</a></li>
          {else}
            {if $b.status == 'entry'}
              {if Companies::checkRank($rank, 'B会員')}
                <li><a href="/admin/bid_machine_form.php?o={$b.id}">新規商品登録</a></li>

                {if Companies::checkRank($rank, 'A会員')}
                  <li><a href="/admin/bid_machine2machine.php?o={$b.id}">在庫機械から出品</a></li>
                {/if}

                <li>
                  <a href="/admin/bid_machine_list.php?o={$b.id}">出品商品一覧(変更・削除)<span class="count">({$b.count})</span></a> >>
                  <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i> CSV出力</a>
                </li>
                <li><a href="/admin/bid_machine_list.php?o={$b.id}&output=pdf" target="_blank"><i class="fas fa-file-pdf"></i>
                    下げ札印刷用PDF</a></li>
              {/if}

            {elseif $b.status == 'margin'} {* 下見前 *}
              <li>
                <a href="/bid_door.php?o={$b.id}" target="_blank"><i class="fas fa-door-open"></i> Web入札会トップページ</a> >>
                <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999"><i class="fas fa-file-csv"></i> 印刷CSV出力</a> |
                <a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><i class="fas fa-file-pdf"></i> 印刷PDF出力</a>
              </li>

              {*
            <li><a href="/admin/bid_list.php?o={$b.id}">商品リスト</a></li>
            *}

              {if Companies::checkRank($rank, 'A会員')}
                {if Auth::check('system')}
                  <li>
                    <a href="/admin/bid_machine_form.php?o={$b.id}">
                      <i class="fas fa-plus"></i> 新規出品商品登録
                    </a>
                  </li>
                {/if}
                <li>
                  <a href="/admin/bid_machine_list.php?o={$b.id}">
                    <i class="fas fa-list"></i> 出品商品一覧<span class="count">({$b.count})</span>
                  </a>
                  >>
                  <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i> CSV出力</a>
                </li>
                <li>
                  <a href="/admin/bid_machine_list.php?o={$b.id}&output=pdf" target="_blank">
                    <i class="fas fa-file-pdf"></i> 下げ札印刷用PDF
                  </a>
                </li>
              {/if}

            {elseif $b.status == 'bid'} {* 入札期間 *}
              <li>
                <a href="/bid_door.php?o={$b.id}" target="_blank"><i class="fas fa-door-open"></i> Web入札会トップページ</a> >>
                <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999"><i class="fas fa-file-csv"></i> 印刷CSV</a> |
                <a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><i class="fas fa-file-pdf"></i> 印刷PDF</a>
              </li>

              {*
            <li>
              <a href="/admin/bid_list.php?o={$b.id}">商品リスト(入札・お問い合せ)</a>
            </li>
            <li><a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>商品リスト</a></li>
            *}

              {*
            <li><a href="/admin/bid_bid_list.php?o={$b.id}">入札履歴(入札の取消)</a></li>
            *}


              {if Companies::checkRank($rank, 'B会員')}
                {if Auth::check('system')}
                  <li>
                    <a href="/admin/bid_machine_form.php?o={$b.id}">
                      <i class="fas fa-plus"></i> 新規出品商品登録
                    </a>
                  </li>
                {/if}
                <li>
                  <a href="/admin/bid_machine_list.php?o={$b.id}">
                    <i class="fas fa-list"></i> 出品商品一覧<span class="count">({$b.count})</span>
                  </a>
                  >>
                  <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i> CSV出力</a>
                </li>

                <li>
                  <a href="/admin/bid_machine_list.php?o={$b.id}&output=pdf" target="_blank">
                    <i class="fas fa-file-pdf"></i> 下げ札印刷用PDF
                  </a>
                </li>


                <li>
                  <a href="/admin/my_bid_bids/?o={$b.id}">
                    <i class="fas fa-pen-to-square"></i> 自社出品への入札履歴
                  </a>
                </li>
              {/if}

            {elseif $b.status == 'carryout'}
              <li>
                <a href="/bid_door.php?o={$b.id}" target="_blank"><i class="fas fa-door-open"></i> Web入札会トップページ</a> >>
                <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999"><i class="fas fa-file-csv"></i> 印刷CSV</a> |
                <a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><i class="fas fa-file-pdf"></i> 印刷PDF</a>
              </li>
              {*
              <li><a href="/admin/bid_list.php?o={$b.id}"><i class="fas fa-list-check"></i> 落札結果一覧</a></li>
              *}
              <li>
                <a href="/admin/my_bid_bids/total.php?o={$b.id}"><i class="fas fa-list-check"></i> 落札結果一覧</a> >>
                <a href="/admin/my_bid_bids/total.php?o={$b.id}&output=csv&limit=999999999"><i class="fas fa-file-csv"></i>
                  印刷CSV</a>
              </li>

              {*
            <li><a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>商品リスト</a></li>
            *}

              {*
            <li>
              <a href="/admin/bid_bid_list.php?o={$b.id}">落札商品 個別計算表</a> >>
              <a href="/admin/bid_bid_list.php?o={$b.id}&output=csv">CSV出力</a>
            </li>
            *}

              {if Companies::checkRank($rank, 'B会員')}
                <li>
                  <a href="/admin/my_bid_bids/?o={$b.id}">
                    <i class="fas fa-pen-to-square"></i> 自社出品への入札履歴
                  </a>
                </li>

                <li>
                  <a href="/admin/bid_machine_list.php?o={$b.id}">出品商品 個別計算表<span class="count">({$b.count})</span></a> >>
                  <a href="/admin/bid_machine_list.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i> CSV出力</a>
                </li>
              {/if}

              {*
            <li>
              <a href="/admin/bid_result.php?o={$b.id}">落札・出品集計表</a>
            </li>
            *}

              {*
            <li>
              {if empty($b.sashizu_flag)}<span><div class="label pdf">印刷用PDF</div>引取・指図書 ＜事務局の承認待ち＞</span>
              {else}<a href="/admin/bid_bid_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>引取・指図書</a>
              {/if}
            </li>
            *}
            {/if}

            {*
          <li>
            <a href="/admin/bid_moushikomi.php?o={$b.id}" target="_blank"><div class="label pdf">印刷用PDF</div>入札会申込書</a> >> <a href="{$_conf.media_dir}pdf/moushikomi_sample.pdf" target="_blank">記入例</a>
          </li>
          <li>
            <a href="/admin/bid_fee_help.php?o={$b.id}">入札会手数料について</a> >>
            <a href="/admin/bid_fee_sim.php?o={$b.id}" onclick="window.open('/admin/bid_fee_sim.php?o={$b.id}','','scrollbars=yes,width=850,height=450,');return false;">支払・請求額シミュレータ</a>
          </li>
          *}
          {/if}
        </div>

        {*
      <div class="bid_open">
        <h3>{$b.title} :: 企業間売り切りシステム</h3>
        {if !empty($b.seri_start_date) && !empty($b.seri_end_date)}
          <dl class="bid_date">
            <dt>出品期間</dt>
            <dd>{$b.entry_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.bid_end_date|date_format:'%m/%d %H:%M'}</dd><br />
            <dt>開催期間</dt>
            <dd>{$b.seri_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$b.seri_end_date|date_format:'%m/%d %H:%M'}</dd><br />
          </dl>

          {if strtotime($b.entry_start_date) <= time() && strtotime($b.seri_start_date) > time() }
            <li><a href="/admin/seri_form.php?o={$b.id}">企業間売り切り出品</a></li>
          {elseif strtotime($b.seri_start_date) <= time() && strtotime($b.seri_end_date) > time() }
            <li><a href="/admin/seri_form.php?o={$b.id}">企業間売り切り管理</a></li>
            <li><a href="/admin/seri_list.php?o={$b.id}">特設ページ</a></li>
          {elseif strtotime($b.seri_end_date) <= time() }
            <li><a href="/admin/seri_list.php?o={$b.id}">結果一覧</a></li>
            <li>
              <a href="/admin/seri_bid_list.php?o={$b.id}">落札商品 個別計算表</a> >>
              <a href="/admin/seri_bid_list.php?o={$b.id}&output=csv">CSV出力</a>
            </li>
            <li>
              <a href="/admin/seri_form.php?o={$b.id}">出品商品 個別計算表</a> >>
              <a href="/admin/seri_form.php?o={$b.id}&output=csv">CSV出力</a>
            </li>

            <li><a href="/admin/seri_result.php?o={$b.id}">落札・出品集計表</a></li>
            <li><a href="/admin/seri_bid_list.php?o={$b.id}&output=pdf" target="_blank"><div class="label pdf">印刷用PDF</div>引取指図書</a></li>
          {/if}

          <li><a href="{$_conf.media_dir}pdf/seri_manual_01.pdf" target="_blank"><div class="label pdf">印刷用PDF</div>企業間売り切りシステム マニュアル</a></li>
        {else}
          <div>企業間売り切りは開催されません</div>
        {/if}
      </div>
      *}
      {/foreach}
    {else}
      <li>現在開催中の入札会はありません</li>
    {/if}



    <li><a href="/admin/bid_open_list.php"><i class="fas fa-list"></i> 過去のWeb入札会一覧</a></li>
    {if !empty($smarty.session[Auth::getNamespace()].bid_first_flag)}
      <li><a href="/admin/bid_first_help.php"><i class="fas fa-book"></i> Web入札会 運用規程</a></li>
      <li><a href="/admin/bid_entry_form.php"><i class="fas fa-check"></i> Web入札会 商品出品登録</a></li>
    {/if}

    <li><a href="admin/bid_manual.pdf" target="_blank"><i class="fas fa-file-pdf"></i> Web入札会 取扱説明書</a></li>

    {if Companies::checkRank($rank, 'B会員')}
      {if !empty($companysite.subdomain)}
        <h2>自社ウェブサイト作成サービス</h2>
        <li>
          <a href="admin/companysite_company_form.php">追加会社情報変更</a> >>
          <a href="/s/{$companysite.subdomain}/" target=="_blank">自社ウェブサイト表示(確認用)</a>
        </li>
      {/if}
    {/if}

    {*
  <h2>特別情報配信サービス</h2>
  <li><a href="admin/special_form.php">メール配信フォーム</a></li>
  <li><a href="admin/special_fax.php">FAXで配信</a></li>


  <h2>顧客メール一括送</h2>
  <li><a href="admin/mail_form.php">顧客メール一括送信フォーム</a></li>
  <li><a href="admin/mail_list.php">顧客メールログ</a></li>
  *}

    {*
  <h2>チラシメール</h2>
  <li><a href="admin/flyer_form.php">新規配信</a></li>
  <li><a href="admin/flyer_list.php">配信履歴一覧</a></li>
  *}

    {if Companies::checkRank($rank, 'B会員')}
      <h2>機械取扱説明書</h2>
      <li><a href="admin/manuals.php">機械情報センター 機械取扱説明書について</a></li>
    {/if}

    <h2>会社情報</h2>
    <li>
      <a href="admin/company_form.php">会社情報変更</a> >>
      <a href="/company_detail.php?c={$_user.company_id}" target="_blank">会社情報ページ(確認用)</a>
    </li>
    <li>
      <a href="admin/company_form.pdf" target="_blank"><i class="fas fa-file-pdf"></i> 会社情報変更手順PDF</a>
    </li>

    {if $_user.company_id == 320}
      <h2>◯ 自社ページ 追加情報 (test)</h2>
      <li>
        <a href="admin/d_info_list.php">お知らせ一覧</a> >>
        <a href="admin/d_info_form.php">新規登録</a>
      </li>
      <li>
        <a href="https://www.zenkiren.net/daihou/" target="_blank">自社ページ(確認用)</a>
      </li>
    {/if}

    <h2>ユーザ情報</h2>
    <li><a href="admin/passwd_form.php">パスワード変更</a></li>

    <h2>会員ページヘルプ</h2>
    <li><a href="admin/help.php?p=linkbunner">リンクバナーについて</a></li>


    <h2>全機連マシンライフ</h2>
    <li><a href="{$_conf.website_uri}" target="_blank">全機連ウェブサイト</a></li>
    <li><a href="{$_conf.machine_uri}" target="_blank">{$_conf.site_name}</a></li>

    {if Companies::checkRank($rank, 'B会員')}
      <li><a href="{$_conf.catalog_uri}" target="_blank">電子カタログ</a></li>
    {/if}
  </ul>
  <br clear="both">
{/block}