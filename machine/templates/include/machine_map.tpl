{literal}
  <!-- Google Maps APL ver 3 -->
  <script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>

  <script language="JavaScript" type="text/javascript">
    var infowindow = [];

    var timerObj;
    var timerMarker;

    // 地図で表示フラグ
    var isMap = true;

    $(function() {
      /*
    // ジオコーディング
    gc = new google.maps.Geocoder();

    //// 地図の初期化 ////
    map = new google.maps.Map(document.getElementById("gmap"), {
        zoom : 22,
        center : new google.maps.LatLng(34.686099, 135.601362),
        mapTypeId : google.maps.MapTypeId.ROADMAP
    });

    //// 表示する会社名を取得 ////
    $('.machine').each(function() {
        var $self = $(this);
gc.geocode({'address': $self.find('.pure_address').text()},
      function(results, status) {
        if (!results) { return true; }
        if (!results[0]) { return true; }
        // マーカー・中央値の設定
        var marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
          icon: "img/100305_orange.gif"
        });

        //// マーカークリックでウィンドウ生成 ////
        msg = "<div class='map_company company_" + $self.find('.company_id').text() + "'>" + $self.find(
          '.company_name').text() + "</div>";
        msg += "<div class='map_address'>" + $self.find('.pure_address').text() + "</div>";

        // ウィンドウ内に登録機械概要を表示
        var num = 0;
        var summary = '<div class="map_machine_list">';
        summary += $('.machine.company_' + $self.find('.company_id').text())
          // .addClass('area_1')
          .map(function() {
            num++;
            s = "<div class='map_machine'>" + num + '. ' + $(this).find('.name').text();
            s += ' ' + $(this).find('.maker').text();
            s += ' ' + $(this).find('.model').text();
            s += '</div>';

            return s;
          }).get().join(' ');
        summary += '</div>';

        //// ウィンドウの生成 ////
        var infowin = new google.maps.InfoWindow({ content: msg + summary });

        //// イベント登録 ////
        // マーカーmouseoverで開く
        google.maps.event.addListener(marker, 'mouseover', function(event) {

          // マーカーのwindowを閉じる
          for (var i = 0; i < infowindow.length; i++) {
            infowindow[i].close();
          }
          infowin.open(marker.getMap(), marker);

          // ウィンドウ内の会社名クリックで、機械情報表示の変更
          $('.map_company.company_' + $self.find('.company_id').text()).click(function() {
            $('.map.machine_list .machine').hide();
            $('.machine.company_' + $self.find('.company_id').text()).show();
          });

          $('.machine.company_' + $self.find('.company_id').text()).addClass('map_hoverd');

          // マーカー点滅
          timerObj = brinkMarker(marker);
        });

        // マーカーmouseoutで閉じる
        google.maps.event.addListener(marker, 'mouseout', function(event) {
          $('.map_hoverd').removeClass('map_hoverd');

          // マーカー点滅タイマ解除
          marker.setIcon('./img/100305_orange.gif');
          clearInterval(timerObj);
        });

        // 機械情報部分でのマーカー点滅・解除
        $('.machine.company_' + $self.find('.company_id').text()).hover(function() {
            $(this).addClass('map_hoverd');
            timerObj = brinkMarker(marker);
          },
          function() {
            $('.map_hoverd').removeClass('map_hoverd');
            marker.setIcon('./img/100305_orange.gif');
            clearInterval(timerObj);
          });

        // ウィンドウを配列に登録
        infowindow.push(infowin);
      }
    );
    });
    */
    //// 会社、地域データのJSON読み込み ////
    /*
  $.getJSON('./js/json/company_place.json', function(json) {
      // var companies = json.companies;
      var areas = json.areas;

      //// mapの中心移動（エリア選択）リンク生成 ////
      count = areas.length;
      for (var i = 0;  i < count; i++) {
          attachSetCenter(areas[i].id, areas[i].name, new google.maps.LatLng(areas[i].center[0], areas[i].center[1]));
      }

      //// 中心位置の初期化 ////
      $('.machine_container .area a').first().click();
  });
  */

    // lazyload用のスクロールイベント
    $('.machine_list.map').scroll(function() {
    $(window).triggerHandler('scroll');
    });
    });

    /**
   * アイコン点滅
   *
   * @return timerObj タイムアウトオブジェクト
   */
    /*
  function brinkMarker(marker)
  {
      timerMarker = marker;
      var timerObj = setInterval(function() {
          var icon = marker.getIcon().match(/orange/i) ? './img/100305_blue.gif' : './img/100305_orange.gif';
          timerMarker.setIcon(icon);
      }, 300);

      return timerObj;
  }
  */
    /**
   * 地図移動
   */
    /*
  function attachSetCenter(id, name, center)
  {
      $("<a href='#'>" + name + "</a>").click(function() {
          map.setCenter(center);
          map.setZoom(17);

          $('.machine_container .area a.selected').removeClass('selected');
          $(this).addClass('selected');

          // 機械情報表示の変更
          $('.map.machine_list .machine').hide();
          $('.map.machine_list .machine.area_' + id).show();

          // lazyload用のスクロールイベント
          $(window).triggerHandler('scroll');

          return false;
      }).appendTo('.machine_container .area');
  }
  */
  </script>
  <style type="text/css">
    .map_machine_list {
      max-height: 120px;
      overflow: auto;
    }
  </style>
{/literal}

