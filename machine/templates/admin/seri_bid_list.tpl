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

    //// 売り切り出品処理 ////
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
                e += "売り切り価格は" + $("input.rate").val() + "円単位で入力してください。\n";
            }
            if(seri_price < $("input.min_price").val()) {
                e += "売り切り価格が、入札会の最低金額(" + cjf.numberFormat($("input.min_price").val()) + "円)未満になっています。\n";
            }
        }

        // エラー表示
        if (e != '') { alert(e); return false; }

        // 送信確認
        var mes = 'No. ' + $.trim($_parent.find('td.bid_machine_id').text()) + ' ' + $.trim($_parent.find('td.name').text()) + ' ';
        mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n";

        if (seri_price) {
          mes += "売り切り価格 :" + cjf.numberFormat(seri_price) + "円\n\n";
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


    //// テーブルスクロール ////
    $(window).resize(function() {
        $('div.table_area').css('height', $(window).height() - 270);
    }).triggerHandler('resize');

    $('div.table_area').scroll(function() {
        $(window).triggerHandler('scroll');
    });
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

{if empty($seriBidList)}
  <div class="error_mes">落札商品情報はありません</div>
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
{foreach $seriBidList as $m}
  {if $m@first}
    <table class="machines list">
      <tr>
        <th class="img"></th>
        <th class="bid_machine_id">出品番号</th>
        <th class="name">機械名</th>
        <th class="maker">メーカー</th>
        <th class="model">型式</th>
        <th class="min_price">最低入札金額</th>
        <th class="company sepa2">出品会社</th>
        <th class="min_price">落札金額</th>
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
    <td class="name">{$m.name}</td>
    <td class="maker">{$m.maker}</td>
    <td class="model">{$m.model}</td>
    <td class="min_price">{$m.min_price|number_format}円</td>

    <td class="company sepa2">{$m.company}</td>
    <td class="min_price">{$m.seri_amount|number_format}円</td>
  </tr>

  {if $m@last}
    {if strtotime($bidOpen.seri_end_date) <= time() }
      <tr>
        <td class="blank" colspan="6"></td>
        <th>請求合計金額</th>
        <td class="min_price">{$seriBidSum|number_format}円</td>
      </tr>
      <tr>
        <td class="blank" colspan="6"></td>
        <th>消費税 : {$bidOpen.tax|number_format}%</th>
        <td class="min_price">{$seriTax|number_format}円</td>
      </tr>
      <tr>
        <td class="blank" colspan="6"></td>
        <th>落札請求額</th>
        <td class="min_price">{$seriFinalSum|number_format}円</td>
      </tr>    {/if}
    </table>
  {/if}

{/foreach}
</div>

{*** ページャ ***}
{include file="include/pager.tpl"}

{/block}
