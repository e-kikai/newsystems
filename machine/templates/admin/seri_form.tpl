{extends file='include/layout.tpl'}

{block 'header'}

  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}bid_mylist.css" rel="stylesheet" type="text/css" />

  <script type="text/JavaScript">
    {literal}
    $(function() {
        //フォーカスを得たとき
        $("input.seri_price").focus(function() {
            // カンマを消す
            this.value = this.value.replace(/,/g,"") ;
            if (this.value == '0') { this.value = ""; }
        });

        // フォーカスを失ったとき
        $("input.seri_price").blur(function() {
            this.value = this.value.replace(/,/g,"") ;

            // 整数に変換したのち文字列に戻す。この時点で数字とマイナス記号だけが残る
            var num = "" + parseInt(this.value) ;

            //正規表現で桁区切りするための良く見かける関数的な何か
            num = cjf.numberFormat(num);

            //numに入っている値が数値じゃないときは""とする
            if (isNaN(parseInt(num))) num = "" ;

            //桁区切りした結果（変数 num）でテキストボックスの中身を書き換える
            this.value = num ;
        });

        //// 企業間売り切り出品処理 ////
        $('button.set_seri_price').click(function() {
            var $_self = $(this);
            var $_parent = $_self.closest('tr');

            var seri_price = parseInt($_parent.find("input.seri_price").val().replace(/,/g,"")) || null;

            var data = {
                'bid_open_id' :$('input.bid_open_id').val(),
                'bid_machine_id': $.trim($_self.val()),
                'seri_price': seri_price,
            };

            //// 入力のチェック ////
            var e = '';
            if (seri_price) {
                if(seri_price % $("input.rate").val()) {
                    e += "企業間売り切り価格は" + $("input.rate").val() + "円単位で入力してください。\n";
                }
                if(seri_price < $("input.min_price").val()) {
                    e += "企業間売り切り価格が、入札会の最低金額(" + cjf.numberFormat($("input.min_price").val()) + "円)未満になっています。\n";
                }
            }

            // エラー表示
            if (e != '') { alert(e); return false; }

            // 送信確認
            var mes = 'No. ' + $.trim($_parent.find('td.bid_machine_id').text()) + ' ' + $.trim($_parent.find('td.name').text()) + ' ';
            mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n";

            if (seri_price) {
              mes += "企業間売り切り価格 :" + cjf.numberFormat(seri_price) + "円\n\n";
              mes += "この商品を企業間売り切りに出品します。よろしいですか。";
            } else {
              mes += "この商品の企業間売り切りに出品をキャンセルします。よろしいですか。";
            }

            if (!confirm(mes)) { return false; }

            $_self.prop("disabled", true);

            $.post('/admin/ajax/seri.php', {
                'target': 'member',
                'action': 'set_seri_price',
                'data'  : data,
            }, function(res) {
                if (res != 'success') {
                    $_self.removeAttr('disabled');
                    alert(res);
                } else {
                    if (seri_price) {
                        alert('企業間売り切りに商品を出品しました。');
                    } else {
                        alert('企業間売り切り出品をキャンセルしました。');
                    }
                }

                $_self.prop("disabled", false);
                return false;
            }, 'text');

            return false;
        });

        //// 即決落札処理 ////
        $('button.prompt').click(function() {
            var $_self = $(this);
            var $_parent = $_self.closest('tr');

            var data = {
                'bid_open_id' :$('input.bid_open_id').val(),
                'bid_machine_id': $.trim($_self.val()),
            };

            if (!$_parent.find('.seri_amount').html()) {
                alert("この商品には、まだ入札がありません。");
                return false;
            }

            // 送信確認
            var mes = 'No. ' + $.trim($_parent.find('td.bid_machine_id').text()) + ' ' + $.trim($_parent.find('td.name').text()) + ' ';
            mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n\n";
            mes += "現在の最高入札額(" + cjf.numberFormat($_parent.find('.seri_amount').val()) + "円)で即決落札します。よろしいですか。\n\n";
            mes += "※ 即決落札は、キャンセルできません。ご注意ください。";

            if (!confirm(mes)) { return false; }

            $_self.prop("disabled", true);

            $.post('/admin/ajax/seri.php', {
                'target': 'member',
                'action': 'prompt',
                'data'  : data,
            }, function(res) {
                if (res != 'success') {
                    $_self.prop("disabled", false);
                    alert(res);
                } else {
                    alert('即決落札処理が完了しました。');
                }

                return false;
            }, 'text');

            return false;
        });

        //// テーブルスクロール ////
        $(window).resize(function() {
            $('div.table_area').css('height', $(window).height() - 270);
        }).triggerHandler('resize');

        $('div.table_area').scroll(function() {
            $(window).triggerHandler('scroll');
        });

        //// 2秒毎にリロード ////
        if ($("input.realtime").val()) {
            setInterval(function() {
                $.get('/admin/ajax/seri.php', {
                    'target': 'member',
                    'action': 'getResult',
                    'data'  : { bidOpenId : $('.bid_open_id').val() },
                }, function(data) {
                    try {
                        if (data == "notrealtime") { location.reload(); }

                        var d = $.parseJSON(data);
                        $.each(d, function(i, m) {
                            var $_m = $('.bid_machine_id_' + m['id']);
                            if (!$_m) { return true; }

                            // 入札内容の表示
                            if (m['seri_amount']) {
                                $_m.find('.seri_amount').html(cjf.numberFormat(m['seri_amount']) + "円");
                                $_m.find('.seri_count').html(cjf.numberFormat(m['seri_count']));
                                $_m.find('.seri_company').html(m['seri_company']);

                                // 落札可否の表示
                                if (m['seri_result'] == true) {
                                    $_m.find('button.prompt').hide();
                                    $_m.find('span.bidoff').show();
                                } else {
                                    $_m.find('button.prompt').show();
                                    $_m.find('span.bidoff').hide();
                                }
                            }
                        });
                    } catch (e) { console.log(data); }

                     return false;
                }, 'text');

                return false;
            }, 2000);
        }
    });
    </script>
    <style type="text/css">
      table.list .company {
        width: 80px;
      }

      table th.status {
        width: 100px;
      }

      table td.status {
        width: 100px;
      }

      table th.num {
        width: 50px;
      }

      table td.num {
        text-align: right;
        width: 50px;
      }

      button.prompt {
        width: 60px;
        background-color: #080;
      }

      button.set_seri_price {
        width: 120px;
        background-color: #080;
      }

      button.prompt:hover,
      button.set_seri_price:hover {
        background-color: #F60;
      }

      fieldset.search {
        width: 450px;
        float: right;
      }

      .seri_date {
        width: 450px;
        float: left;
        font-size: 20px;
        height: 52px;
        line-height: 52px;
      }

      .bidoff {
        color: red;
        font-weight: bold;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  {if strtotime($bidOpen.entry_start_date) <= time() && strtotime($bidOpen.seri_start_date) > time() }
    <div class="seri_date">
      出品期間 : {$bidOpen.entry_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$bidOpen.seri_start_date|date_format:'%m/%d %H:%M'}
    </div>
  {else}
    <div class="seri_date">
      {if $bidOpen.seri_start_date|date_format:'%Y/%m/%d' == $bidOpen.seri_end_date|date_format:'%Y/%m/%d'}
        開催期間 : {$bidOpen.seri_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$bidOpen.seri_end_date|date_format:'%H:%M'}
      {else}
        開催期間 : {$bidOpen.seri_start_date|date_format:'%Y/%m/%d %H:%M'} ～ {$bidOpen.seri_end_date|date_format:'%m/%d %H:%M'}
      {/if}
    </div>

    <fieldset class="search">
      <legend>検索</legend>
      <form method="GET" id="seri_list_form">
        <input type="hidden" name="o" value="{$bidOpenId}" />

        {html_radios name='result' options=["" => "すべて", "notbidoff" => "未落札", "bidoff" => "落札済"] selected=$result separator=' ' onchange="this.form.submit();"}
      </form>
    </fieldset>
  {/if}

  <br clear="both" />

  {if empty($bidMachineList)}
    <div class="error_mes">入札会に登録している商品情報はありません</div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  <input type="hidden" class="bid_open_id" value="{$bidOpen.id}" />
  <input type="hidden" class="rate" value="{$bidOpen.rate}" />
  <input type="hidden" class="min_price" value="{$bidOpen.min_price}" />
  {if strtotime($bidOpen.seri_start_date) <= time() && strtotime($bidOpen.seri_end_date) > time() }
    <input type="hidden" class="realtime" value="1" />
  {/if}

  <div class="table_area">
    {foreach $bidMachineList as $m}
      {if $m@first}
        <table class="machines list">
          <tr>
            <th class="img"></th>
            <th class="bid_machine_id">出品番号</th>
            <th class="name">機械名</th>
            <th class="maker">メーカー</th>
            <th class="model">型式</th>
            <th class="min_price">最低入札金額</th>

            {if strtotime($bidOpen.entry_start_date) <= time() && strtotime($bidOpen.seri_start_date) > time() }
              <th class="sepa2">企業間売り切り出品</th>
            {elseif strtotime($bidOpen.seri_start_date) <= time() }
              <th class="sepa2 min_price">売り切り価格</th>
              <th class="num">入札数</th>
              <th class="company">最高入札会社</th>
              <th class="min_price">最高入札額</th>
              <th class="status">落札</th>
            {/if}

            {if strtotime($bidOpen.seri_end_date) <= time() }
              <th class="company">落札会社</th>
              <th class="min_price sepa2">落札金額</th>
            {/if}
          </tr>
        {/if}

        <tr class="bid_machine_id_{$m.id}{if !empty($seri_result)} result{/if}">
          <td class="img">
            {if !empty($m.top_img)}
              <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
              <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
            {/if}
          </td>
          <td class="bid_machine_id">{$m.list_no}</td>
          <td class="name">
            {$m.name}
          </td>
          <td class="maker">{$m.maker}</td>
          <td class="model">{$m.model}</td>
          <td class="min_price">{$m.min_price|number_format}円</td>

          {if strtotime($bidOpen.entry_start_date) <= time() && strtotime($bidOpen.seri_start_date) > time() }
            <td class="sepa2">
              <input type="text" class="min_price number seri_price" value="{$m.seri_price}" placeholder="金額(数字で入力)" /> 円
              <button class="set_seri_price" value="{$m.id}">売り切り出品</button>
            </td>
          {elseif strtotime($bidOpen.seri_start_date) <= time() }
            <td class="sepa2 min_price">
              {$m.seri_price|number_format}円
            </td>

            <td class="seri_count num">{$m.seri_count|number_format}</td>
            <td class="seri_company company">{$m.seri_company}</td>
            <td class="seri_amount min_price">
              {if !empty($m.seri_amount)}
                {$m.seri_amount|number_format}円
              {/if}
            </td>
            <td class="status">
              {if !empty($m.seri_result)}
                <span class="bidoff">落札</span>
              {elseif !empty($m.seri_amount) && strtotime($bidOpen.seri_start_date) <= time() && strtotime($bidOpen.seri_end_date) > time() }
                <button class="prompt" value="{$m.id}">即決</button>
                <span class="bidoff" style="display:none;">落札</span>
              {else}
                <button class="prompt" value="{$m.id}" style="display:none;">即決</button>
                <span class="bidoff" style="display:none;">落札</span>
              {/if}
            </td>
          {/if}

          {if strtotime($bidOpen.seri_end_date) <= time() }
            {if !empty($m.seri_result)}
              <td class="company">{$m.seri_company}</td>
              <td class="min_price">{$m.seri_amount|number_format}円</td>
            {else}
              <td class="company"></td>
              <td class="min_price"></td>
            {/if}
          {/if}
        </tr>

        {if $m@last}
          {if strtotime($bidOpen.seri_end_date) <= time() }
            <tr>
              <td class="blank" colspan="11"></td>
              <th>支払合計金額</th>
              <td class="min_price sepa">{$seriSum|number_format}円</td>
            </tr>
          {/if}
        </table>
      {/if}

    {/foreach}
  </div>

  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}