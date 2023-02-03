{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="container">
    <div class="row justify-content-md-center">
      <div class="col-6">
        <div class="bid_machine">
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
                <dt class="col-5">管理番号</dt>
                <dd class="col-7">{$bid_machine.list_no}</dd>
                <dd class="col-12">
                  <a href="/bid_detail.php?m={$bid_machine.id}" target="_blank">
                    {$bid_machine.name} {$bid_machine.maker} {$bid_machine.model}
                  </a>
                </dd>
                <dt class="col-5">最低入札金額</dt>
                <dd class="col-7">{$bid_machine.min_price|number_format}円</dd>
                <dt class="col-5">出品会社</dt>
                <dd class="col-7">
                  <a href="company_detail.php?c={$company.id}">
                    {$company.company}
                  </a>
                </dd>

                <hr />
                <dt class="col-5">入札数</dt>
                <dd class="col-7">{$bid_count|number_format} 件</dd>
                <dt class="col-5">落札金額</dt>
                <dd class="col-7">{$bid_result.amount|number_format}円</dd>
              </dl>
            </div>
          </div>

        </div>


        <div class="col-12">
          <form id="trade" method="post" action="mypage/my_bid_trades/star_do.php">
            <input type="hidden" name="bid_machine_id" value="{$bid_machine.id}" />

            <div class="my-4">
              評価を選択して「評価を送信する」をクリックしてください。<br />
              商品の評価が受取確認になります。
            </div>

            <div>
              <div class="mb-2">良い</div>
              <div class="mb-2">
                <input type="radio" name="star" id="star_5" value="5" checked="checked" />
                <label class="star" for="star_5">★★★★★</label>
              </div>
              <div class="mb-2">
                <input type="radio" name="star" id="star_4" value="4" />
                <label class="star" for="star_4">★★★★</label>
              </div>
              <div class="mb-2">
                <input type="radio" name="star" id="star_3" value="3" />
                <label class="star" for="star_3">★★★</label>
              </div>
              <div class="mb-2">
                <input type="radio" name="star" id="star_2" value="2" />
                <label class="star" for="star_2">★★</label>
              </div>
              <div class="mb-2">
                <input type="radio" name="star" id="star_1" value="1" />
                <label class="star" for="star_1">★</label>
              </div>
              <div>悪い</div>
            </div>

            <button type="submit" name="submit" class="submit btn btn-primary" value="login">
              <i class="fas fa-paper-plane"></i> 評価を送信する
            </button>
          </form>

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