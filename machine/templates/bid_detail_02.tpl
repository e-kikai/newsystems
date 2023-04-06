{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="description"
    content="出品番号 {$machine.list_no}, 最低入札金額 {$machine.min_price|number_format}円 | {$machine.addr1}・{$machine.company|regex_replace:'/(株式|有限|合.)会社/u':''}。入札依頼は{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}まで。" />

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}detail.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}detail.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:site" content="@zenkiren" />
  <meta name="twitter:title" content="{$pageTitle}" />
  <meta name="og:title" content="{$pageTitle}" />
  <meta name="twitter:description"
    content="出品番号 {$machine.list_no}, 最低入札金額 {$machine.min_price|number_format}円 |
    {$machine.addr1}・{$machine.company|regex_replace:'/(株式|有限|合.)会社/u':''}。入札依頼は{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}まで。" />
  <meta name="twitter:image" content="{$_conf.media_dir}machine/{$machine.top_img}">

  {if MyAuth::check()}
    {literal}
      <script type="text/javascript">
        $(function() {
          /// 入札処理 ///
          $('button.my_bid').click(function() {
            var data = {
              'bid_machine_id': $.trim($('input.bid_machine_id').val()),
              'amount': string2int($.trim($('input.amount').change().val())),
              // 'charge': $.trim($('input.charge').val()),
              'comment': $.trim($('input.comment').val()),
            };

            /// 入力のチェック ///
            var e = '';

            if (!data['amount']) {
              e += '◆ 入札金額が入力されていません\n';
            } else if (data['amount'] < parseInt($('input.min_price').val())) {
              e += "◆ 入札金額が、最低入札金額より小さく入力されています\n";
              e += "最低入札金額 : " + cjf.numberFormat($('input.min_price').val()) + '円';
            } else if ((data['amount'] % parseInt($('input.rate').val())) != 0) {
              e += '◆ 入札金額が、' + cjf.numberFormat($('input.rate').val()) + '円単位ではありません\n。';
            }

            /// エラー表示 ///
            if (e != '') { alert(e); return false; }

            /// 送信確認 ///
            var mes = "最低入札金額 : " + cjf.numberFormat($('input.min_price').val()) + '円\n';
            mes += "入札金額 : " + cjf.numberFormat(data['amount']) + '円\n\n';

            if (data['amount'] > parseInt($('input.min_price').val()) * 5) {
              mes += "※ 注意！！ 入札金額が最低入札金額の5倍を超えています。\n\n";
            }

            mes += 'この内容で入札します。よろしいですか。';
            if (!confirm(mes)) { return false; }

            /// 数値のみに自動整形 ///
            $('input.number').val(data['amount']);

            return true;
          });

          /// フォーム内容をカンマ区切りに自動整形 ///
          $('input.number').focusout(function() {
            var price = string2int($(this).val());
            $(this).val(price ? cjf.numberFormat(price) : '');
          });

          /// フォーム内容を数値のみに自動整形 ///
          $('input.number').focusin(function() {
            var price = string2int($(this).val());
            $(this).val(price ? price : '');
          });

        });

        function string2int(amount) {
          return parseInt(mb_convert_kana(amount, 'KVrn').replace(/[^0-9.]/g, ''));
        }
      </script>
    {/literal}
  {/if}

  {literal}
    <script type="text/javascript">
      $(function() {
        $(window).on('load scroll resize', function(e) {
          $(window).scrollTop() > 480 ? $('.contactbar').show() : $('.contactbar').hide();
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block name='main'}

  {if !empty($machine)}

    {include "include/bid_timer.tpl"}
    {if !empty($machine.canceled_at)}
      <div class="alert alert-danger col-8 mx-auto mt-4 mb-0">
        <i class="fas fa-triangle-exclamation"></i> この入札会出品商品は、出品キャンセルされました。<br /><br />

        申し訳ありませんが、入札を行うことができません。
      </div>
    {/if}

    <div class="next_area">
      {if !empty($prevMachine)}
        <a class="prev_link" href="bid_detail.php?m={$prevMachine.id}"
          {* onclick="_gaq.push(['_trackEvent', 'detail_link', 'prev', '{$prevMachine.id}', 1, true]);" *}
          onclick="ga('send', 'event', 'detail_link', 'prev', '{$prevMachine.id}', 1, true);">
          ←前の商品
        </a>
      {/if}

      {if !empty($nextMachine)}
        <a class="next_link" href="bid_detail.php?m={$nextMachine.id}"
          {* onclick="_gaq.push(['_trackEvent', 'detail_link', 'next', '{$nextMachine.id}', 1, true]);" *}
          onclick="ga('send', 'event', 'detail_link', 'next', '{$nextMachine.id}', 1, true);">
          次の商品 →
        </a>
      {/if}
    </div>

    <div class='detail_container'>
      <table class="spec bid-table">
        <tr class="">

          <th>出品番号</th>
          <td class="bid_machine_id">{* {$machine.id} - *}{$machine.list_no}</td>

          <th>最低入札金額</th>
          <td class="detail_min_price">{$machine.min_price|number_format}円</td>
        </tr>
      </table>

      <div class="img_area">
        <table class="spec">
          <tr class="">
            <th>機械名</th>
            <td>{$machine.name}</td>
          </tr>
          <tr class="">
            <th>メーカー</th>
            <td>{$machine.maker}</td>
          </tr>
          <tr class="">
            <th>型式</th>
            <td>{$machine.model}</td>
          </tr>
          <tr class="">
            <th>年式</th>
            <td>{$machine.year}</td>
          </tr>

          {if !empty($machine.capacity_label)}
            <tr class="capacity number">
              <th>{$machine.capacity_label}</th>
              <td>{if empty($machine.capacity)}-{else}{$machine.capacity}{$machine.capacity_unit}{/if}</td>
            </tr>
          {/if}

          <tr class="spec">
            <th>仕様</th>
            <td>
              {if !empty($others)}
                <div class="others">{$others|escape|regex_replace:"/\s\|\s/":'</div> | <div class="others">' nofilter}</div> |
              {/if}
              {if !empty($machine.spec)}
                <div class="others">
                  {$machine.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">' nofilter}</div>
              {/if}
            </td>
          </tr>
        </table>
      </div>

      <div class="spec_area">
        <table class="spec">
          <tr class="accessory">
            <th>送料負担</th>
            <td>
              {BidMachine::shipping($machine.shipping)}
              {if !empty($machine.shipping_comment)}<div>{$machine.shipping_comment}</div>{/if}
            </td>
          </tr>
          <tr class="accessory">
            <th>附属品</th>
            <td>{$machine.accessory}</td>
          </tr>

          <tr class="comment">
            <th>コメント</th>
            <td>{$machine.comment}</td>
          </tr>

          <tr class="carryout_note">
            <th>引取留意事項</th>
            <td>{$machine.carryout_note}</td>
          </tr>
          <tr class="">
            <th>出品会社</th>
            <td>
              <a href='company_detail.php?c={$machine.company_id}'>{$company.company}</a>
            </td>
          </tr>

          <tr class="">
            <th>在庫場所</th>
            <td class='location'>
              {$machine.addr1} {$machine.addr2} {$machine.addr3}
              {if $machine.location}<br />({$machine.location}){/if}
              {if $machine.addr3}
                <a class="accessmap"
                  href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
                  target="_blank">
                  <i class="fas fa-map-location-dot"></i> MAP
                </a>
              {/if}
            </td>
          </tr>
          <tr class="label_area">
            <td colspan="2">
              {if $machine.commission == 1}<div class="label commission">試運転可</div>{/if}
              {if !empty($machine.pdfs)}
                {foreach $machine.pdfs as $key => $val}
                  <a href="{$_conf.media_dir}machine/{$val}" class="label pdf" target="_blank"
                    title="クリックで資料PDFを閲覧できます">PDF:{$key}</a>
                {/foreach}
              {/if}
            </td>
          </tr>
        </table>

      </div>
      <br class="clear" />

      <div class="img_area">
        {if !empty($machine.canceled_at)}
          この商品はキャンセルされました。
        {else if MyAuth::check()}
          <div class="watch_area">
            {if empty($my_bid_watch)}
              <form method="post" action="/mypage/my_bid_watches/create_do.php">
                <input type="hidden" name="id" value="{$machine.id}" />

                <button class="watch_button btn btn-warning btn-lg">
                  <i class="fas fa-star text-white"></i> ウォッチリストに登録
                </button>
              </form>
            {else}
              <form method="post" action="/mypage/my_bid_watches/delete_do.php">
                <input type="hidden" name="id" value="{$machine.id}" />
                <input type="hidden" name="return" value="detail" />

                <button class="watch_button btn btn-outline-secondary btn-lg">
                  <i class="fas fa-star text-warning"></i> ウォッチリスト登録済 (解除する)
                </button>
              </form>
            {/if}
          </div>

          {if $bidOpen.status == 'bid'}
            <h2>入札</h2>

            <form method="post" action="/mypage/my_bid_bids/create_do.php">

              <input type="hidden" class="min_price" value="{$machine.min_price}" />
              <input type="hidden" class="rate" value="{$bidOpen.rate}" />
              <input type="hidden" class="bid_open_id" value="{$bidOpenId}" />
              <input type="hidden" name="id" class="bid_machine_id" value="{$machineId}" />

              <table class="form spec w-100">
                <tr class="bid">
                  <th>最低入札金額</th>
                  <td class="">{$machine.min_price|number_format}円</td>
                </tr>
                <tr class="bid">
                  <th>入札金額 <span class="required">(必須)</span></th>
                  <td>
                    <input type="text" name="amount" class="number amount form-control" required />円<br />
                    入札金額は、{$bidOpen.rate|number_format}円単位で行えます。
                  </td>
                </tr>
                {*
              <tr class="bid">
                <th>入札担当者<span class="required">(必須)</span></th>
                <td>
                  <input type="text" name="charge" class="charge" required />
                </td>
              </tr>
              *}
                <tr class="bid">
                  <th>備考欄</th>
                  <td>
                    <input type="text" name="comment" class="comment  form-control" />
                  </td>
                </tr>
              </table>

              <hr />
              <p class="contents">
                ・ 入札は、下見・入札期間内であれば、取消・再入札を行うことができます。<br />
                ・ 入札の結果は、入札締め切り後に確定・公開されます。<br />
                (入札締切後は、入札の取り消しを行うことはできません)<br />
                ・ 同額の入札があった場合は、同額入札から落札者をシステムで自動的に決定いたします。予めご了承ください。<br />
                ・ 落札された場合は、各自出品会社と直接取引を行ってください。
              </p>
              <div class="text-center">
                <button class="my_bid btn btn-primary btn-lg my-2">
                  <i class="fas fa-pen-to-square"></i> 規約に同意して、入札する
                </button>
              </div>
            </form>
          {elseif in_array($bidOpen.status, array('carryout', 'after'))}
            <h2>落札結果</h2>
            <table class="spec">
              <tr class="">
                <th>入札数</th>
                <td>{if !empty($bids_count)}{$bids_count}件{else}入札なし{/if}</td>
              </tr>
              {if !empty($bids_count)}
                <tr class="">
                  <th>落札金額</th>
                  <td>{$bids_result.amount|number_format}円</td>
                </tr>

                <tr class="">
                  <th>同額札</th>
                  <td>{$bids_result.same_count|number_format}</td>
                </tr>
              {/if}
            </table>

            {*
            {if !empty($resultCompany)}
              <h2>あなたの入札</h2>
              <table class="spec">
                <tr class="price">
                  <th>入札金額</th>
                  <td>{$resultCompany.amount|number_format}円</td>
                </tr>
                <tr class="">
                  <th>備考欄</th>
                  <td>{$resultCompany.comment}</td>
                </tr>
                <tr class="">
                  <th>落札結果</th>
                  <td>{if $result.bid_id == $resultCompany.bid_id}◯{else}×{/if}</td>
                </tr>
              </table>
            {/if}
            *}
          {else}
            <h2>入札</h2>
            <p class="contents">下見・入札期間の開始前です。</p>
          {/if}
        {else}
          {if in_array($bidOpen.status, array('bid'))}
            <h2>入札に参加するには？</h2>

            <div class="d-grid gap-2 col-12 mx-auto my-4">
              <div>商品への入札は、ユーザ登録を行うことでどなたでも行なえます。</div>
              <a href="/mypage/sign_up.php" class="btn btn-outline-secondary mb-4">
                <i class="fas fa-user-plus"></i> 入札に参加するには - 入札会ユーザ登録
              </a>
              <div>ユーザ登録を行った後、マイページにログインしてください。</div>
              <a href="/mypage/login.php?r=1" class="btn btn-outline-secondary">
                <i class="fas fa-right-to-bracket"></i> マイページ - ログイン
              </a>
            </div>

          {elseif in_array($bidOpen.status, array('entry', 'margin'))}
            <p class="contents">
              {$bidOpen.title}の下見・入札期間は、{$bidOpen.preview_start_date}～です。<br /><br />
            </p>
          {else}
            <p class="contents">
              {$bidOpen.title}は、終了しました。<br /><br />
              たくさんの入札へのご参加ありがとうございました。<br />

              次回のWeb入札会もご期待ください。<br />
            </p>
          {/if}
        {/if}

      </div>
      <div class="spec_area">
        <div class='contact_area'>
          {if !empty($company.contact_mail)}
            <a class="contact" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank"
              onclick="ga('send', 'event', 'bid_contact', 'detail_middle');">
              <i class="fas fa-paper-plane"></i> フォームから問い合せ
            </a>
          {/if}

          <a class="button contact_tel subwindow" href="bid_detail_tel.php?m={$machine.id}"
            onclick="ga('send', 'event', 'bid_contact', 'detail_tel_middle');">
            <i class="fas fa-phone"></i> 電話で問い合わせ
          </a>

          {if !empty($smarty.session.bid_batch) && !empty($smarty.session.bid_batch[$machine.id])}
            <button class="mylist" value="{$machine.id}" style="display:none;"
              onclick="ga('send', 'event', 'bid_batch', 'set', '{$machine.id}', 1, true);"><span
                class="mylist_pluse">＋</span>一括問い合わせに追加</button>
            <button class="delete_mylist" value="{$machine.id}"
              onclick="ga('send', 'event', 'bid_batch', 'delete', '{$machine.id}', 1, true);">一括問い合わせ削除</button>
          {else}
            <button class="mylist" value="{$machine.id}"
              onclick="ga('send', 'event', 'bid_batch', 'set', '{$machine.id}', 1, true);"><span
                class="mylist_pluse">＋</span>一括問い合わせに追加</button>
            <button class="delete_mylist" value="{$machine.id}" style="display:none;"
              onclick="ga('send', 'event', 'bid_batch', 'delete', '{$machine.id}', 1, true);">一括問い合わせ削除</button>
          {/if}
          {$smarty.session.bid_batch_log}
          {if !empty($smarty.session.bid_batch_log) && !empty($smarty.session.bid_batch_log[$machine.id])}
            <div class="bid_batch_log">{$smarty.session.bid_batch_log[$machine.id]}に一括問い合わせ済</div>
          {/if}
        </div>
      </div>
      <br class="clear" />


      {*** レコメンド ***}
      {if !empty($recommends)}
        <h2 class="same_machine_label">この商品をチェックした人はこの商品も見ています</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $recommends as $sm}
                {if $sm.id == $machineId }{continue}{/if}
                {include file='include/bid_samecard.tpl' machine=$sm label='rec_machine'}
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}

      {*** 画像 ***}
      <div class="large_img_area">
        {if !empty($machine.top_img)}
          <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/{$machine.top_img}" alt="" />
          <noscript><img src="{$_conf.media_dir}machine/{$machine.top_img}" alt="" /></noscript>
        {/if}
        {if !empty($machine.imgs)}
          {foreach $machine.imgs as $i}
            <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/{$i}" alt='' />
            <noscript><img src="{$_conf.media_dir}machine/{$i}" alt='' /></noscript>
          {/foreach}
        {/if}
      </div>

      {if !empty($sameMachineList) && count($sameMachineList) > 1}
        <h2 class="same_machine_label">この商品と同じジャンルの商品はこちら</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $sameMachineList as $sm}
                {if $sm.id == $machineId }{continue}{/if}
                {include file='include/bid_samecard.tpl' machine=$sm label='same'}
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}

      {if !empty($logMachineList)}
        <h2 class="same_machine_label">この商品を見た人は、こちらの出品商品も見ています</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $logMachineList as $sm}
                {include file='include/bid_samecard.tpl' machine=$sm label='others'}
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}

      {if !empty($IPLogMachineList)}
        <h2 class="same_machine_label">最近チェックした入札会出品商品</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $IPLogMachineList as $sm}
                {include file='include/bid_samecard.tpl' machine=$sm label='checked'}
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}
    </div>

    <div class="contactbar">
      <div class="contactbar_area">
        <div class="names">
          出品番号:{$machine.list_no} 最低入札金額 {$machine.min_price|number_format}円<br />
          {$machine.name} {$machine.maker} {$machine.model}
        </div>
        <a class="contact" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank"
          onclick="ga('send', 'event', 'bid_contact', 'detail_contactbar');">フォームから問い合わせ</a>

        <a class="button contact_tel subwindow" href="bid_detail_tel.php?m={$machine.id}"
          onclick="ga('send', 'event', 'bid_contact', 'detail_tel_contactbar');">電話で問い合わせ</a>
      </div>
    </div>

    {assign "keywords" "{$machine.name}|{$machine.maker}|{$machine.model}|{$machine.genre}"}
    {include file="include/mnok_ads.tpl"}

  {else}
    <div class="error_mes">
      指定された方法では、入札会商品情報の特定ができませんでした<br />
      誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
    </div>

    {assign "keywords" "中古"}
    {include file="include/mnok_ads.tpl"}
  {/if}

{/block}