<div class='machine_container'>
  <div class='area'>
  </div>

  {*** GoogleMap ***}
  <div id="gmap"></div>

  <div class='machine_list map'>
    {foreach from=$machineList item=m name='ml'}
      <div class='machine machine_{$m.id} company_{$m.company_id} area_1'>
        <div class='status'>

          <div class='hidden no'>{$smarty.foreach.ml.index|string_format:"%04d"}</div>
          <div class="company_id hidden">{$m.company_id}</div>
          <div class="hidden pure_address">{$m.location_address}</div>

          <div class='hidden genre_id'>{$m.genre_id}</div>
          <div class='hidden model2'>{'/[^A-Z0-9]/'|preg_replace:'':($m.model|mb_convert_kana:'KVrn'|strtoupper)}</div>
          <div class='hidden created_at'>{$m.created_at|strtotime}</div>
          <div class="hidden location_address">{'/(都|道|府|県)(.*)$/'|preg_replace:"$1":$m.location_address}</div>
          <div class="hidden location">{$m.location}</div>

          {*
        {if $m.created_at|strtotime > '-7day'|strtotime}<div class='new'>新着</div>{/if}
        *}
          <div class='name'>{$m.name}</div>
          <div class='maker'>{$m.maker}</div>
          <div class='model'>{$m.model}</div>
          <div class='year'>{$m.year}</div>

          <a class='contact' href='/contact.php?m={$m.id}'>問い合わせ</a>
          <button class='mylist' value='{$m.id}'>マイリスト</button>
        </div>

        <div class='company_info'>
          <a href='/machine_detail.php?m={$m.id}'>
            {if !empty($m.top_img)}
              <img class="top_image lazy" src='img/blank.png' data-original="{$_conf.media_dir}machine/{$m.top_img}"
                alt="" />
              <noscript><img src="{$_conf.media_dir}machine/{$m.top_img}" alt="" /></noscript>
            {else}
              <img class='top_image noimage' src='./img/noimage.jpg' />
            {/if}
          </a>

          <div class='company'><a href='/company_detail.php?c={$m.company_id}'>{$m.company}</a></div>
          <div class='tel'>TEL : {$m.tel}</div>
          <div class='fax'>FAX : {$m.fax}</div>
        </div>

        <div style='clear:both;'></div>
      </div>
    {/foreach}
  </div>
</div>

{*
<div class="company_list" style="display:none;">
{foreach $companyList  as $c}
  <div class="company">
    <div class="company_id">{$c.id}</div>
    <div class="company_name">{$c.company}</div>
    <div class="pure_address">{$c.address}</div>
  </div>
{/foreach}
</div>
*}