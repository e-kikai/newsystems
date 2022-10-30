{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="description" content="
{if !empty({$machine.capacity}) && !empty({$machine.capacity_label})}{$machine.capacity_label}:{$machine.capacity}{$machine.capacity_unit} | {/if}
{if !empty({$machine.year})}年式:{$machine.year} | {/if}
{if !empty({$machine.addr1})}在庫場所:{$machine.addr1} | {/if}
{if !empty({$others})}{$others} | {/if}
{$machine.spec}
{if $machine.commission == 1} 試運転可{/if}
" />
  <meta name="keywords"
    content="{$machine.name},{$machine.hint},{$machine.maker},{$machine.model},{$machine.company},{$machine.addr1},中古機械,全機連,マシンライフ" />

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}detail.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}detail.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
  <link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
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
            if (!confirm("入札金額が最低入札金額の5倍を超えています。\nこの内容で入札してよろしいですか。")) { return false; }
          }

          $('button.bid').attr('disabled', 'disabled').text('保存処理中');

          $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'bid',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $('button.bid').removeAttr('disabled').text('入札');
              alert(res);
              return false;
            }

            // 登録完了
            alert('入札が完了しました');
            location.href = '/admin/bid_list.php?o=' + $('input.bid_open_id').val();
            return false;
          }, 'text');

          return false;
        });

        //// 数値のみに自動整形 ////
        $('input.number').change(function() {
          var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9.]/g, '');
          $(this).val(price ? parseInt(price) : '');
        });
      });
    </script>
    <style type="text/css">
      .others {
        display: inline-block;
      }

      table.spec.form {
        width: 442px;
      }

      table.spec.form th {
        background: #556B2F;
        width: 118px;
      }

      a.contact {
        margin-left: 16px;
      }

      table.form td {
        position: relative;
      }

      button.bid {
        display: block;
        width: 140px;
        font-size: 15px;
        margin: 4px auto;
      }

      table.form td input.amount {
        font-size: 18px;
        width: 140px;
      }
    </style>
  {/literal}
{/block}

