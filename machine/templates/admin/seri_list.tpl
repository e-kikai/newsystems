{extends file='include/layout.tpl'}

{block 'header'}

<script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}bid_mylist.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
    //フォーカスを得たとき
    $("input.number").focus(function() {
        // カンマを消す
        this.value = this.value.replace(/,/g,"") ;
        if (this.value == '0') { this.value = ""; }
    });

    // フォーカスを失ったとき
    $("input.number").blur(function() {
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

    //// 削除処理 ////
    $('button.bid').click(function() {
        var $_self = $(this);
        var $_parent = $_self.closest('.seri_area');

        var amount = parseInt($_parent.find("input.amount").val().replace(/,/g,""));

        var data = {
            'bid_machine_id': $.trim($_parent.find("input.bid_machine_id").val()),
            'amount': amount,
        };

        //// 入力のチェック ////
        var e = '';
        if (!amount) {
            e += "入札金額が入力されていません。\n";
        }
        if(amount <= $_parent.find(".seri_amount").val()) {
            e += "入札金額が、現在の最高入札金額より低く入力されています。\n";
        }
        if(amount % $("input.rate").val()) {
            e += "入札金額は" + $("input.rate").val() + "円単位で入力してください。\n";
        }
        if(amount < $("input.min_price").val()) {
            e += "入札金額が、入札会の最低金額(" + cjf.numberFormat($("input.min_price").val()) + "円)未満になっています。\n";
        }

        // エラー表示
        if (e != '') { alert(e); return false; }

        // 送信確認
        var mes = $.trim($_parent.find('.list_no').text()) + ' ' + $.trim($_parent.find('td.name').text()) + ' ';
        mes += $_parent.find('a.name_link').text() + "\n";
        mes += "入札金額 : " + cjf.numberFormat(amount) + "円\n\n";

        mes += "この入札を行います。よろしいですか。\n\n";
        mes += "※ 落札の可否は入札後に判明します。\n";
        mes += "※ 企業間売り切りの入札は、キャンセルできません。ご注意ください。";
        if (!confirm(mes)) { return false; }

        $_self.prop("disabled", true);

        $.post('/admin/ajax/seri.php', {
            'target': 'member',
            'action': 'bid',
            'data'  : data,
        }, function(res) {
            if (res == 'success') {
                alert('おめでとうございます。落札できました。');
            } else if (res == 'none') {
                alert('落札できませんでした。より高い金額で入札を行ってください。');
            } else {
                alert(res);
            }

            $_self.prop("disabled", false);
            return false;
        }, 'text');

        return false;
    });

    //// 2秒毎にリロード ////
    if ($("input.realtime").val()) {
        setInterval(function() {
            $.get('/admin/ajax/seri.php', {
                'target': 'member',
                'action': 'getResultList',
                'data'  : { bidOpenId : $('.bid_open_id').val() },
            }, function(data) {
                try {
                    if (data == "notrealtime") { location.reload(); }

                    var d = $.parseJSON(data);
                    $.each(d, function(i, m) {
                        var $_m = $('.bid_machine_id_' + m['id']);
                        if (!$_m) { return true; }

                        // 入札内容の表示
                        // 落札可否の表示
                        if (m['seri_result'] == true) {
                            $_m.find('.seri_form').hide();
                            if (m['my_bidoff'] == true) {
                                seri_mes = '<div class="bidoff">◎ 貴社が' + cjf.numberFormat(m['seri_amount']) + '円で落札いたしました</div>';
                            } else {
                                seri_mes = '<div class="bidoff">落札されました</div>';
                            }
                        } else {
                            if (m['seri_amount']) {
                                seri_mes = '現在の入札額 ' + cjf.numberFormat(m['seri_amount']) + '円 (' + cjf.numberFormat(m['seri_count']) + '件)';
                            } else {
                                seri_mes = 'まだ入札はありません';
                            }
                        }
                        $_m.find('.seri_display').html(seri_mes);
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

.seri_area {
  width: 224px;
  height: 290px;
  border: 1px dotted #333;
  padding: 3px;
  margin: 4px;
  float: left;
  background: #FFF;
  position: relative;
}

.img {
  width: 224px;
  height: 168px;
  display: block;
}

.img img {
  max-width: 220px;
  max-height: 168px;
  margin: auto;
  display: block;
}

.seri_area button.bid {
  background-color: #076AB6;
  width: 54px;
  margin-left: 8px;
}

.seri_area button.bid:hover {
  background-color: #F60;
}

hr {
  margin: 8px 0;
}

fieldset.search {
  width: 370px;
  float: right;
}

.result_area {
  margin-top: 8px;
}

.seri_date {
  width: 450px;
  float: left;
  font-size: 20px;
  height: 52px;
  line-height: 52px;

}

.seri_area .name_link,
.seri_area .addr1 {
  display: inline-block;
}

.seri_area .list_no {
  display: block;
  position: absolute;
  top: 8px;
  left: 8px;
  padding: 4px;
  background-color: rgba(255,255,255,0.75);
}

.seri_area .data_area {
  height: 52px;
}

.bidoff {
  color: red;
  font-weight: bold;
}

.seri_form {
  margin: 4px 0 0 4px;
}
</style>
{/literal}
{/block}

{block 'main'}

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

    <select class="region" name="r" onchange="this.form.submit();">
      <option value="">全国</option>
      {foreach $regionList as $r}
        <option value="{$r.region}" class="region" {if $q.region == $r.region} selected="selected"{/if}>
          {$r.region} ({$r.count})
        </option>
      {/foreach}
    </select>

    <select class="large_genre_id" name="l" onchange="this.form.submit();">
      <option value="">すべてのジャンル</option>
      {foreach $xlGenreList as $x}
        <optgroup label="{$x.xl_genre}" />
          {foreach $largeGenreList as $l}
            {if $l.xl_genre_id == $x.id}
              <option value="{$l.id}" class="large_genre" {if $q.large_genre_id==$l.id} selected="selected"{/if}>
                {$l.large_genre} ({$l.count})
              </option>
            {/if}
          {/foreach}
        </optgroup>
      {/foreach}
    </select>

    <div class="result_area">
      {html_radios name='result' options=["" => "すべて", "notbidoff" => "未落札", "bidoff" => "落札済", "mybid" => "自社入札"] selected=$result separator=' ' onchange="this.form.submit();"}
    </div>
  </form>

</fieldset>
<br clear="both" />

<div class="special_area">
  <input type="hidden" class="bid_open_id" value="{$bidOpen.id}" />
  <input type="hidden" class="rate" value="{$bidOpen.rate}" />
  <input type="hidden" class="min_price" value="{$bidOpen.min_price}" />
  {if strtotime($bidOpen.seri_start_date) <= time() && strtotime($bidOpen.seri_end_date) > time() }
    <input type="hidden" class="realtime" value="1" />
  {/if}

  {foreach $bidMachineList as $m}
    <div class="seri_area bid_machine_id_{$m.id}">
      <input type="hidden" class="bid_machine_id" value="{$m.id}" />
      <input type="hidden" class="seri_amount" value="{$m.seri_amount}" />

      <div class="img">
        {if !empty($m.top_img)}
          <img class="lazy" src='imgs/blank.png' data-original="http://www.zenkiren.net/media/machine/{$m.top_img}" alt='' />
          <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" /></noscript>
        {/if}
      </div>
      <div class="data_area">
        <div class="list_no">No. {$m.list_no}</div>
        <a href="/admin/bid_detail.php?m={$m.id}" class="name_link" target="_blank">{$m.name} {$m.maker} {$m.model}</a>
        <div class="addr1">{$m.addr1}</div>
      </div>

      <hr />

      <div class="seri_display">
        {if $m.seri_result}
          {if $m.my_bidoff}
            <div class="bidoff">◎ 貴社が{$m.seri_amount|number_format}円で落札いたしました</div>
          {else}
            <div class="bidoff">落札されました</div>
          {/if}
        {else}
          {if strtotime($bidOpen.seri_end_date) <= time()}
            未落札
          {else}
            {if !empty($m.seri_amount)}
              現在の入札額 {$m.seri_amount|number_format}円 ({$m.seri_count}件)
            {else}
              まだ入札はありません
            {/if}
          {/if}
        {/if}
      </div>

      {if strtotime($bidOpen.seri_end_date) > time() && !$m.seri_result}
        <div class="seri_form">
          <input type="text" class="number amount" name="amount" value="" /> 円
          <button class="bid">入札</button>
        </div>
      {/if}
    </div>
  {/foreach}
  <br clear="both" />
</div>

{/block}
