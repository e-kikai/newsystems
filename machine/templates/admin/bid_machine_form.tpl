{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.upload.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jsrender.js"></script>

<!-- Google Maps APL ver 3 -->
<script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>

<script type="text/JavaScript">
{literal}
//// 変数の初期化 ////
var makerList  = [];
var genreList  = [];
var officeList = [];
var tmp = {};

var locationList = [];
var genre = {};

var ncMakerList = ["ファナック","メルダス","トスナック","OSP","プロフェッショナル","マザトロール"];

$(function() {
    //// ジャンル・メーカー・在庫場所一覧取得(初期化) ////
    $.getJSON('../ajax/admin_genre.php',
        {"target": "machine", "action": "getFormLists", "data": ''},
        function(json) {
            makerList  = json['makerList'];
            genreList  = json['genreList'];
            officeList = json['officeList'];
            $.each(officeList, function(i, val) {
                locationList.push({
                    label : val['name'] + ' (' + val['addr1'] + ' ' + val['addr2'] + ' ' + val['addr3'] + ')',
                    value : val['name'],
                    addr1 : val['addr1'],
                    addr2 : val['addr2'],
                    addr3 : val['addr3'],
                    lat   : val['lat'],
                    lng   : val['lng']
                })
            });
            locationList.push({ label:'現場(地図には非表示)', value:'現場', addr1:'', addr2:'', addr3:'', lat:'', lng:'' });
            locationList.push({ label:'その他(地図に表示させる場合は、住所を入力してください)', value:'', addr1:'', addr2:'', addr3:'', lat:'', lng:'' });

            // フォームの初期化
            $('.large_genre_id').change();

            $('input.location').autocomplete({
                source : function(req, res) { res(locationList); },
                minLength : 0,
                select : function(e, ui) {
                    $('input.addr1').val(ui.item.addr1);
                    $('input.addr2').val(ui.item.addr2);
                    $('input.addr3').val(ui.item.addr3);
                    $('input.lat').val(ui.item.lat);
                    $('input.lng').val(ui.item.lng);
                }
            }).click(function() {
                $(this).autocomplete('search');
            });
        }
    );

    //// ジャンル再編成 ////
    var currentLargeGenre = 0;
    $('select.large_genre_id').change(function() {
        var g = $('select.genre_id').val();
        $('select.genre_id').empty();
        var l = $(this).val();

        $.each(genreList, function(i, val) {
            if (val['large_genre_id'] == l) {
                $('select.genre_id').append(
                    $('<option value="' + val['id'] + '">' + val['genre'] + '</option>')
                );
            }
        });

        $("select.genre_id").val(g).change();
    });

    //// ジャンル変更：メーカー・能力一覧を再構成 ////
    $("select.genre_id").change(function() {
        var g = $(this).val();

        // ジャンル情報を変数格納
        $.each(genreList, function(i, val) {
            if (val['id'] == g) {
                genre = val;
                return;
            }
        });

        // メーカー一覧の再編、コンボボックス
        var re = new RegExp("(^|[|])" + g + "($|[|])");
        var sc = [];
        $.each(makerList, function(i, val) {
            if (val['genre_ids'].match(re)) { sc.push(val['maker']); }
        });

        $('input.maker').autocomplete({
            source    : function(req, res) {res(sc);},
            minLength : 0
        }).click(function() {
            $(this).autocomplete('search');
        })

        //// 能力の表示を変更 ////
        if (genre) {
            // 主能力
            if (genre['capacity_label']) {
                $('.capacity th').text(genre['capacity_label']);
                $('.capacity .unit').text(genre['capacity_unit']);
                $('.capacity').show();
            } else {
                $('.capacity').hide();
            }

            // その他能力
            $('.other_specs input').each(function() {
                $_self = $(this);
                tmp[$_self.attr('name')] = $_self.val() ? $_self.val() : '';
            });

            $('.other_specs').empty();
            if (genre['spec_labels']) {
                $.each(genre['spec_labels'], function(i, val){
                    // フォーム部分
                    var form = '';

                    // ラベル部分
                    if (val['label']) {
                        form += '<div class="others_label">' + val['label'] + '</div>';
                    }

                    // フォーム設定
                    name = 'others[' + i + ']';
                    if (val['type'] == 'number') {
                        // 数値入力
                        form += '<input type="text" class="number" name="'+name+'" value="'+tmp[name]+'"/>';
                    } else if (val['type'] == 'select') {
                        // ラジオボタン
                        $.each(val['options'], function(j, v2) {
                            form += '<label>' +
                                '<input type="radio" name="'+name+'" value="'+v2+'"' +
                                (tmp[name] == v2 ? ' checked="checked" ' : '') +
                                '/>' + v2 + '</label> ';
                        });
                    } else if (val['type'] == 'c3') {
                        // X:Y:Z入力
                        form += '<input type="text" class="mininum" name="'+name+'[0]" value="'+tmp[name+'[0]']+'" /> : ' +
                            '<input type="text" class="mininum" name="'+name+'[1]" value="'+tmp[name+'[1]']+'" /> : ' +
                            '<input type="text" class="mininum" name="'+name+'[2]" value="'+tmp[name+'[2]']+'" />';
                    } else if (val['type'] == 'x2') {
                        // A×B入力
                        form += '<input type="text" class="mininum" name="'+name+'[0]" value="'+tmp[name+'[0]']+'" /> × ' +
                            '<input type="text" class="mininum" name="'+name+'[1]" value="'+tmp[name+'[1]']+'" />';
                    } else if (val['type'] == 'x3') {
                        // A×B×C入力
                        form += '<input type="text" class="mininum" name="'+name+'[0]" value="'+tmp[name+'[0]']+'" /> × ' +
                            '<input type="text" class="mininum" name="'+name+'[1]" value="'+tmp[name+'[1]']+'" /> × ' +
                            '<input type="text" class="mininum" name="'+name+'[2]" value="'+tmp[name+'[2]']+'" />';
                    } else if (val['type'] == 't2') {
                        // A～B入力
                        form += '<input type="text" class="mininum" name="'+name+'[0]" value="'+tmp[name+'[0]']+'" /> ～ ' +
                            '<input type="text" class="mininum" name="'+name+'[1]" value="'+tmp[name+'[1]']+'" />';
                    } else if (val['type'] == 'combo') {
                        // コンボボックス
                        form += '<input type="text" class="combo" name="'+name+'" value="'+tmp[name]+'" />';
                    } else if (val['type'] == 'nc') {
                        // NC装置
                        form += '<input type="text" class="combo" name="'+name+'[maker]"' +
                            ' value="'+tmp[name+'[maker]']+'" placeholder="メーカー選択" />' +
                            ' <input type="text" class="text" name="'+name+'[model]"' +
                            '  value="'+tmp[name+'[model]']+'" placeholder="型式" />';
                    } else {
                        // 文字列入力text(デフォルト)
                        form += '<input type="text" class="text" name="'+name+'" value="'+tmp[name]+'" />';
                    }

                    // 単位部分
                    if (val['unit']) {
                        form += '<div class="others_unit">' + val['unit'] + '</div>';
                    }

                    // 表示エリアに結合
                    $('.other_specs').append('<div class="others '+i+'">'+form+'</div>');

                    // コンボボックスのイベント設定
                    if (val['type'] == 'combo') {
                        $('.others.' + i + ' input').autocomplete({
                            source    : function(req, res) { res(val['options']); },
                            minLength : 0
                        }).click(function() {
                            $(this).autocomplete('search');
                        });
                    } else if (val['type'] == 'nc') {
                        // NC装置コンボボックスのイベント設定
                        $('.others.' + i + ' input.combo').autocomplete({
                            source : function(req, res) { res(ncMakerList);},
                            minLength : 0
                        }).click(function() {
                            $(this).autocomplete('search');
                        });
                    }
                });
            }

            // undefinedの修正
            $('.others input[value="undefined"]').val('');

            // textresizerの反映
            $('ul.textresizer a.textresizer-active').click();

            // 名前の変更
            $('input.capacity').change();
        }
    });
    $(".genre_id").change();

    //// 能力の変更による機械名の変更 ////
    $('input.capacity').change(function() {
        var cap = $(this).val();
        var g = $('select.genre_id').val();

        // 能力を数値に整形 @ba-ta 20130329
        cap = mb_convert_kana(cap, 'KVrnm').replace(/[^0-9.]/g, '');
        cap = cap ? parseFloat(cap) : '';
        $(this).val(cap);

        if (genre) {
            var name = genre['naming'];

            // 機械名フォームを初期化
            $('input.name').attr({
                // 'readonly' : 'readonly',
                'placeholder' : ''
            }) // .autocomplete('destroy');

            // 能力 + 単位を付加
            if (cap) {
                name = name.replace(/\%capacity\%/g, cap);
                name = name.replace(/\%unit\%/g, genre['capacity_unit']);

                // 旋盤のみの独自仕様
                if (name.match(/\%lather\%/)) {
                    var nTemp = cap >= 2000 ? (cap / 1000) + 'm' :
                        cap >= 1500 ? '9尺' :
                        cap >= 1200 ? '8尺' :
                        cap >= 1000 ? '7尺' :
                        cap >= 800  ? '6尺' :
                        cap >= 600  ? '5尺' :
                        cap >= 360  ? '4尺' :
                        cap >= 240  ? '3尺' : '';

                    name = name.replace(/\%lather\%/g, nTemp);
                }
            } else {
                name = name.replace(/\%(capacity|unit|lather)\%/g, '');
            }

            // 自由記入
            if (name.match(/\%free\%/)) {
                name = name.replace(/\%free\%/g, '');
                // 入力フィールドをアクティブに
                // $('input.name').removeAttr('readonly').attr('placeholder', '自由記入');
            }

            // 選択
            if (name.match(/\%select:(.*)\%/)) {
                name = name.replace(/\%select:(.*)\%/g, '');

                // 入力フィールドをコンボボックスに
                var sc = RegExp.$1.split('|');
                $('input.name').autocomplete({
                    source    : function(req, res) {res(sc);},
                    minLength : 0
                }).click(function() {
                    $(this).autocomplete('search');
                })
                // 入力フィールドをアクティブに
                // .removeAttr('readonly').attr('placeholder', '機械名を選択 or 自由記入');
            }

            // 初期値の反映
            if ($('input.name.default').val()) {
                if (name == '') { name = $('input.name.default').val(); }
                $('input.name.default').removeClass('default');
            }

            // 機械名を反映
            $('input.name').val(name);
        }
    });

    //// 営業所の緯度経度の取得 ////
    // ジオコーディング
    gc = new google.maps.Geocoder();

    $(document).on('change', 'input.addr3', function() {
        var $_parent = $(this).parent('.office');

        // 緯度経度の初期化
        $_parent.find('input.lat').val();
        $_parent.find('input.lng').val();

        if ($(this).val() == '') { return false; }

        // 住所
        var pure_addr = $_parent.find('input.addr1').val() + ' ' + $_parent.find('input.addr2').val() + ' ' + $(this).val();

        gc.geocode({'address': pure_addr}, function(results, status) {
            console.log(pure_addr);
            // 取得できなかった場合は無視
            if (status != 'OK') { return false; }

            $_parent.find('input.lat').val(results[0].geometry.location.lat());
            $_parent.find('input.lng').val(results[0].geometry.location.lng());

            return false;
        });
    });

    //// 数値のみに自動整形 ////
    $('input.price, input.min_price').change(function() {
        var price = mb_convert_kana($(this).val(), 'KVrnm').replace(/[^0-9]/g, '');
        $(this).val(price ? parseInt(price) : '');
    });

    //// ファイルが選択されたら、自動的にアップロード開始 ////
    $('input.file').change(function() {
        $_self = $(this);

        if ($_self.val() == '') { return false; }

        $_self.after('<span class="dd_wait">ファイルをアップロードしています</span>').hide();

        $_self.upload('/admin/ajax/upload.php', {
            'target'     : 'system',
            'action'     : 'set',
            'data[type]' : $_self.attr('accept'),
        }, function(res) {
            $_self.val('').show();
            $('.dd_wait').remove();
            try {
                data = $.parseJSON(res); // $.parseJSON() で変換
            } catch(e) {
                alert(res);
                return false;
            }

            // アップロード完了
            $.each(data, function(i, val) {
                if ($_self.data('target') == "imgs") {
                    $('.imgs .upload_img').append($("#imgs_tmpl").render(val));
                } else if ($_self.data('target') == "top_img") {
                    $('.top_img .upload_img').html($("#top_img_tmpl").render(val));
                } else if ($_self.data('target') == "pdfs") {
                    $('.pdfs .upload_pdf').append($("#pdfs_tmpl").render(val));
                }
            });
            return false;
        }, 'text');

        return false;
    });

    //// ファイルのドラッグアンドドロップをサポートのチェック・表示 ////
    if (window.File) {
        $('input.file').after('<span class="dd_message">⇐にドラッグ＆ドロップできます</span>')
    }


    //// 処理 ////
    $('button.submit').click(function() {
        var data = {
            'id': $.trim($('input.id').val()),
            'machine_id': $.trim($('input.machine_id').val()),
            'bid_open_id': $.trim($('input.bid_open_id').val()),

            'genre_id': $.trim($('select.genre_id').val()),
            'name': $.trim($('input.name').val()),
            'maker': $.trim($('input.maker').val()),
            'model': $.trim($('input.model').val()),
            'year': $.trim($('select.year').val()),
            'capacity': $.trim($('input.capacity').val()),
            'spec': $.trim($('textarea.spec').val()),

            'min_price': $.trim($('input.min_price').val()),

            'accessory': $.trim($('input.accessory').val()),
            'comment': $.trim($('textarea.comment').val()),
            'carryout_note': $.trim($('textarea.carryout_note').val()),
            'commission': $.trim($('input.commission:checked').val()),

            'location': $.trim($('input.location').val()),
            'addr1': $.trim($('input.addr1').val()),
            'addr2': $.trim($('input.addr2').val()),
            'addr3': $.trim($('input.addr3').val()),
            'lat': $.trim($('input.lat').val()),
            'lng': $.trim($('input.lng').val()),

            'top_img': $('input.top_img').val(),
            // 'top_img_delete': $('input.top_img_delete:checked').val(),
            'imgs': $('input.imgs').map(function() { return $(this).val(); }).get(),
            'imgs_delete': $('input.imgs_delete:checked').map(function() { return $(this).val(); }).get(),
            'pdfs_delete': $('input.pdfs_delete:checked').map(function() { return $(this).val(); }).get(),
            'youtube': $.trim($('input.youtube').val()),

            'others': {},
            'pdfs': {},

            'seri_price': $.trim($('input.seri_price').val()),
        };

        // nameでhashだったものは(無理やり)配列化
        $('div.other_specs input[type!=radio], input.pdfs, div.other_specs input:radio:checked').each(function() {
            var name = $(this).attr('name');
            if (name.match(/^(.*)\[(.*)\]\[(.*)\]$/)) {
                if (!data[RegExp.$1][RegExp.$2]) { data[RegExp.$1][RegExp.$2] = {}; }
                data[RegExp.$1][RegExp.$2][RegExp.$3] = $(this).val();
            } else if (name.match(/^(.*)\[(.*)\]$/)) {
                data[RegExp.$1][RegExp.$2] = $(this).val();
            }
        });

        //// 入力のチェック ////
        var e = '';
        $('input[required]').each(function() {
            if ($(this).val() == '') {
                e += "必須項目が入力されていません\n\n";
                return false;
            }
        });

        // if (!data['top_img']) { e += 'TOP画像が入力されていません\n'; }
        if (!data['min_price']) {
            e += '最低入札金額が入力されていません\n';
        } else if (data['min_price'] < parseInt($('input.bidopen_min_price').val())) {
            e += '最低入札金額が、入札会の最低入札金額より小さく入力されています\n';
        } else if ((data['min_price'] % parseInt($('input.bidopen_rate').val())) != 0) {
            e += '最低入札金額が、入札レートの倍数ではありません\n';
        }

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('入力した商品情報を保存します。よろしいですか。')) { return false; }

        $('button.submit').attr('disabled', 'disabled').text('出品処理中、終了までそのままお待ち下さい');

        $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'set',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                $('button.submit').removeAttr('disabled').text('出品する');
                alert(res);
                return false;
            }

            // 登録完了
            // alert('保存が完了しました');
            location.href = '/admin/bid_machine_list.php?o=' + $('input.bid_open_id').val();
            return false;
        }, 'text');

        return false;
    });

    // 「在庫から～」のときに、追加入力部分をハイライト
    if ($('input.machine_id').val() && $('input.id').val() == '') {
        $('input.min_price, textarea.carryout_note').addClass('highlight');
    }

    // 企業間売り切り表示切り替え
    $('.is_seri').change(function() {
        if ($(this).prop('checked')) {
            $('input.seri_price').prop("disabled", false);
        } else {
            $('input.seri_price').prop("disabled", true).val('');
        }
    });
    if ($('input.seri_price').val()) {
        $('.is_seri').prop('checked', true);
    }
    $('.is_seri').change();
});
</script>
<script id="top_img_tmpl" type="text/x-jsrender">
<div class="img">
  <a href="/media/tmp/{{>filename}}" target="_blank"><img src="/media/tmp/{{>filename}}" /></a>
  <input name="top_img" class="top_img" type="hidden" value="{{>filename}}" />
