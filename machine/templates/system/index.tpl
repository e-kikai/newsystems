{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  <div class="menu_area">
    <h2>会員情報</h2>
    <li>
      <a href="/system/company_list.php">会員一覧(変更・削除・代理ログイン)</a> >>
      <a href="/system/company_form.php">新規会員登録</a> |
      <a href="system/company_list.php?output=csv">CSV出力</a>
    </li>
    <li><a href="/system/company_pdf_form.php">請求書PDF出力フォーム</a></li>

    <li>
      <a href="/system/user_list.php">ユーザ一覧(変更・削除)</a> >>
      <a href="/system/user_form.php">新規ユーザ登録</a> |
      <a href="system/user_list.php?output=csv">CSV出力</a>
    </li>
    {*
  <a href="group_list.php">団体一覧</a>
  <a href="group_form.php">新規団体登録</a>
  *}
    <li><a href="/system/csv_form.php">CSV一括登録(百貨店汎用)</a></li>

    <li><a href="/system/xl_genre_list.php">ジャンル管理</a></li>

    <li>
      <a href="/system/companysite_list.php">自社サイト一覧(変更・削除)</a> >>
      <a href="/system/companysite_form.php">新規登録</a>
    </li>

    <h2>情報発信</h2>
    <li>
      <a href="/system/info_list.php">事務局からのお知らせ</a> >>
      <a href="/system/info_form.php">新規登録</a>
    </li>
    <li>
      <a href="/system/mail_form.php">メール一括送信</a> >>
      <a href="/system/mail_ignore.php">非送信メールアドレス編集</a> |
      <a href="/system/mail_list.php">メールログ</a>
    </li>

    <li>
      <a href="/system/bidinfo_list.php">入札会バナー一覧</a> >>
      <a href="/system/bidinfo_form.php">新規登録</a>
    </li>

    <li>
      <a href="/system/formula.php">実績用データ集計</a>
    </li>


    <h2>電子カタログ</h2>
    <li><a href="/system/catalog_csv_form.php">電子カタログCSV一括登録・変更</a></li>
    <li><a href="/system/catalog_request_list.php">カタログリクエストログ</a></li>

    {*
  <h2>会員入札会</h2>
  <li>
    <a href="/system/bidinfo_list.php">入札会バナー一覧</a> >>
    <a href="/system/bidinfo_form.php">新規登録</a>
  </li>

  <li>
    <a href="/system/memberbid_open_list.php">会員入札会一覧</a> >>
    <a href="/system/memberbid_open_form.php">新規登録</a>
    <a href="/system/companybid_machine_list.php?o=1&output=pdf&limit=9999999">下げ札PDF</a>
  </li>
  *}

    <h2>Web入札会</h2>
    <li>
      <a href="/system/bid_open_list.php">Web入札会一覧</a> >>
      <a href="/system/bid_open_form.php">新規登録</a>
    </li>
    <li><a href="/system/my_users/"><i class="fas fa-users"></i> 入札会ユーザ一覧</a></li>


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
            <dt>入札日時(一般向け)</dt>
            <dd>{$b.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</dd><br />
            <dt>請求日</dt>
            <dd>{$b.billing_date|date_format:'%Y/%m/%d'}</dd><br />
            <dt>支払日</dt>
            <dd>{$b.payment_date|date_format:'%Y/%m/%d'}</dd><br />
            <dt>搬出期間</dt>
            <dd>{$b.carryout_start_date|date_format:'%Y/%m/%d'} ～ {$b.carryout_end_date|date_format:'%m/%d'}</dd><br />
          </dl>
          {if $b.status == 'entry'}
            <li><a href="/system/bid_list.php?o={$b.id}">商品リスト</a></li>
          {elseif in_array($b.status, array('margin', 'bid', 'carryoff'))}
            <li>
              <a href="/bid_door.php?o={$b.id}" target="_blank">
                <i class="fas fa-door-open"></i> Web入札会トップページ
              </a>
            </li>
            <li>
              <a href="/system/bid_list.php?o={$b.id}">
                <i class="fas fa-list"></i> 商品リスト
              </a>
            </li>
            {*
          <li><a href="system/bid_makelist.php?o={$b.id}">出品番号付加、リストPDF生成</a></li>
          *}
            <li><a href="/system/bid_mylist_log.php?o={$b.id}">マイリスト使用状況</a></li>
          {elseif $b.status == 'carryout'}
            <li>
              <a href="/bid_door.php?o={$b.id}" target="_blank">
                <i class="fas fa-door-open"></i> Web入札会トップページ
              </a>
            </li>
            <li>
              <a href="system/my_bid_bids/total.php?o={$b.id}"><i class="fas fa-list"></i> 落札結果一覧</a> >>
              <a href="system/my_bid_bids/total.php?o={$b.id}&output=csv">
                <i class="fas fa-file-csv"></i> CSV出力
              </a>
            </li>
            <li>
              <a href="system/my_bid_bids/companies.php?o={$b.id}">
                <i class="fas fa-calculator"></i> 出品会社ごとの集計
              </a> >>
              <a href="system/my_bid_bids/companies.php?o={$b.id}&output=csv">
                <i class="fas fa-file-csv"></i> CSV出力
              </a>
            </li>
            <li>
              <a href="system/my_bid_bids/my_users.php?o={$b.id}">
                <i class="fas fa-calculator"></i> ユーザごとの集計
              </a> >>
              <a href="system/my_bid_bids/my_users.php?o={$b.id}&output=csv">
                <i class="fas fa-file-csv"></i> CSV出力
              </a>
            </li>

            {*
            <li>
              <a href="system/bid_result.php?o={$b.id}" target="_blank">落札・出品集計一覧</a> >>
              <a href="system/bid_result.php?o={$b.id}&output=csv&type=sum">CSV出力</a>
            </li>
            <li><a href="system/bid_result.php?o={$b.id}&output=pdf&type=sum" target="_blank">落札・出品集計表印刷(PDF)</a></li>
            <li><a href="system/bid_result.php?o={$b.id}&output=pdf&type=receipt" target="_blank">領収証印刷(PDF)</a></li>
            *}
            <li><a href="/system/bid_mylist_log.php?o={$b.id}">マイリスト使用状況</a></li>
          {/if}
          <li>
            <a href="system/bid_makelist.php?o={$b.id}">
              <i class="fas fa-file-pdf"></i> 出品番号付加、リストPDF生成
            </a>
          </li>
          <li>
            <a href="system/bid_announce_form.php?o={$b.id}">
              {* <i class="fas fa-info-circle"></i> お知らせ・引取指図書フラグ変更 *}
              <i class="fas fa-info-circle"></i> お知らせ変更
            </a>
          </li>

          <hr />

          <li>
            <a href="/system/bid_detail_logs/?o={$b.id}"><i class="fas fa-file-lines"></i> 詳細アクセスログ</a> >>
            <a href="/system/bid_detail_logs/?o={$b.id}&output=csv">
              <i class="fas fa-file-csv"></i> CSV出力
            </a>
          </li>
          <li>
            <a href="/system/my_bid_watches/?o={$b.id}"><i class="fas fa-star"></i> ウォッチリストログ</a> >>
            <a href="/system/my_bid_watches/?o={$b.id}&output=csv">
              <i class="fas fa-file-csv"></i> CSV出力
            </a>
          </li>
          {if $b.status == 'carryout'}
            <li>
              <a href="/system/my_bid_bids/?o={$b.id}"><i class="fas fa-pen-to-square"></i> 入札ログ</a> >>
              <a href="/system/my_bid_bids/?o={$b.id}&output=csv">
                <i class="fas fa-file-csv"></i> CSV出力
              </a>
            </li>
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
            <div>企業間売り切り商品出品期間中</div>
            <li><a href="/system/seri_list.php?o={$b.id}">出品商品一覧</a></li>
          {elseif strtotime($b.seri_start_date) <= time() && strtotime($b.seri_end_date) > time() }
            <div>企業間売り切り開催中</div>
            <li><a href="/system/seri_list.php?o={$b.id}">出品商品一覧</a></li>
          {elseif strtotime($b.seri_end_date) <= time() }
            <li><a href="/system/seri_list.php?o={$b.id}">結果一覧</a></li>
            <li>
              <a href="system/seri_result.php?o={$b.id}" target="_blank">落札・出品集計一覧</a> >>
              <a href="system/seri_result.php?o={$b.id}&output=csv&type=sum">CSV出力</a>
            </li>
            <li><a href="system/seri_result.php?o={$b.id}&output=pdf&type=sum" target="_blank">落札・出品集計表印刷(PDF)</a></li>
            <li><a href="system/seri_result.php?o={$b.id}&output=pdf&type=receipt" target="_blank">領収証印刷(PDF)</a></li>
          {/if}
        {else}
          <div>企業間売り切りは設定されていません</div>
        {/if}
      </div>
      *}

      {/foreach}
    {else}
      <li>現在開催中の入札会はありません</li>
    {/if}

    <h2>ログ</h2>
    <li><a href="/system/contact_list.php">お問い合わせ一覧</a></li>
    <li>
      <a href="/system/contact_ss.php?m=now">お問い合わせログ集計表</a> >>
      <a href="/system/contact_ss.php">月単位</a>
    </li>
    <li>
      <a href="/system/actionlog_list.php?t=machine">アクションログ一覧(中古機械情報)</a>
    </li>
    <li>
      <a href="/system/actionlog_list.php?t=catalog">アクションログ一覧(電子カタログ)</a>
    </li>

    <li><a href="/munin/" target="_blank">munin</a></li>
    <li><a href="/system/phpinfo.php" target="_blank">phpinfo</a></li>

    <h2>全機連マシンライフ</h2>
    <li>
      <a href="{$_conf.website_uri}" target="_blank">全機連ウェブサイト</a> >>
      <a href="https://www.google.com/analytics/web/?hl=ja&pli=1#report/visitors-overview/a36579656w64706588p66466813/"
        target="_blank">Google Analytics</a> |
      <a href="https://www.google.com/webmasters/tools/top-search-queries?hl=ja&siteUrl=http://www.zenkiren.org/"
        target="_blank">ウェブマスターツール</a>
    </li>
    <li>
      <form id="website_form" method="POST" action="{$_conf.website_uri}/?cmd=qhmauth" target="_blank">
        <input type="hidden" name="username" value="admin" />
        <input type="hidden" name="password" value="testtest" />
        <input type="hidden" name="send" value="Enter" />
        <a href="javascript:$('#website_form').submit();" class="website_button">ウェブサイト編集</a>
      </form>
    </li>
    <li>
      <a href="{$_conf.machine_uri}" target="_blank">中古機械情報</a> >>
      <a href="https://www.google.com/analytics/web/?hl=ja&pli=1#report/visitors-overview/a36579656w64949168p66710971/"
        target="_blank">Google Analytics</a> |
      <a href="https://www.google.com/webmasters/tools/top-search-queries?hl=ja&siteUrl=http%3A%2F%2Fwww.zenkiren.net%2F"
        target="_blank">Google ウェブマスターツール</a>
    </li>
    <li>
      <a href="{$_conf.catalog_uri}" target="_blank">電子カタログ</a> >>
      <a href="https://www.google.com/analytics/web/?hl=ja&pli=1#report/visitors-overview/a36579656w64957419p66706092/"
        target="_blank">Google Analytics</a>
    </li>

  </div>
{/block}