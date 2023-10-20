{extends file='include/layout.tpl'}

{block name='header'}
  {*
<meta name="description" content="
{if !empty({$machine.capacity}) && !empty({$machine.capacity_label})}{$machine.capacity_label}:{$machine.capacity}{$machine.capacity_unit} | {/if}
{if !empty({$machine.year})}年式:{$machine.year} | {/if}
{if !empty({$machine.addr1})}在庫場所:{$machine.addr1} | {/if}
{if !empty({$others})}{$others} | {/if}
{$machine.spec}
{if $machine.commission == 1} 試運転可{/if}
" />
*}
  <meta name="description"
    content="出品番号 {$machine.list_no}, 最低入札金額 {$machine.min_price|number_format}円 | {$machine.addr1}・{$machine.company|regex_replace:'/(株式|有限|合.)会社/u':''}。入札依頼は{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}まで。" />

  {*
<meta name="keywords" content="{$machine.name},{$machine.maker},{$machine.model},{$machine.addr1},中古機械,Web入札会,工具,全機連,マシンライフ" />
*}

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

  {if preg_match("/admin/", $smarty.server.REQUEST_URI)}

    {literal}
      <script type="text/javascript">
        /*
        $(function() {
          //// 入札処理 ////
          $('button.bid').click(function() {
            var data = {
              'bid_machine_id': $.trim($('input.bid_machine_id').val()),
              'amount': $.trim($('input.amount').change().val()),
              'charge': $.trim($('input.charge').val()),
              'comment': $.trim($('input.comment').val()),
            };

            // 表示切替
            $('input.amount').val(cjf.numberFormat(data.amount));

            //// 入力のチェック ////
            var e = '';
            $('input[required]').each(function() {
              if ($(this).val() == '') {
                e += "必須項目が入力されていません\n\n";
                return false;
              }
            });

            if (!data['amount']) {
              e += '入札金額が入力されていません\n';
            } else if (data['amount'] < parseInt($('input.min_price').val())) {
              e += "入札金額が、最低入札金額より小さく入力されています\n";
              e += "最低入札金額 : " + parseInt($('input.min_price').val()) + '円';
            } else if ((data['amount'] % parseInt($('input.rate').val())) != 0) {
              e += '入札金額が、入札レートの倍数ではありません\n';
            }

            //// エラー表示 ////
            if (e != '') { alert(e); return false; }

            // 送信確認
            if (!confirm('この内容で入札します。よろしいですか。')) { return false; }

            if (data['amount'] > parseInt($('input.min_price').val()) * 5) {
              if (!confirm("入札金額が最低入札金額の5倍を超えています。\nこの内容で入札してよろしいですか。")) {
                return false;
              }
            }

            $('button.bid').attr('disabled', 'disabled').text('保存処理中');

            $.post('/admin/ajax/bid.php', {
              'target': 'member',
              'action': 'bid',
              'data': data,
            }, function(res) {
              $('button.bid').removeAttr('disabled').text('入札');

              if (res != 'success') { alert(res); return false; }

              // 登録完了
              alert('入札が完了しました');
              location.href = '/admin/bid_list.php?o=' + $('input.bid_open_id').val();
            }, 'text');

            return false;
          });

          //// 数値のみに自動整形 ////
          $('input.number').change(function() {
            var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9.]/g, '');
            $(this).val(price ? parseInt(price) : '');
          });

          $('a.prev_link, a.next_link').each(function() {
            $(this).attr('href', $(this).attr('href').replace('bid_detail.php', 'admin/bid_detail.php'));
          });

          $('#company_list_form').each(function() {
            $(this).attr('action', $(this).attr('action').replace('bid_list.php', 'admin/bid_list.php'));
          });
        });
        */
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
      div.others {
        display: inline-block;
        min-height: initial;
      }

      table.spec.form {
        width: 442px;
      }

      table.spec.form th {
        background: #556B2F;
        width: 118px;
      }

      a.contact {
        width: 236px;
        height: 50px;
        font-size: 20px;
        line-height: 50px;
        text-align: center;
        border-radius: 4px;
      }

      a.contact-long {
        font-size: 16px;
      }

      f table.form td {
        position: relative;
      }

      button.bid {
        display: block;
        width: 140px;
        font-size: 15px;
        margin: 4px auto 32px auto;
        color: #333;
      }

      table.form td input.amount {
        font-size: 18px;
        width: 140px;
      }

      .contact_area {
        height: 118px;
      }

      .contact_area button.mylist,
      .contact_area button.mylist:hover,
      .contact_area button.mylist:active,
      .contact_area button.delete_mylist,
      .contact_area button.delete_mylist:hover,
      .contact_area button.delete_mylist:active {
        position: absolute;
        top: 53px;
        left: 0;
        margin: 0;
        height: 43px;
        width: 320px;
        font-size: 20px;
        line-height: 43px;
      }

      .contact_area button.mylist,
      .contact_area button.mylist:hover,
      .contact_area button.mylist:active {
        text-indent: 76px;
      }

      .contact_area .mylist_pluse {
        height: 41px;
        width: 42px;
        font-size: 20px;
        line-height: 43px;
      }

      div.bid_batch_log {
        width: 300px;
        position: absolute;
        top: 100px;
        color: #E02E2E;
      }

      a.mylist_text_link {
        top: -27px;
        right: 3px;
      }

      /*** contactbar ***/
      .contactbar {
        position: fixed;
        width: 100%;
        height: 60px;
        color: #FFF;
        background-color: rgba(0, 0, 0, 0.8);
        top: 0;
        left: 0;
      }

      .contactbar .contactbar_area {
        width: 980px;
        height: 60px;
        margin: 0 auto;
        position: relative;
      }

      .contactbar .names {
        font-size: 17px;
        display: block;
        position: absolute;
        top: 7px;
        left: 8px;
        width: 480px;
      }

      .contactbar a.contact {
        display: block;
        position: absolute;
        height: 50px;
        line-height: 50px;
        top: 5px;
        left: 492px;
      }

      a.button.contact_tel {
        display: block;
        position: absolute;
        width: 236px;
        height: 50px;
        line-height: 50px;
        background: #080;
        text-decoration: none;
        top: 0;
        left: 246px;
      }

      .contactbar a.contact_tel {
        top: 5px;
        left: 738px;
      }

      .contactbar .tel_label,
      .contactbar .contact_tel {
        left: 746px;
        position: absolute;
        display: block;
      }

      .contactbar .tel_label {
        top: 4px;
      }

      .contactbar .contact_tel {
        top: 26px;
      }
    </style>

  {/literal}