</div>
</script>

<script id="imgs_tmpl" type="text/x-jsrender">
<div class="img">
  <label><input type="checkbox" name="imgs_delete[]" class="imgs_delete" value="{{>filename}}" />削除</label><br />
  <a href="/media/tmp/{{>filename}}" target="_blank"><img src="/media/tmp/{{>filename}}" /></a>
  <input name="imgs[]" class="imgs" type="hidden" value="{{>filename}}" />
</div>
</script>

<script id="pdfs_tmpl" type="text/x-jsrender">
<div class="pdf">
  <a href="/media/tmp/{{>filename}}" target="_blank">PDF</a>
  <input type="text" name="pdfs[{{>filename}}]" class="pdfs" value="{{>label}}" data-file="{{>filename}}" placeholder="ラベル" />
  <label><input name="pdfs_delete[]" class="pdfs_delete" type="checkbox" value="{{>filename}}" />削除</label>
</div>
</script>
<style type="text/css">
/*** 新ファイルアップロード ***/
input.file {
  width: 220px;
}

.dd_message {
  padding: 4px;
}

table.form td input.highlight,
table.form td textarea.highlight {
  background: #FFCCFF;
}

.seri_sepa {
  position: absolute;
  right: 304px;
  top: 14px;
}

.seri_yen {
  position: absolute;
  right: 16px;
  top: 14px;
}

