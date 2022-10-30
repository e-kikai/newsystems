{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <!-- Google Maps APL ver 3 -->
  <script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>

  <script type="text/javascript">
    {literal}
      //// 変数の初期化 ////
      var makerList = [];
      var genreList = [];
      var officeList = [];
      var tmp = {};

      var locationList = [];
      var genre = {};

      var ncMakerList = ["ファナック", "メルダス", "トスナック", "OSP", "プロフェッショナル", "マザトロール"];

      $(function() {
        //// ジャンル・メーカー・在庫場所一覧取得(初期化) ////
        $.getJSON('../ajax/admin_genre.php',
          {"target": "machine", "action": "getFormLists", "data": ''},
          function(json) {
            makerList = json['makerList'];
            genreList = json['genreList'];
            officeList = json['officeList'];
            $.each(officeList, function(i, val) {
              locationList.push({
                label: val['name'] + ' (' + val['addr1'] + ' ' + val['addr2'] + ' ' + val['addr3'] + ')',
                value: val['name'],
                addr1: val['addr1'],
                addr2: val['addr2'],
                addr3: val['addr3'],
                lat: val['lat'],
                lng: val['lng']
              })
            });
            locationList.push({ label: '現場(地図には非表示)', value: '現場', addr1: '', addr2: '', addr3: '', lat: '',
              lng: '' });
            locationList.push({ label: 'その他(地図に表示させる場合は、住所を入力してください)', value: '', addr1: '', addr2: '', addr3: '',
              lat: '', lng: '' });

            // フォームの初期化
            $('.large_genre_id').change();

            $('input.location').autocomplete({
              source: function(req, res) { res(locationList); },
              minLength: 0,
              select: function(e, ui) {
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

        //// フォームのエラーチェック(HTML5対応)
        $('form.machine').submit(function() {
          if (!Modernizr.input.required) {
            var result = true;;
            $('input[required]').each(function() {
              if ($(this).val() == '') {
                alert('必須項目が入力されていません。');
                result = false;
              }
            });
            if (!result) { return false; }
          }

          if (confirm('在庫機械情報の変更を反映します。よろしいですか。')) {
            $(this).attr('action', 'admin/machine_do.php');
            return true;
          } else {
            return false;
          }
        });

        //// ジャンル再編成 ////
        var currentLargeGenre = 0;
        $('select.large_genre_id').change(function() {
          var g = $('select.genre_id').val();
          $('select.genre_id').empty();
          var l = $(this).val();

          $.each(genreList, function(i, val) {
            if (val['large_genre_id'] == l) {
              $('select.genre_id').append(
                // $('<option>').val(val['id']).text(val['genre']);
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
            minLength: 0
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
              $.each(genre['spec_labels'], function(i, val) {
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
                  form += '<input type="text" class="number" name="' + name + '" value="' + tmp[name] + '"/>';
                } else if (val['type'] == 'select') {
                  // ラジオボタン
                  $.each(val['options'], function(j, v2) {
                    form += '<label>' +
                      '<input type="radio" name="' + name + '" value="' + v2 + '"' +
                      (tmp[name] == v2 ? ' checked="checked" ' : '') +
                      '/>' + v2 + '</label> ';
                  });
                } else if (val['type'] == 'c3') {
                  // X:Y:Z入力
                  form += '<input type="text" class="mininum" name="' + name + '[0]" value="' + tmp[name +
                      '[0]'] + '" /> : ' +
                    '<input type="text" class="mininum" name="' + name + '[1]" value="' + tmp[name + '[1]'] +
                    '" /> : ' +
                    '<input type="text" class="mininum" name="' + name + '[2]" value="' + tmp[name + '[2]'] +
                    '" />';
                } else if (val['type'] == 'x2') {
                  // A×B入力
                  form += '<input type="text" class="mininum" name="' + name + '[0]" value="' + tmp[name +
                      '[0]'] + '" /> × ' +
                    '<input type="text" class="mininum" name="' + name + '[1]" value="' + tmp[name + '[1]'] +
                    '" />';
                } else if (val['type'] == 'x3') {
                  // A×B×C入力
                  form += '<input type="text" class="mininum" name="' + name + '[0]" value="' + tmp[name +
                      '[0]'] + '" /> × ' +
                    '<input type="text" class="mininum" name="' + name + '[1]" value="' + tmp[name + '[1]'] +
                    '" /> × ' +
                    '<input type="text" class="mininum" name="' + name + '[2]" value="' + tmp[name + '[2]'] +
                    '" />';
                } else if (val['type'] == 't2') {
                  // A～B入力
                  form += '<input type="text" class="mininum" name="' + name + '[0]" value="' + tmp[name +
                      '[0]'] + '" /> ～ ' +
                    '<input type="text" class="mininum" name="' + name + '[1]" value="' + tmp[name + '[1]'] +
                    '" />';
                } else if (val['type'] == 'combo') {
                  // コンボボックス
                  form += '<input type="text" class="combo" name="' + name + '" value="' + tmp[name] + '" />';
                } else if (val['type'] == 'nc') {
                  // NC装置
                  form += '<input type="text" class="combo" name="' + name + '[maker]"' +
                    ' value="' + tmp[name + '[maker]'] + '" placeholder="メーカー選択" />' +
                    ' <input type="text" class="text" name="' + name + '[model]"' +
                    '  value="' + tmp[name + '[model]'] + '" placeholder="型式" />';
                } else {
                  // 文字列入力text(デフォルト)
                  form += '<input type="text" class="text" name="' + name + '" value="' + tmp[name] + '" />';
                }

                // 単位部分
                if (val['unit']) {
                  form += '<div class="others_unit">' + val['unit'] + '</div>';
                }

                // 表示エリアに結合
                $('.other_specs').append('<div class="others ' + i + '">' + form + '</div>');

                // コンボボックスのイベント設定
                if (val['type'] == 'combo') {
                  $('.others.' + i + ' input').autocomplete({
                    source: function(req, res) { res(val['options']); },
                    minLength: 0
                  }).click(function() {
                    $(this).autocomplete('search');
                  });
                } else if (val['type'] == 'nc') {
                  // NC装置コンボボックスのイベント設定
                  $('.others.' + i + ' input.combo').autocomplete({
                    source: function(req, res) { res(ncMakerList); },
                    minLength: 0
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
              'placeholder': ''
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
                  cap >= 800 ? '6尺' :
                  cap >= 600 ? '5尺' :
                  cap >= 360 ? '4尺' :
                  cap >= 240 ? '3尺' : '';

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
                minLength: 0
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
            if (nameChange == true) {
              $('input.name').val(name);
            } else {
              nameChange = true;
            }
          }
        });

        var nameChange = false;

        //// カタログ検索 ////
        $('.catalog_search').click(function() {
          var model = $.trim($('input.model').val());
          var maker = $.trim($('input.maker').val());
          var genre_id = $.trim($('select.genre_id').val());

          if (model == '') {
            alert('型式を入力してください');
          } else {
            // カタログIDを取得
            $.getJSON('../ajax/admin_genre.php',
              {"target": "machine", "action": "getCatalogList", "data": {'ma':maker,'g':genre_id,'mo':model}},
              function(json) {
                var catalogList = json;

                // リストの初期化
                $('.catalog_list').hide();
                $('.catalog_list tbody').empty()

                if (!catalogList.length) {
                  alert('該当するカタログはありません(' + model + ')');
                  return false;
                }

                // カタログ一覧の作成
                var curi = 'https://catalog.zenkiren.net';
                var muri = 'https://s3-ap-northeast-1.amazonaws.com/machinelife/catalog/public/media/';
                $.each(catalogList, function(i, val) {
                  $('.catalog_list tbody').append(
                    '<tr>' +
                    '<td class="maker">' + (val['maker'] ? val['maker'] : '') + '<br />' + (val['genres'] ?
                      val['genres'] : '') +
                    '<br /><button class="catalog_select" value="' + val['id'] + '">選択</button>' + '</td>' +
                    '<td class="img"><a href="' + curi + '/catalog_pdf.php?id=' + val['id'] +
                    '" target="_blank">' +
                    '<img class="catalog_tumbnail" src="' + muri + 'catalog_thumb/' + val['thumbnail'] +
                    '" alt="PDF" /></a></td>' +
                    '<td class="model">' + val['models'] + '</td>' +
                    '<td class="year">' + (val['year'] ? val['year'] : '') + '<br />' + (val['catalog_no'] ?
                      val['catalog_no'] : '') + '</td>' +
                    '</tr>'
                  );

                  // 表示
                  var offset = $('.catalog_search').offset();
                  $('.catalog_list').dialog({
                    show: "fade",
                    hide: "fade",
                    closeText: '閉じる',
                    title: '電子カタログの選択',
                    width: 680,
                    height: 545,
                    resizable: false,
                    modal: true,
                  });
                });

                // 選択ボタンイベント
                $('button.catalog_select').click(function() {
                  var catalog_id = $(this).val();
                  $('input.catalog_id').val(catalog_id);
                  $('.catalog_area').html(
                    '<a href="' + curi + '/catalog_pdf.php?id=' + catalog_id + '" target="_blank">' +
                    catalog_id + '</a>'
                  );
                  // $('.catalog_list').hide();
                  $('.catalog_list').dialog("close");
                });
              });
          }
          return false;
        });

        //// 営業所の緯度経度の取得 ////
        // ジオコーディング
        gc = new google.maps.Geocoder();

        // $('input.addr3').live('change', function() {
        $(document).on('change', 'input.addr3', function() {
          var $_parent = $(this).parent('.office');

          // 緯度経度の初期化
          $_parent.find('input.lat').val();
          $_parent.find('input.lng').val();

          if ($(this).val() == '') { return false; }

          // 住所
          var pure_addr = $_parent.find('input.addr1').val() + ' ' + $_parent.find('input.addr2').val() + ' ' + $(
            this).val();

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
      $('input.price').change(function() {
        var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9]/g, '');
        $(this).val(price ? parseInt(price) : '');
      });

      // 独自ラベル
      $(".org_label input").change(function() {
        org_label_change();
      });
      org_label_change();
      });

      //// アップロード後のコールバック ////
      function upload_callback(target, data) {
        if (target == "imgs") {
          $.each(data, function(i, val) {
            var h =
              '<div class="img">' +
              '<label><input name="imgs_delete[]" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
              '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
              '<img src="/media/tmp/' + val.filename + '" />' +
              '</a>' +
              '<input name="imgs[]" type="hidden" value="' + val.filename + '" />'
            '</div>';
            $('.imgs .upload_img').append(h);
          });
        } else if (target == "top_img") {
          $.each(data, function(i, val) {
            var h =
              '<div class="img">' +
              '<label><input name="top_img_delete" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
              '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
              '<img src="/media/tmp/' + val.filename + '" />' +
              '</a>' +
              '<input name="top_img" type="hidden" value="' + val.filename + '" />'
            '</div>';
            $('.top_img .upload_img').html(h);
          });
        } else if (target == "pdf") {
          $.each(data, function(i, val) {
            var label = val.label.replace(/\..*$/, "");
            var h =
              '<div class="pdf">' +
              '<a href="/media/tmp/' + val.filename + '" target="_blank">PDF</a>' +
              '<input type="text" name="pdfs[' + val.filename + ']" value="' + label + '" /> ' +
              '<label>削除<input name="pdfs_delete[]" type="checkbox" value="' + val.filename + '" /></label><br />' +
              '</div>';
            $('.pdfs .upload_pdf').append(h);
          });
        }
      }
      /*
  function org_label_change() {
      var h;
      if ($(".label_title").val() != "") {
          if ($(".label_url").val() != "") {
              h = '<a class="label org" href="' + $('.label_url').val() + '" target="_blank"' +
                'style="background:' + $('.label_color').val() + ';">' +
                $('.label_title').val() + '</a>';
          } else {
              h = '<div class="label org"' +
                'style="background:' + $('.label_color').val() + ';">' +
                $('.label_title').val() + '</div>';
          }
      } else {
          h = "";
      }

      $(".label_sample").html(h);
  }
  */
    </script>
    <style type="text/css">
      div.uid {
        width: 720px;
        margin: 4px auto;
        background: #FF7;
        padding: 3px;
      }

      button.catalog_search {
        width: 160px;
      }

      .catalog_area {
        width: 240px;
      }

      button.machine_search {
        width: 240px;
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
    <input type="hidden" name="id" class="id" value="{$id}" />
    <input type="hidden" name="bid_machine_id" class="bid_machine_id" value="{$machine.bid_machine_id}" />
    <input type="hidden" name="bid_open_id" class="bid_open_id" value="{$machine.bid_open_id}" />

    {if !empty($machine.used_id) && !empty($machine.used_change)}
      <div class="uid">△ この機械情報は、新九郎、CSVで同期後に変更を行った機械です(削除以外の同期の影響を受けません)</div>
      <input type="hidden" name="used_change" class="used_change" value="1" />
    {elseif !empty($machine.used_id)}
      <div class="uid">◯ この機械情報は、新九郎、CSVで同期された機械です(変更後は、削除以外の同期の影響を受けなくなります)</div>
      <input type="hidden" name="used_change" class="used_change" value="1" />
    {/if}

    <table class="machine form">
      <tr class="number">
        <th>管理番号</th>
        <td>
          <input type="text" name="no" class="number" value="{$machine.no}" placeholder="管理番号" />
          {* ※ 一括変更を行う場合は必須 *}
        </td>
      </tr>

      <tr class="large_genre">
        <th>ジャンル<span class="required">(必須)</span></th>
        <td>
          <select name="large_genre_id" class="large_genre_id">
            {foreach $largeGenreList as $l}
              {if $l@first}<optgroup label="NC工作機械">
                {elseif $l.id == 10}</optgroup>
                <optgroup label="一般工作機械">
                {elseif $l.id == 9}</optgroup>
                <optgroup label="鍛圧機械">
                {elseif $l.id == 19}</optgroup>
                <optgroup label="鈑金機械">
                {elseif $l.id == 24}</optgroup>
                <optgroup label="鉄骨加工機械">
                {elseif $l.id == 37}</optgroup>
                <optgroup label="輸送・荷役機械">
                {elseif $l.id == 47}</optgroup>
                <optgroup label="工作機械周辺機器">
                {elseif $l.id == 30}</optgroup>
                <optgroup label="測定器・試験機">
                {elseif $l.id == 50}</optgroup>
                <optgroup label="電気設備">
                {elseif $l.id == 54}</optgroup>
                <optgroup label="鉄製造設備">
                {elseif $l.id == 32}</optgroup>
              <optgroup label="その他機械">{/if}

                <option value="{$l.id}" {if $l.id==$machine.large_genre_id} selected{/if}>
                  {$l.large_genre}
                </option>
              {/foreach}
            </optgroup>
          </select>
          &raquo;
          <select name="genre_id" class="genre_id">
            <option value="{$machine.genre_id}" selected></option>
          </select>
        </td>
      </tr>

      <tr class="name">
        <th>機械名<span class="required">(必須)</span></th>
        <td>
          <input type="text" name="name" class="name default" value="{$machine.name}" placeholder="機械名" required />
        </td>
      </tr>

      <tr class="maker">
        <th>メーカー</th>
        <td>
          <input type="text" name="maker" class="maker" value="{$machine.maker}" placeholder="メーカー名選択 or 自由記入" />
        </td>
      </tr>

      <tr class="model">
        <th>型式</th>
        <td>
          <input type="text" name="model" class="model" value="{$machine.model}" placeholder="型式" />
          <input type="hidden" name="catalog_id" class="catalog_id" value="{$machine.catalog_id}" />
          <div>
            <div class="model_label">電子カタログ<span class="memberonly">(会員のみ公開)</span></div>
            <button class="catalog_search">カタログ検索</button>
            <div class="catalog_area">
              <a href="' + curi + '/catalog_pdf.php?id={$machine.catalog_id}" target="_blank">
                {$machine.catalog_id}
              </a>
            </div>
          </div>
        </td>
      </tr>

      <tr class="year">
        <th>年式</th>
        <td>{html_options name=year options=$yearList selected=$machine.year}</td>
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
          <textarea name="spec" class="spec" placeholder="能力項目以外のその他仕様などを入力してください">{$machine.spec}</textarea>
        </td>
      </tr>

      <tr class="accessory">
        <th>附属品</th>
        <td>
          <input type="text" name="accessory" class="accessory" value="{$machine.accessory}" placeholder="附属品を入力してください" />
        </td>
      </tr>

      <tr class="comment">
        <th>コメント</th>
        <td>
          <textarea name="comment" class="comment"
            placeholder="この商品特有のコメントを入力してください(取説あり、塗装できますなど)">{$machine.comment}</textarea>
        </td>
      </tr>

      <tr class="commission">
        <th>試運転</th>
        <td>
          {html_radios name='commission' options=['' => '不可', '1' => '可']
         selected=$machine.commission separator=' '}
        </td>
      </tr>

      <tr class="location">
        <th>在庫場所</th>
        <td class="office">
          <input type="text" name="location" class="location" value="{$machine.location}" placeholder="在庫場所" /><br />

          住所
          <input type="text" name="addr1" class="addr1" value="{$machine.addr1}" placeholder="都道府県" />
          <input type="text" name="addr2" class="addr2" value="{$machine.addr2}" placeholder="市区町村" />
          <input type="text" name="addr3" class="addr3" value="{$machine.addr3}" placeholder="番地その他" /><br />

          緯度経度(住所から自動入力)
          <input type="text" name="lat" class="lat" value="{$machine.lat}" placeholder="緯度(住所から自動入力)" />
          <input type="text" name="lng" class="lng" value="{$machine.lng}" placeholder="経度(住所から自動入力)" />

        </td>
      </tr>

      <tr class="maker">
        <th>金額<span class="memberonly">(会員のみ公開)</span></th>
        <td>
          <input type="text" name="price" class="price number" value="{$machine.price}" placeholder="金額(数字で入力)" />円
          {*
      {html_radios name='price_tax' options=['' => '税込価格', '1' => '税抜']
       selected=$machine.price_tax separator=' '}
      *}
          {html_options name='price_tax' options=['' => '仲間価格(税込価格)', '1' => '仲間価格(税抜き)', '2' => 'ユーザ価格(税込価格)', '3' => 'ユーザ価格(税抜き)']
         selected=$machine.price_tax separator=' '}
        </td>
      </tr>

      <tr class="top_img">
        <th>TOP画像</th>
        <td>
          <span class="alert">※</span> 登録できる画像ファイル形式はJPEGのみです<br />
          <iframe name="upload" class="upload" src="../ajax/upload.php?c=top_img&t=image/jpeg" frameborder="0"
            allowtransparency="true"></iframe>
          <div class="upload_img">
            {if !empty($machine.top_img)}
              <div class="img">
                <label><input type="checkbox" name="top_img_delete" value="{$machine.top_img}" />削除</label>
                <br />
                <a href='{$_conf.media_dir}machine/{$machine.top_img}' target="_blank">
                  <img src='{$_conf.media_dir}machine/{$machine.top_img}' />
                </a>
                <input type="hidden" name="top_img" value="{$machine.top_img}" />
              </div>
            {/if}
          </div>
        </td>
      </tr>

      <tr class="imgs">
        <th>画像(複数可)</th>
        <td>
          <iframe name="upload" class="upload" src="../ajax/upload.php?c=imgs&t=image/jpeg&m=1" frameborder="0"
            allowtransparency="true"></iframe>
          <div class="upload_img">
            {foreach $machine.imgs as $i}
              <div class="img">
                <label><input type="checkbox" name="imgs_delete[]" value="{$i}" />削除</label>
                <br />
                <a href='{$_conf.media_dir}machine/{$i}' target="_blank">
                  <img src='{$_conf.media_dir}machine/{$i}' />
                </a>
                <input type="hidden" name="imgs[]" value="{$i}" />
              </div>
            {/foreach}
          </div>
        </td>
      </tr>

      <tr class="pdfs">
        <th>PDF(複数可)</th>
        <td>
          <iframe name="upload" class="upload" src="../ajax/upload.php?c=pdf&t=application/pdf&m=1" frameborder="0"
            allowtransparency="true"></iframe>
          <div class="upload_pdf"></div>

          {foreach $machine.pdfs as $key => $i}
            <div class="pdf">
              <a href='{$_conf.media_dir}machine/{$i}' target="_blank">PDF</a>
              <input type="text" name="pdfs[{$i}]" value="{$key}" placeholder="ラベル" />
              削除<input type="checkbox" class="delete" name="pdfs_delete[]" value="{$i}" />
            </div>
          {/foreach}
        </td>
      </tr>

      <tr class="youtube">
        <th>YouTube ID</th>
        <td>
          <input type="text" name="youtube" class="youtube" value="{$machine.youtube}"
            placeholder="YouTube IDを入力してください" /><br />
          表示させる動画の「共有」ボタンで表示されるURLを入力してください<br />
          空白区切りで復数登録が可能です<br />
          ※ 動画のアップロードは予め
          <a href="https://www.youtube.com/?gl=JP&hl=ja" target="_blank">YouTube</a>
          で行なってください
        </td>
      </tr>

      <tr class="view_option">
        <th>表示オプション</th>
        <td>
          {html_radios name='view_option' options=['' => '表示', '1' => '非表示', '2' => '商談中']
         selected=$machine.view_option separator=' '}
        </td>
      </tr>

      {*
  <tr class="org_label">
    <th rowspan=2>独自ラベル</th>
    <td>
      テキスト :
      <input type="text" name="label_title" class="label_title" value="{$machine.label_title}"
        placeholder="表示されるテキスト" /><br />
      リンク先URL :
      <input type="text" name="label_url" class="label_url" value="{$machine.label_url}"
        placeholder="リンク先URL(あれば)" /><br />
      文字色 :
      <input type="color" class="label_color" name="label_color" value="{$machine.label_color|default:'#ffffff'}" />

      <h4>表示サンプル</h4>
      <div class="label_sample"></div>
  </tr>
*}
    </table>

    <button type="submit" name="submit" class="submit" value="member">変更を反映</button>

  </form>

  {*** 電子カタログ一覧 ***}
  <div class="catalog_list">
    <table>
      <thead>
        <tr>
          <th class="maker">メーカー<br />ジャンル</th>
          <th class="img"></th>
          <th class="model">型式</th>
          <th class="year">作成年<br />カタログNo</th>
        </tr>
        <thead>
        <tbody></tbody>
    </table>
  </div>

{/block}