{/block}


{block name='main'}
  {if !empty($machine)}
    {include "include/bid_timer.tpl"}

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
              <td>
                {if empty($machine.capacity)}-
                {else}{$machine.capacity}{$machine.capacity_unit}
                {/if}</td>
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

              {if $machine.location}<br />({$machine.location})
              {/if}

              {if $machine.addr3}
                <a class="button accessmap"
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

        {*
          <button class="mylist_movie movie detail_mylist_movie" data-youtubeid="PaZiV_OA7io"
            title="クリックで動画再生します"
            onclick="ga('send', 'event', 'bid_mylist', 'movie', '{$machine.id}', 1, true);"
            >使い方動画</button>


        {if !empty($smarty.session.bid_mylist) && !empty($smarty.session.bid_mylist[$machine.id])}
              <a class="mylist_text_link" href="/bid_list.php?o={$bidOpenId}&mylist=1">お気に入り表示</a>

        {else}
              <button class="mylist" value="{$machine.id}"
                onclick="ga('send', 'event', 'bid_mylist', 'insert', '{$machine.id}', 1, true);"
                ><span class="mylist_pluse">＋</span>お気に入りに追加</button>

        {/if}
          *}
      </div>
      <br class="clear" />

      {*
        <div class="img_area">
          <div style="font-size:19px;">{$bidOpen.title}</div>
          <table class="spec">
            <tr class="">
              <th>下見期間</th>
              <td class="">
                {$bidOpen.preview_start_date|date_format:'%Y/%m/%d'} 〜
                {$bidOpen.preview_end_date|date_format:'%Y/%m/%d'}
              </td>
            </tr>

            <tr class="">
              <th>入札締切</th>
              <td class="">{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</td>
            </tr>
          </table>
        </div>
        *}

      <div class="img_area">
        {*
        <div class="spec_area">
        *}

        {*
        {if preg_match("/admin/", $smarty.server.REQUEST_URI)}

          {if $bidOpen.status == 'bid'}
            <h2>入札</h2>
            <input type="hidden" class="min_price" value="{$machine.min_price}" />
            <input type="hidden" class="rate" value="{$bidOpen.rate}" />
            <input type="hidden" class="bid_open_id" value="{$bidOpenId}" />
            <input type="hidden" class="bid_machine_id" value="{$machineId}" />

            <table class="form spec">
              <tr class="bid">
                <th>入札金額<span class="required">(必須)</span></th>
                <td>
                  <input type="text" name="amount" class="number amount" required />円<br />
                  入札レート : {$bidOpen.rate|number_format}円<br />
                  <a href="/admin/bid_fee_sim.php?o={$bidOpenId}"
                    onclick="window.open('/admin/bid_fee_sim.php?o={$bidOpenId}','','scrollbars=yes,width=850,height=450,');return false;">
                    支払・請求額シミュレータ
                  </a>
                </td>
              </tr>
              <tr class="bid">
                <th>入札担当者<span class="required">(必須)</span></th>
                <td>
                  <input type="text" name="charge" class="charge" required />
                </td>
              </tr>
              <tr class="bid">
                <th>備考欄</th>
                <td>
                  <input type="text" name="comment" class="comment" />
                </td>
              </tr>
            </table>
            <button class="bid">入札する</button>

          {elseif in_array($bidOpen.status, array('carryout', 'after'))}
            <h2>落札結果</h2>
            <table class="spec">
              <tr class="">
                <th>落札金額</th>
                <td>
                  {if !empty($result.amount)}{$result.amount|number_format}円
                  {else}入札なし
                  {/if}</td>
              </tr>
              <tr class="">
                <th>落札会社</th>
                <td>{$result.company}</td>
              </tr>
              <tr class="">
                <th>同額札</th>
                <td>
                  {if $result.same_count > 1}あり
                  {/if}</td>
              </tr>
            </table>


            {if !empty($resultCompany)}
              <h2>自社の入札</h2>
              <table class="spec">
                <tr class="price">
                  <th>入札金額</th>
                  <td>{$resultCompany.amount|number_format}円</td>
                </tr>
                <tr class="">
                  <th>入札担当者</th>
                  <td>{$resultCompany.charge}</td>
                </tr>
                <tr class="">
                  <th>備考欄</th>
                  <td>{$resultCompany.comment}</td>
                </tr>
                <tr class="">
                  <th>落札結果</th>
                  <td>
                    {if $result.bid_id == $resultCompany.bid_id}◯
                    {else}×
                    {/if}</td>
                </tr>
              </table>

            {/if}

          {else}
            <h2>入札</h2>
            <p class="contents">下見・入札期間の開始前です。</p>

          {/if}

        {else}

          {if in_array($bidOpen.status, array('bid'))}
            <p class="contents">
              <strong style="font-size:1.1em;text-decoration: underline;">商品への入札は、全機連会員を通じて行うことができます。</strong><br /><br />
              商品出品会社にフォーム・電話で問い合わせをしていただくか、<br />
              最寄りの全機連会員に入札の依頼を行って下さい。
            </p>


          {elseif in_array($bidOpen.status, array('entry', 'margin'))}
            <p class="contents">
              {$bidOpen.title}の下見期間は、{$bidOpen.preview_start_date}～です。<br /><br />
              入札のご依頼は、下見期間中に行って下さい。
            </p>

          {else}
            <p class="contents">
              {$bidOpen.title}は、終了しました。<br /><br />
              たくさんのご利用ありがとうございました。<br />

              次回のWeb入札会もご期待ください。<br />
            </p>

          {/if}

        {/if}
        *}

      </div>
      <div class="spec_area">
        <div class='contact_area'>

          {if !empty($company.contact_mail)}
            {*
                <a class="contact_link" href="contact.php?o={$bidOpenId}&bm={$machine.id}"
                  onclick="_gaq.push(['_trackEvent', 'bid_contact', 'detail_middle',]);"
                  target="_blank"><img src='./imgs/contact_button.png' /></a>
                *}
            <a class="contact" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank"
              {* onclick="_gaq.push(['_trackEvent', 'bid_contact', 'detail_middle']);" *}
              onclick="ga('send', 'event', 'bid_contact', 'detail_middle');">
              <i class="fas fa-paper-plane"></i> フォームから問い合せ
            </a>

          {/if}

          {*

        {if !empty($company.contact_tel)}<div class='tel'>TEL : {$company.contact_tel}</div>
        {/if}

        {if !empty($company.contact_fax)}<div class='fax'>FAX : {$company.contact_fax}</div>
        {/if}
            *}

          <a class="button contact_tel subwindow" href="bid_detail_tel.php?m={$machine.id}"
            onclick="ga('send', 'event', 'bid_contact', 'detail_tel_middle');">
            <i class="fas fa-phone"></i> 電話で問い合わせ
          </a>

          {*
            <div class="tel_label">お問い合わせTEL</div>
            <div class="contact_tel">{$company.contact_tel|escape|replace:',':",<br />" nofilter}</div>
            *}

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

                {if $sm.id == $machineId }
                  {continue}
                {/if}
                <div class="same_machine bid">
                  <a href="bid_detail.php?m={$sm.id}&rec=machine"
                    onClick="ga('send', 'event', 'log_bid', 'rec_machine', '{$sm.id}', 1, true);">

                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />

                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />

                    {/if}
                    <div class="names">

                      {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>
                      {/if}

                      {if !empty($sm.model)}<div class="name">{$sm.model}</div>
                      {/if}

                      {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>
                      {/if}

                      {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>
                      {/if}
                    </div>
                    <div class="min_price">{$sm.min_price|number_format}円</div>
                  </a>
                </div>

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

      {*
        <div class="spec_area">

        {if !preg_match("/admin/", $smarty.server.REQUEST_URI)}

          {if in_array($bidOpen.status, array('bid'))}
                <p class="contents">
                  商品への入札は、全機連会員を通じて行うことができます。<br />
                  商品出品会社にフォーム・TELから問い合わせをしていただくか、<br />
                  最寄りの全機連会員に入札の依頼を行って下さい。
                </p>


          {elseif in_array($bidOpen.status, array('entry', 'margin'))}
                <p class="contents">
                  {$bidOpen.title}の下見期間は、{$bidOpen.preview_start_date}～です。<br /><br />
                  入札のご依頼は、下見期間中に行って下さい。
                </p>

          {else}
                <p class="contents">
                  {$bidOpen.title}は、終了しました。<br /><br />
                  たくさんのご利用ありがとうございました。<br />
                  次回のWeb入札会もご期待ください。<br />
                </p>

          {/if}

        {/if}

          <div class='contact_area'>

        {if !empty($company.contact_mail)}
                <a class="contact" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank"
                  onclick="ga('send', 'event', 'bid_contact', 'detail_middle');"
                  >お問い合せ</a>

        {/if}

            <div class="tel_label">お問い合わせTEL</div>
            <div class="contact_tel">{$company.contact_tel|escape|replace:',':",<br />" nofilter}</div>
          </div>
        </div>
        <br class="clear" />
      *}


      {if !empty($sameMachineList) && count($sameMachineList) > 1}
        <h2 class="same_machine_label">この商品と同じジャンルの商品はこちら</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>

              {foreach $sameMachineList as $sm}

                {if $sm.id == $machineId }
                  {continue}
                {/if}
                <div class="same_machine bid">
                  <a href="bid_detail.php?m={$sm.id}&same=1"
                    onClick="ga('send', 'event', 'log_bid', 'same', '{$sm.id}', 1, true);">

                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />

                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />

                    {/if}
                    <div class="names">
                      {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
                      {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
                      {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>{/if}
                      {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>{/if}
                    </div>
                    <div class="min_price">{$sm.min_price|number_format}円</div>
                  </a>
                </div>

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
                <div class="same_machine bid">
                  <a href="bid_detail.php?m={$sm.id}&others=1"
                    onClick="ga('send', 'event', 'log_bid', 'others', '{$sm.id}', 1, true);">

                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />

                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />

                    {/if}
                    <div class="names">

                      {if !empty($sm.name)}<div class="name">{$sm.name}</div>
                      {/if}

                      {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>
                      {/if}

                      {if !empty($sm.model)}<div class="name">{$sm.model}</div>
                      {/if}

                      {if !empty($sm.year)}<div class="company">{$sm.year}年式</div>
                      {/if}

                      {if !empty($sm.addr1)}<div class="company">{$sm.addr1}</div>
                      {/if}
                    </div>
                    <div class="min_price">{$sm.min_price|number_format}円</div>
                  </a>
                </div>

              {/foreach}
            </div>
          </div>

          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>

          {/if}
        </div>

      {/if}

      {*
        <div class="img_area">

        {if $machine.addr3}
            <h2 id="gmap_label">
              在庫場所のアクセスマップ
              <a class="map_link" href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14" target="_blank">大きな地図で見る</a>
            </h2>
            <div>
              <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
                src="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed&z=14"></iframe><br />
            </div>

        {/if}

        </div>
        <div class="spec_area">
          <h2 class="" id="company_area">出品会社情報</h2>
          <table class="spec">
            <tr class="">
              <th>会社名</th>
              <td>
                <a href='company_detail.php?c={$machine.company_id}'>{$company.company}</a>
                <a class="contact" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank">お問い合せ</a>
              </td>
            </tr>
            <tr class="">
              <th>住所</th>
              <td>
                〒
        {if preg_match('/([0-9]{3})([0-9]
          {4})/', $company.zip, $r)}{$r[1]}-{$r[2]}
        {else}{$company.zip}
        {/if}<br />
                 {$company.addr1} {$company.addr2} {$company.addr3}
              </td>
            </tr>

            <tr class="">
              <th>お問い合せTEL</th>
              <td>{$company.contact_tel}</td>
            </tr>
            <tr class="">
              <th>お問い合せFAX</th>
              <td>{$company.contact_fax}</td>
            </tr>

            <tr class="">
              <th>担当者</th>
              <td>{$company.officer}</td>
            </tr>

            <tr class='infos opening'>
              <th>営業時間</th>
              <td>{$company.infos.opening}</td>
            </tr>

            <tr class='infos holiday'>
              <th>定休日</th>
              <td>{$company.infos.holiday}</td>
            </tr>

            <tr class='infos license'>
              <th>古物免許</th>
              <td>{$company.infos.license}</td>
            </tr>

            <tr class='infos complex'>
              <th>所属団体</th>
              <td>{$company.treenames}</td>
            </tr>
          </table>
        </div>

        <br class="clear" />
        *}


      {if !empty($IPLogMachineList)}
        <h2 class="same_machine_label">最近チェックした入札会出品商品</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>

              {foreach $IPLogMachineList as $sm}
                <div class="same_machine bid">
                  <a href="bid_detail.php?m={$sm.id}&checked=1"
                    onClick="ga('send', 'event', 'log_bid', 'checked', '{$sm.id}', 1, true);">

                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />

                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />

                    {/if}
                    <div class="names">

                      {if !empty($sm.name)}<div class="name">{$sm.name}</div>
                      {/if}

                      {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>
                      {/if}

                      {if !empty($sm.model)}<div class="name">{$sm.model}</div>
                      {/if}

                      {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>
                      {/if}

                      {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>
                      {/if}
                      <div class="min_price">{$sm.min_price|number_format}円</div>
                    </div>
                  </a>
                </div>

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
        {*
          <div class="tel_label">お問い合わせTEL</div>
          <div class="contact_tel">{$company.contact_tel|escape|replace:',':",<br />" nofilter}</div>
          *}
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

    <iframe class="mnok_ads" src="https://www.mnok.net/products/ads?keywords=中古&res=machinelife_bid"
      scrolling="no"></iframe>
  {/if}

{/block}