table.form td input.is_seri {
  position: absolute;
  right: 272px;
  top: 19px;
}

table.form td .seri_label {
  position: absolute;
  right: 176px;
  top: 18px;
}

table.form td input.seri_price {
  position: absolute;
  right: 36px;
  top: 13px;
}

table.form td input.seri_price:disabled {
  background: #EEE;
}


</style>
{/literal}
{/block}

{block 'main'}
{*
<div class="form_comment">
  <span class="alert">※</span>
  　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
</div>
*}

<form class="machine" method="post" action="">
  <input type="hidden" name="id" class="id" value="{$machineId}" />
  <input type="hidden" name="machine_id" class="machine_id" value="{$machine.machine_id}" />
  <input type="hidden" name="bid_open_id" class="bid_open_id" value="{$bidOpenId}" />

  <input type="hidden" class="bidopen_min_price" value="{$bidOpen.min_price}" />
  <input type="hidden" class="bidopen_rate" value="{$bidOpen.rate}" />

<table class="machine form">
  <tr class="number">
    <th>入札会</th>
    <td>
      {$bidOpen.title}<br />
      最低出品金額 : {$bidOpen.min_price|number_format}円<br />
      入札レート : {$bidOpen.rate|number_format}円
    </td>
  </tr>

  <tr class="large_genre">
    <th>ジャンル<span class="required">(必須)</span></th>
    <td>
      <select name="large_genre_id" class="large_genre_id">
        {foreach $largeGenreList as $l}
          {if $l@first}<optgroup label="NC工作機械">
          {elseif $l.id == 10}</optgroup><optgroup label="一般工作機械">
          {elseif $l.id == 9}</optgroup><optgroup label="鍛圧機械">
          {elseif $l.id == 19}</optgroup><optgroup label="鈑金機械">
          {elseif $l.id == 24}</optgroup><optgroup label="鉄骨加工機械">
          {elseif $l.id == 37}</optgroup><optgroup label="輸送・荷役機械">
          {elseif $l.id == 47}</optgroup><optgroup label="工作機械周辺機器">
          {elseif $l.id == 30}</optgroup><optgroup label="測定器・試験機">
          {elseif $l.id == 50}</optgroup><optgroup label="電気設備">
          {elseif $l.id == 54}</optgroup><optgroup label="鉄製造設備">
          {elseif $l.id == 32}</optgroup><optgroup label="その他機械">{/if}

          <option value="{$l.id}" {if $l.id==$machine.large_genre_id} selected{/if}>
            {$l.large_genre}
          </option>
        {/foreach}
        </optgroup>
      </select>
      &raquo;
      <select name="genre_id" class="genre_id">
        <option value="{$machine.genre_id}"selected></option>
      </select>
    </td>
  </tr>

  <tr class="name">
    <th>機械名<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="name" class="name default" value="{$machine.name}"
        placeholder="機械名" required />
    </td>
  </tr>

  <tr class="maker">
    <th>メーカー</th>
    <td>
      <input type="text" name="maker" class="maker" value="{$machine.maker}"
          placeholder="メーカー名選択 or 自由記入" />
    </td>
  </tr>

  <tr class="model">
    <th>型式</th>
    <td>
      <input type="text" name="model" class="model" value="{$machine.model}"
        placeholder="型式" />
      <input type="hidden" name="catalog_id"  class="catalog_id" value="{$machine.catalog_id}" />
    </td>
  </tr>

  <tr class="year">
    <th>年式</th>
    <td>{html_options name='year' class='year' options=$yearList selected=$machine.year}</td>
  </tr>

  <tr class="maker">
    <th>最低入札金額<span class="required">(必須)</span></th>
    <td style="position:relative;">
      <input type="text" name="min_price" class="min_price number" value="{$machine.min_price}"
        placeholder="金額(数字で入力)" required />円<br />
      <a href="/admin/bid_fee_sim.php?o={$b.id}" onclick="window.open('/admin/bid_fee_sim.php?o={$bidOpenId}','','scrollbars=yes,width=850,height=450,');return false;">
        支払・請求額シミュレータ
      </a>

      <div class="seri_sepa">&raquo;</div>

      <input type="checkbox" class="is_seri" id="is_seri" />
      <label class="seri_label" for="is_seri">売り切りに出品</label>
      <input type="text" class="min_price number seri_price" value="{$machine.seri_price}" placeholder="金額(数字で入力)" />
      <div class="seri_yen">円</div>

    </td>
  </tr>

  {*** 能力 ***}
  <tr class="capacity">
    <th>主能力</th>
    <td>
      <input type="text" name="capacity" class="capacity" value="{$machine.capacity}" />
      <div class="unit"></div>
    </td>
  </tr>

  {*** その他能力 ***}
  <tr class="spec_data">
    <th>能力</th>
    <td>
      {*** その他共通項目 ***}
      <div class="other_specs">
      {foreach $machine.others as $key => $o}
        {if is_array($o)}
          {foreach $o as $key2 => $o2}
            <input type="text" name="others[{$key}][{$key2}]" value="{$o2}" />
          {/foreach}
        {else}
          <input type="text" name="others[{$key}]" value="{$o}" />
        {/if}
      {/foreach}
      </div>
    </td>
  </tr>

  <tr class="spec">
    <th>仕様</th>
    <td>
      <textarea name="spec" class="spec"
        placeholder="能力項目以外のその他仕様などを入力してください"
        >{$machine.spec}</textarea>
    </td>
  </tr>

  <tr class="accessory">
    <th>附属品</th>
    <td>
      <input type="text" name="accessory" class="accessory"
        value="{$machine.accessory}"
        placeholder="附属品を入力してください" />
    </td>
  </tr>

  <tr class="comment">
    <th>コメント</th>
    <td>
      <textarea name="comment" class="comment"
        placeholder="この商品特有のコメントを入力してください(取説あり、塗装できますなど)"
        >{$machine.comment}</textarea>
    </td>
  </tr>

  <tr class="carryout_note">
    <th>引取留意事項</th>
    <td>
      <textarea name="carryout_note" class="carryout_note"
        placeholder="引取時に関する、留意事項を入力してください"
        >{$machine.carryout_note}</textarea>
    </td>
  </tr>


  <tr class="commission">
    <th>試運転</th>
    <td>
      {html_radios name='commission' class='commission' options=['' => '不可', '1' => '可']
       selected=$machine.commission separator=' '}
    </td>
  </tr>

  <tr class="location">
    <th>在庫場所</th>
    <td class="office">
      <input type="text" name="location" class="location" value="{$machine.location}"
        placeholder="在庫場所" /><br />

      住所
      <input type="text" name="addr1" class="addr1" value="{$machine.addr1}" placeholder="都道府県" />
      <input type="text" name="addr2" class="addr2" value="{$machine.addr2}" placeholder="市区町村" />
      <input type="text" name="addr3" class="addr3" value="{$machine.addr3}" placeholder="番地その他" /><br />

      緯度経度(住所から自動入力)
      <input type="text" name="lat" class="lat" value="{$machine.lat}" placeholder="緯度(住所から自動入力)" />
      <input type="text" name="lng" class="lng" value="{$machine.lng}" placeholder="経度(住所から自動入力)" />

    </td>
  </tr>

  <tr class="top_img">
    {*
    <th>TOP画像<span class="required">(必須)</span></th>
    *}
    <th>TOP画像</th>
    <td>
      <span class="alert">※</span> 登録できる画像ファイル形式はJPEGのみです<br />
      <input type="file" name="f[]" class="file" data-target="top_img" accept="image/jpeg" />
      <div class="upload_img">
        {if !empty($machine.top_img)}
          <div class="img">
            <label><input type="checkbox" name="top_img_delete" class="top_img_delete" value="{$machine.top_img}" />削除</label><br />
            <a href='{$_conf.media_dir}machine/{$machine.top_img}' target="_blank">
              <img src='{$_conf.media_dir}machine/{$machine.top_img}' />
            </a>
            <input type="hidden" name="top_img" class="top_img" value="{$machine.top_img}" />
          </div>
        {/if}
      </div>
    </td>
  </tr>

  <tr class="imgs">
    <th>画像(複数可)</th>
    <td>
      <input type="file" name="f[]" class="file" data-target="imgs" accept="image/jpeg" multiple />
      <div class="upload_img">
        {foreach $machine.imgs as $i}
          <div class="img">
            <label><input type="checkbox" name="imgs_delete[]" class="imgs_delete" value="{$i}" />削除</label><br />
            <a href='{$_conf.media_dir}machine/{$i}' target="_blank">
              <img src='{$_conf.media_dir}machine/{$i}' />
            </a>
            <input type="hidden" name="imgs[]" class="imgs" value="{$i}" />
          </div>
        {/foreach}
      </div>
    </td>
  </tr>

  <tr class="pdfs">
    <th>PDF(複数可)</th>
    <td>
      <input type="file" name="f[]" class="file" data-target="pdfs" accept="application/pdf" multiple />
      <div class="upload_pdf">
      {if !empty($machine.pdfs)}
        {foreach $machine.pdfs as $key => $i}
          <div class="pdf">
            <a href='{$_conf.media_dir}machine/{$i}' target="_blank">PDF</a>
            <input type="text" name="pdfs[{$i}]" class="pdfs" value="{$key}" data-file="{$i}" placeholder="ラベル" />
            <label><input type="checkbox" class="pdfs_delete" name="pdfs_delete[]" value="{$i}" />削除</label>
          </div>
        {/foreach}
      {/if}
      </div>
    </td>
  </tr>

  <tr class="youtube">
    <th>YouTube URI</th>
    <td>
      <input type="text" name="youtube" class="youtube"
        value="{$machine.youtube}"
        placeholder="YouTube URIを入力してください" /><br />
      表示させる動画の「共有」ボタンで表示されるURIを入力してください<br />
      ※ 動画のアップロードは予め
      <a href="https://www.youtube.com/?gl=JP&hl=ja" target="_blank">YouTube</a>
      で行なってください
    </td>
  </tr>
</table>

<button type="button" name="submit" class="submit">出品する</button>

</form>
{/block}
