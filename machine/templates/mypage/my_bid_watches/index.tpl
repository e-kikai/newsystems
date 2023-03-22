{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 削除処理 ///
        $('button.delete').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          // 送信確認
          var mes = "出品番号 : " + $.trim($_parent.find('td.list_no').text()) + "\n";
          mes += $.trim($_parent.find('td.name').text()) + " ";
          mes += $.trim($_parent.find('td.maker').text()) + " " + $.trim($_parent.find('td.model').text());
          mes += "\nこのウォッチを解除します。よろしいですか。"
          if (!confirm(mes)) { return false; }

          // $_self.attr('disabled', 'disabled');

          return true;
        });

        /// 入札処理 ///
        $('form.bid_form').on("submit", function() {

          // データ取得
          var bid_machine_id = $(this).find('input.bid_machine_id').val();
          var amount = string2int($(this).find('input.amount').change().val());
          var comment = $(this).find('input.comment').val();

          var min_price = $(this).find('input.min_price').val();
          var rate = $(this).find('input.rate').val();

          var data = {
            'bid_machine_id': bid_machine_id,
            'amount': amount,
            'comment': comment,
          };

          /// 入力のチェック ///
          var e = '';

          if (!data['amount']) {
            e += '◆ 入札金額が入力されていません\n';
          } else if (data['amount'] < parseInt(min_price)) {
            e += "◆ 入札金額が、最低入札金額より小さく入力されています。\n";
            e += "最低入札金額 : " + cjf.numberFormat(min_price) + '円';
          } else if ((data['amount'] % parseInt(rate)) != 0) {
            e += '◆ 入札金額が、' + cjf.numberFormat(rate) + '円単位ではありません。\n';
          }

          /// エラー表示 ///
          if (e != '') { alert(e); return false; }

          /// 送信確認 ///
          var mes = "最低入札金額 : " + cjf.numberFormat(min_price) + '円\n';
          mes += "入札金額 : " + cjf.numberFormat(data['amount']) + '円\n\n';

          if (data['amount'] > parseInt(min_price) * 5) {
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

        function string2int(amount) {
          return parseInt(mb_convert_kana(amount, 'KVrn').replace(/[^0-9.]/g, ''));
        }
      });
    </script>
    <style type="text/css">
      th.delete,
      td.delete {
        width: 40px;
      }

      th.contact,
      td.contact {
        width: 82px;
      }

      th.bid,
      td.bid {
        width: 82px;
      }

      th.addr_1,
      td.addr_1 {
        width: 70px;
      }

      table.spec th {
        padding: 8px;
      }

      table.spec td {
        padding: 8px;
      }

      table.spec input.amount {
        font-size: 18px;
        width: 140px;
        display: inline-block;
        margin-right: 4px;
      }

      span.required {
        color: #ee0;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  {if empty(count($my_bid_watches))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-star"></i> まだ、ウォッチリストに登録がありません。
    </div>
  {/if}

  <div class="table_area">
    <table class='table table-hover table-condensed table-striped'>

      {foreach $my_bid_watches as $mw}
        {if $mw@first}
          <tr>
            <th class="list_no">出品番号</th>
            <th class="img"></th>
            {*
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            *}
            <th class="full_name_02">機械名/メーカー/型式</th>
            {*
            <th class="year">年式</th>
            *}

            <th class="addr_1">都道府県</th>
            <th class="company">出品会社</th>
            <th class="contact">問い合せ</th>
            <th class="min_price">最低入札金額</th>

            {if $bid_open.status == 'bid'}
              <th class="bid">入札</th>
              <th class="created_at">ウォッチ日時</th>
              <th class="delete">解除</th>
            {/if}
            {if in_array($bid_open.status, array('carryout', 'after'))}
              <th class="created_at_min">入札日時</th>
              <th class="min_price border-start">落札金額</th>
              <th class="same_count">入札<br />件数</th>
            {/if}
          </tr>
        {/if}

        <tr {if !empty($mw.deleted_at)} class="deleted" {/if}>
          <td class="list_no fs-5 text-center">{$mw.list_no}</td>
          <td class="img">
            {if !empty($mw.top_img)}
              <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">
                <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$mw.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$mw.top_img}" alt='PDF' /></noscript>
              </a>
            {/if}
          </td>
          {*
          <td class="name">
            <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">{$mw.name}</a>
          </td>
          <td class="maker">{$mw.maker}</td>
          <td class="model">{$mw.model}</td>
          *}
          <td class="full_name_02">
            <a href="/bid_detail.php?m={$mw.bid_machine_id}" target="_blank">{$mw.name} {$mw.maker} {$mw.model}</a>
          </td>
          {*
          <td class="year">{$mw.year}</td>
          *}

          <td class="addr_1">{$mw.addr1}</td>

          <td class="company">
            {if !empty($mw.company)}
              <a href="company_detail.php?c={$mw.company_id}" target="_blank">
                {'/(株式|有限|合.)会社/'|preg_replace:'':$mw.company}
              </a>
            {/if}
          </td>

          <td class="contact">
            <a href="/contact.php?o={$bid_open_id}&bm={$mw.bid_machine_id}" target="_blank" class=" btn btn-warning btn-sm">
              <i class="fas fa-paper-plane"></i> 問合
            </a>
          </td>

          <td class="min_price text-right">{$mw.min_price|number_format}円</td>

          {if $bid_open.status == 'bid'}
            <td class="bid">
              <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#exampleModal_{$mw.id}">
                <i class="fas fa-pen-to-square"></i> 入札
              </button>

              {* Modal *}
              <div class="modal fade " id="exampleModal_{$mw.id}" tabindex="-1" aria-labelledby="exampleModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-lg">
                  <div class="modal-content">
                    <div class="modal-header">
                      <h5 class="modal-title" id="exampleModalLabel">{$mw.name} {$mw.maker} {$mw.model} に入札する</h5>

                      <button type="button" class="btn btn-link btn-lg" data-bs-dismiss="modal">
                        <i class="fas fa-xmark"></i>
                      </button>
                    </div>
                    <form method="post" action="/mypage/my_bid_bids/create_do.php" class="bid_form">
                      <div class="modal-body">
                        <input type="hidden" class="min_price" value="{$mw.min_price}" />
                        <input type="hidden" class="rate" value="{$bid_open.rate}" />
                        <input type="hidden" class="bid_open_id" value="{$bid_open.id}" />
                        <input type="hidden" name="id" class="bid_machine_id" value="{$mw.bid_machine_id}" />
                        <input type="hidden" name="r" class="r" value="watch" />

                        <table class="form spec w-75">
                          <tr class="bid">
                            <th>出品番号</th>
                            <td class="">{$mw.list_no}</td>
                          </tr>
                          <tr class="bid">
                            <th>商品名</th>
                            <td class="">{$mw.name} {$mw.maker} {$mw.model}</td>
                          </tr>
                          <tr class="bid">
                            <th>出品会社</th>
                            <td class="">{'/(株式|有限|合.)会社/'|preg_replace:'':$mw.company}</td>
                          </tr>
                          <tr class="bid">
                            <th>最低入札金額</th>
                            <td class="text-right">{$mw.min_price|number_format}円</td>
                          </tr>
                          <tr class="bid">
                            <th>入札金額 <span class="required">(必須)</span></th>
                            <td>
                              <input type="text" name="amount" class="number amount form-control" required />円<br />
                              入札金額は、{$bid_open.rate|number_format}円単位で行えます。
                            </td>
                          </tr>
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
                      </div>

                    </form>
                  </div>
                </div>
              </div>

            </td>

            <td class="created_at">{$mw.created_at|date_format:'%m/%d %H:%M:%S'}</td>

            <td class='delete text-center'>
              {if !empty($mw.deleted_at)}
                取消済
              {else}
                <form method="post" action="/mypage/my_bid_watches/delete_do.php">
                  <input type="hidden" name="id" value="{$mw.bid_machine_id}" />
                  <input type="hidden" name="o" value="{$bid_open.id}" />

                  <button class="delete btn btn-outline-danger" value="{$mw.bid_machine_id}">
                    <i class="fas fa-circle-minus"></i>
                  </button>
                </form>
              {/if}
            </td>
          {/if}

          {if in_array($bid_open.status, array('carryout', 'after'))}
            <td class="created_at_min">{$mw.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
            <td class="min_price border-start">
              {if !empty($bids_result[$mw.bid_machine_id])}
                {$bids_result[$mw.bid_machine_id].amount|number_format}円
                {if $bids_result[$mw.bid_machine_id].same_count > 1}
                  <br />
                  (同額:{$bids_result[$mw.bid_machine_id].same_count})
                {/if}
              {/if}
            </td>
            <td class="same_count">
              {if !empty($bids_count[$mw.bid_machine_id])}
                {$bids_count[$mw.bid_machine_id]|number_format}
              {/if}
            </td>
          {/if}
        </tr>
      {/foreach}
    </table>
  </div>

  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/bid_door.php?o={$bid_open.id}" class="btn btn-outline-secondary" target="_blank">
      <i class="fas fa-magnifying-glass"></i> 商品をさがす - Web入札会トップページ
    </a>
    <a href="/mypage/" class="btn btn-outline-secondary">
      <i class="fas fa-house"></i> マイページ トップに戻る
    </a>
  </div>
{/block}