{block name='main'}
  {if !empty($machine)}
    <div class='detail_container'>
      {*** 画像 ***}
      <div class="img_area">
        {if empty($machine.top_img) && empty($machine.imgs)}
          <img class='noimage' src='./imgs/noimage.png' alt="{$alt}" />
        {else}
          <div class='top_image'>
            <div id='viewport'>
              {if !empty($machine.top_img)}
                <a class="zoom" href="{$_conf.media_dir}machine/{$machine.top_img}">
                  <img class="zoom_img" src="{$_conf.media_dir}machine/{$machine.top_img}" alt="{$alt}" />
                </a>
              {/if}
            </div>
          </div>

          <div class='images'>
            {if !empty($machine.imgs) || (!empty($machine.youtube) && preg_match("/http:\/\/youtu.be\/(.+)/", $machine.youtube, $res))}
              {if !empty($machine.top_img)}
                <a class="img" href='{$_conf.media_dir}machine/{$machine.top_img}' {*
          rel="{literal}{{/literal}
            gallery:'gal1',
            smallimage:'{$_conf.site_uri}{$_conf.media_dir}machine/{$machine.top_img}',
            largeimage:'{$_conf.site_uri}{$_conf.media_dir}machine/{$machine.top_img}'
          {literal}}{/literal}"
          *}>
                  <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="{$alt}" />
                </a>
              {/if}

              {foreach $machine.imgs as $i}
                <a class="img" href='{$_conf.media_dir}machine/{$i}' {*
          rel="{literal}{{/literal}
            gallery:'gal1',
            smallimage:'{$_conf.media_dir}machine/{$i}',
            largeimage:'{$_conf.media_dir}machine/{$i}'
          {literal}}{/literal}"
          *}>
                  <img src="{$_conf.media_dir}machine/thumb_{$i}" alt="{$alt}" />
                </a>
              {/foreach}
            {/if}

            {if !empty($machine.youtube) && preg_match("/http:\/\/youtu.be\/(.+)/", $machine.youtube, $res)}
              <a href="javascript:void(0)" data-youtubeid="{$res[1]}" class="movie" title="クリックで動画再生します"><img
                  src="imgs/youtube_icon_48.png" /></a>
            {/if}
          </div>
        {/if}

        {*** youtube ***}
        {if !empty($machine.youtube) && preg_match("/http:\/\/youtu.be\/(.+)/", $machine.youtube, $res)}
          <div class="youtube">
            <iframe width="400" height="300" src="https://www.youtube.com/embed/{$res[1]}?rel=0" frameborder="0"
              allowfullscreen></iframe>
          </div>
        {/if}

      </div>

      <div class="spec_area">
        {*
    {include "include/bid_announce.tpl"}
  *}

        {*
    <table class='machine'>
      <tr>
        <th class="no">出品番号</th>
        <th class='name'>機械名</th>
        <th class='maker'>メーカー</th>
        <th class='model'>型式</th>
        <th class='year'>年式</th>
      </tr>
      <tr class='machine machine_{$machine.id}'>
        <td class='bid_machine_id'>{$machine.list_no}</td>
        <td class='name'>{$machine.name}</td>
        <td class='maker'>{$machine.maker}</td>
        <td class='model'>{$machine.model}</td>
        <td class='year'>{$machine.year}</td>
      </tr>
    </table>
    *}

        <table class="spec">
          <tr class="price">
            <th>最低入札金額</th>
            <td class="detail_min_price">{$machine.min_price|number_format}円</td>
          </tr>
          <tr class="">
            <th>入札締切日時</th>
            <td class="">{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</td>
          </tr>
        </table>

        <table class="spec">
          <tr class="">
            <th>出品番号</th>
            <td class="bid_machine_id">{$machine.list_no}</td>
          </tr>
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
        </table>

        <table class="spec">
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
            <th>在庫場所</th>
            <td class='location'>
              {$machine.addr1} {$machine.addr2} {$machine.addr3}
              {if $machine.location}<br />({$machine.location}){/if}
              {if $machine.addr3}
                <button class="accessmap" src="{$smarty.server.REQUEST_URI}#gmap2">MAP</button>
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
        <h2>出品商品についてのお問い合せ</h2>
        <p class="contents">
          お問い合せフォーム、TEL、FAXより、出品会社へお問い合せください。
        </p>
        <div class='contact_area'>
          {if !empty($company.contact_mail)}
            {*
        <a class="contact_link" href="contact.php?c={$machine.company_id}&b=1&o={$bidOpenId}&bm={$machine.id}" target="_blank"><img src='./imgs/contact_button.png' /></a>
        *}
            <a class="contact_link" href="contact.php?o={$bidOpenId}&bm={$machine.id}" target="_blank"><img
                src='./imgs/contact_button.png' /></a>
          {/if}
          {if !empty($company.contact_tel)}<div class='tel'>TEL : {$company.contact_tel}</div>{/if}
          {if !empty($company.contact_fax)}<div class='fax'>FAX : {$company.contact_fax}</div>{/if}
        </div>
      </div>

      <div class="spec_area">
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
              <td>{if !empty($result.amount)}{$result.amount|number_format}円{else}入札なし{/if}</td>
            </tr>
            <tr class="">
              <th>落札会社</th>
              <td>{$result.company}</td>
            </tr>
            <tr class="">
              <th>同額札</th>
              <td>{if $result.same_count > 1}あり{/if}</td>
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
                <td>{if $result.bid_id == $resultCompany.bid_id}◯{else}×{/if}</td>
              </tr>
            </table>
          {/if}
        {else}
          <h2>入札</h2>
          <p class="contents">下見・入札期間の開始前です。</p>
        {/if}


        {*
    {if $machine.addr3}
    <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
      src="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
    <a href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m" style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
    {/if}
    *}
      </div>
      <br class="clear" />

      <div class="img_area">
        {if $machine.addr3}
          <h2 id="gmap_label">
            在庫場所のアクセスマップ
            <a class="map_link"
              href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
              target="_blank">大きな地図で見る</a>
          </h2>
          <div>
            <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
              src="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed&z=14"></iframe><br />
          </div>
        {/if}

      </div>
      <div class="spec_area">
        <h2>出品会社情報</h2>
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
              〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}<br />
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
    </div>
  {else}
    <div class="error_mes">
      指定された方法では、入札会商品情報の特定ができませんでした<br />
      誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
    </div>
  {/if}

{/block}