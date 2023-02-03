{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// フォーム入力の確認 ///
        $('form#trade').submit(function() {
          if (!$('textarea#comment').val()) {
            alert('コメントを入力してください。');
            return false;
          }
          var mes = "この取引内容を投稿します。よろしいですか。\n\n";
          mes += "※ 取引の内容は、出品会社にメールで通知されます。";

          if (!confirm(mes)) { return false; }

          return true;
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="container">
    <div class="row">
      <div class="col-5">
        <div class="bid_machine">
          <h2><i class="fas fa-gears"></i> 落札商品</h2>
          <div class="row">
            <div class="col-5">
              {if !empty($bid_machine.top_img)}
                <a href="/bid_detail.php?m={$bid_machine.id}" target="_blank">
                  <img src="{$_conf.media_dir}machine/{$bid_machine.top_img}"
                    alt="管理番号 : {$bid_machine.list_no} {$bid_machine.name} {$bid_machine.maker} {$bid_machine.model}"
                    style="width:150px;height:150px;object-fit:cover;" />
                </a>
              {/if}
            </div>
            <div class="col-7">

              <dl class="row">
                <dt class="col-6">管理番号</dt>
                <dd class="col-6">{$bid_machine.list_no}</dd>
                <dd class="col-12">
                  <a href="/bid_detail.php?m={$bid_machine.id}" target="_blank">
                    {$bid_machine.name} {$bid_machine.maker} {$bid_machine.model}
                  </a>
                </dd>
                <dt class="col-6">最低入札金額</dt>
                <dd class="col-6">{$bid_machine.min_price|number_format}円</dd>
                <hr />
                <dt class="col-6">入札数</dt>
                <dd class="col-6">{$bid_count|number_format} 件</dd>
                <dt class="col-6">落札金額</dt>
                <dd class="col-6">{$bid_result.amount|number_format}円</dd>
              </dl>
            </div>
          </div>

          <p class="text-danger">
            ＜※ 注意事項＞<br />
            落札金額には、<br />
            送料・梱包費・諸経費などが含まれていない場合があります。<br />
            ご入金の前に必ず「取引」で金額の確認を行ってください。
          </p>

          <div>
            {if !empty($bid_machine.star)}
              受取確認済 : <span class="star">{str_repeat("★", $bid_machine.star)}</span>
            {else}
              <a href="mypage/my_bid_trades/star.php?m={$bid_machine.id}" class="btn btn-success">
                <span class="star">★</span> 受取確認・評価
              </a>
            {/if}
          </div>

        </div>

        <div class="bid_machine">
          <h2><i class="fas fa-building"></i> 出品会社情報</h2>
          <dl class="row">
            <dt class="col-4">会社名</dt>
            <dd class="col-8">
              <a href="company_detail.php?c={$company.id}">
                {$company.company}
              </a>
            </dd>
            <dt class="col-4">住所</dt>
            <dd class="col-8">〒 {$company.zip}<br />{$company.addr1} {$company.addr2} {$company.addr3}</dd>
            <dt class="col-4">問い合わせTEL</dt>
            <dd class="col-8">{$company.contact_tel}</dd>
            <dt class="col-4">問い合わせFAX</dt>
            <dd class="col-8">{$company.contact_fax}</dd>
            <dt class="col-4">担当者</dt>
            <dd class="col-8">{$company.officer}</dd>
            <dt class="col-4">営業時間</dt>
            <dd class="col-8">{$company.infos.opening}</dd>
            <dt class="col-4">定休日</dt>
            <dd class="col-8">{$company.infos.holiday}</dd>
          </dl>
        </div>
      </div>
      <div class="col-7">
        <div class="text-danger fw-bold">
          <i class="fas fa-triangle-exclamation"></i> 取引に関する注意事項
          - <span class="text-decoration-underline">必ずお読みください。</span>
        </div>
        <div class="alert alert-danger text-danger">
          ・ 取引開始は、下見・入札期間終了後1週間以内にお願いいたします。<br />
          ・ 発送方法、送料、梱包などの確認は必ず行ってください。<br />
          ・ 入金確認後に商品の発送します。到着後 ★ 受取確認・評価を行ってください。
        </div>

        <form id="trade" method="post" action="mypage/my_bid_trades/create_do.php">
          <input type="hidden" name="bid_machine_id" value="{$bid_machine.id}" />

          <div class="form-floating">
            <textarea name="comment" class="form-control" style="height: 120px" id="comment"
              required="required"></textarea>
            <label for="comment">ここに取引内容を入力</label>
          </div>

          <button type="submit" name="submit" class="submit btn btn-primary" value="login">
            <i class="fas fa-paper-plane"></i> 投稿する
          </button>
        </form>

        <hr />

        {if empty($my_bid_trades[0])}
          <div>まだ、取引内容がありません。書き込まれた取引の内容はここに表示されます。</div>
        {else}
          <div class="row">
            {foreach $my_bid_trades as $bt}
              {if $bt.answer_flag == true}
                <div class="col-10">
                  <div>{'/(株式|有限|合.)会社/'|preg_replace:'':$company.company} | {$bt.created_at|date_format:'%Y/%m/%d %H:%M'}</div>
                  <div class="alert alert-secondary">
                    {$bt.comment|escape|nl2br nofilter}
                  </div>
                </div>
              {else}
                <div class="col-10 offset-2">
                  <div>{$bt.created_at|date_format:'%Y/%m/%d %H:%M'}</div>
                  <div class="alert alert-success">
                    {$bt.comment|escape|nl2br nofilter}
                  </div>
                </div>
              {/if}
            {/foreach}
          </div>
        {/if}
      </div>
    </div>
  </div>

  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/mypage/my_bid_bids/?o={$bid_machine.bid_open_id}" class="btn btn-outline-secondary">
      <i class="fas fa-pen-to-square"></i> 入札一覧(落札一覧)に戻る
    </a>
    <a href="/mypage/" class="btn btn-outline-secondary">
      <i class="fas fa-house"></i> マイページ トップに戻る
    </a>
  </div>

{/block}