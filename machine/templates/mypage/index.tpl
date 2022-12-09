{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript"></script>
    <style type="text/css"></style>
  {/literal}
{/block}

{block 'main'}
  <div class="row">
    <div class="gap-2 col-6 p-3">
      <h2>現在開催中の入札会</h2>
      {if !empty($bid_opens)}
        {foreach $bid_opens as $b}
          <div class="bid_open">
            <h3>{$b.title} :: {BidOpen::statusLabel($b.status)}</h3>
            <dl class="bid_date">
              <dt>下見期間</dt>
              <dd>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</dd>
              <dt>入札締切</dt>
              <dd>{$b.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</dd>
              <dt>請求日</dt>
              <dd>{$b.billing_date|date_format:'%Y/%m/%d'}</dd>
              <dt>支払日</dt>
              <dd>{$b.payment_date|date_format:'%Y/%m/%d'}</dd>
              <dt>搬出期間</dt>
              <dd>{$b.carryout_start_date|date_format:'%Y/%m/%d'} ～ {$b.carryout_end_date|date_format:'%m/%d'}</dd>
            </dl>


            {if $b.status == 'entry' || $b.status == 'margin'} {* 下見前 *}
              <div>下見・入札期間開始まで、しばらくお待ち下さい</div>
            {elseif $b.status == 'bid' || $b.status == 'carryout'} {* 入札期間 *}
              <ul class="list-group list-group-flush">
                <a href="/bid_door.php?o={$b.id}" target="_blank" class="list-group-item list-group-item-action">
                  <i class="fas fa-door-open"></i> Web入札会トップページ
                </a>
                {*
                <a href="/admin/bid_list.php?o={$b.id}&output=csv&limit=999999999"
                  class="list-group-item list-group-item-action"><i class="fas fa-file-csv"></i> 印刷CSV出力
                </a>
                *}
                <a href="{$_conf.media_dir}pdf/list_pdf_{$b.id}.pdf" target="_blank"
                  class="list-group-item list-group-item-action">
                  <i class="fas fa-file-pdf"></i> 出品商品リスト - 印刷PDF
                </a>
                <a href="/mypage/my_bid_watches/?o={$b.id}" class="list-group-item list-group-item-action">
                  <i class="fas fa-star"></i> ウォッチリスト
                </a>

                {if $b.status == 'bid'}
                  <a href="/mypage/my_bid_bids/?o={$b.id}" class="list-group-item list-group-item-action">
                    <i class="fas fa-pen-to-square"></i> 入札一覧
                  </a>
                {else}
                  <a href="/mypage/my_bid_bids/?o={$b.id}" class="list-group-item list-group-item-action">
                    <i class="fas fa-pen-to-square"></i> 入札一覧(落札一覧)
                  </a>
                  <a href="/mypage/my_bid_bids/total.php?o={$b.id}" class="list-group-item list-group-item-action">
                    <i class="fas fa-list-check"></i> 全体の落札結果一覧
                  </a>
                {/if}
              </ul>
            {/if}

          </div>


        {/foreach}
      {else}
        <li>現在開催中の入札会はありません</li>
      {/if}

    </div>
    <div class="gap-2 col-6 p-3">

      <ul class="list-group list-group-flush">
        <a href="/mypage/bid_opens/" class="list-group-item list-group-item-action">
          <i class="fas fa-list"></i> 過去の入札会一覧
        </a>
      </ul>

      <hr />

      <ul class="list-group list-group-flush">
        <a href="/mypage/my_users/edit.php" class="list-group-item list-group-item-action">
          <i class="fas fa-circle-user"></i> ユーザ情報変更
        </a>
        <a href="/mypage/my_users/passwd.php" class="list-group-item list-group-item-action">
          <i class="fas fa-lock"></i> パスワード変更</a>
      </ul>
      <hr />
      <ul class="list-group list-group-flush">
        <a href="/mypage/logout_do.php" class="list-group-item list-group-item-action">
          <i class="fas fa-right-from-bracket"></i> ログアウト
        </a>
      </ul>

    </div>
  </div>
{/block}