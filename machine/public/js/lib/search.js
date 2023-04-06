/**
 * 在庫機械表示共通Javascropt
 */


/**
 * 在庫機械一覧オブジェクト
 *
 */
function MachineList()
{
    /**
     * コンストラクタ
     *
     * @access public
     */
    // クロージャ
    var self = this;

    // ローカル変数の初期化
    var mapDefault = new google.maps.LatLng(37.44446074079564, 137.2412109375);
    var mapMarker   = 'https://maps.google.co.jp/mapfiles/ms/icons/red-dot.png';
    var mapBMarker  = 'https://maps.google.co.jp/mapfiles/ms/icons/blue-dot.png';

    var pageLimit = 50;
    var page      = 1;
    var pageNum   = 1;
    var template  = 'list';
    var pageArray = new Array(pageLimit);

    var list      = [];
    var fKeys     = [];
    var adds      = {};
    var stats     = [];
    var os        = {};

    // テンプレートコンパイル
    $.templates({
        list_tmpl: $("#list_tmpl").html(),
        pager_tmpl: $("#pager_tmpl").html(),
        img_tmpl: $("#img_tmpl").html(),
        map_tmpl: $("#map_tmpl").html(),
        maplocation_area_tmpl: $('#maplocation_area_tmpl').html()
    });

    /// 機械一覧の初期化 ///
    var search = location.search;
    if (location.pathname == '/mylist.php') {
        search += (!search ? '?' : '&') + 'mylist=1'
    }
    $.get("/ajax/search.php" + search, function(data){
        try {
            var d = $.parseJSON(data);
            list = d['machineList'];
            os   = d['os'];
        } catch (e) { console.log(data) }

        // ハッシュからページ切り替え
        var p = 1;
        /*
        if (location.hash != '') {
            $.each(location.hash.split('&'), function(i, val) {
                if (val.match(/^p=(.+)$/)) { p = RegExp.$1; }
                else if (val.match(/^t=(.+)$/)) { template = RegExp.$1; }
            });
        }
        */

        self.filtering('nochange');
    });

    /// 検索条件リスト ///
    this.$_genreList    = $('.genre_area input');
    this.$_makerList    = $('.maker_area input');
    this.$_inputModel   = $('#model2');
    // this.$_locationList = $('.location_area input');
    this.$_locationList = $('select.location');
    this.$_capacityList = $('.capacity_area input');

    /**
     * ページ切り替え
     *
     * @access public
     * @param integer p ページ番号
     * @return this
     */
    this.pager = function(p)
    {
        if (p == '<<先頭')      { p = 1; }
        else if (p == '<前へ')  { p = page - 1; }
        else if (p == '次へ>')  { p = page + 1; }
        else if (p == '最終>>') { p = pageNum; }

        if (!p)               { p = 1; }
        else if (p > pageNum) { p = pageNum || 1; }

        page = parseInt(p);

        if (pageNum > 15) {
            $('.pager a.num').hide();
            for (var i = page-7; i < page+8; i++) {
                $('.pager a.num.p_' + i).show();
            }
        }

        $('.pager a.current').removeClass('current');
        $('.pager a.num.p_' + page).addClass('current');
        this.refine();

        return this;
    }

    /**
     * 表示テンプレート切り替え処理
     *
     * @access public
     * @param integer t 表示テンプレート
     * @return this
     */
    this.template = function(t)
    {
        template = t;
        $('.machine_tab a.selected').removeClass('selected');
        $('.machine_tab a.' + t + '_tab').addClass('selected');

        // 表示切替
        $('.machine_list').hide();
        $('.machine_list.' + t).fadeIn();

        this.refine();
        return this;
    }

    /**
     * 絞り込み処理
     *
     * @access public
     * @param integer p ページ番号
     * @return this
     */
    this.filtering = function(p)
    {
        // 絞り込み条件の抽出
        var sGenre = this.$_genreList.filter(':checked').map(function() { return parseInt($(this).val()); }).get();
        // var sMaker = this.$_makerList.filter(':checked').map(function() { return $(this).val(); }).get();
        var sMaker = [];
        this.$_makerList.filter(':checked').each(function() {
            sMaker = sMaker.concat($(this).val().split('|'));
        });

        // var sLocation = this.$_locationList.filter(':checked').map(function() { return $(this).val(); }).get();
        var sLocation = this.$_locationList.val();

        // var sCapacity = this.$_capacityList.filter(':checked').map(function() { return $(this).val(); }).get();
        var sCapacity = this.$_capacityList.filter(':checked');

        // 型式
        var sModel = mb_convert_kana(this.$_inputModel.val(), 'KVrn').toUpperCase().replace(/[^A-Z0-9]/g, '');
        var moRe = new RegExp(sModel);

        // 絞り込み処理
        fKeys = [];
        $.each(list, function(i) {
            if (sGenre.length && $.inArray(this.genre_id, sGenre) == -1) { return true; }
            if (sMaker.length && $.inArray(this.maker, sMaker) == -1) { return true; }
            // if (sLocation.length && $.inArray(this.addr1, sLocation) == -1) { return true; }
            if (sLocation != '' && (this.addr1 != sLocation && this.region != sLocation)) { return true; }
            // if (sCapacity.length && $.inArray(this.capacity + this.capacity_unit, sCapacity) == -1) { return true; }
            if (sCapacity.length) {
                var isLo  = true;
                var cap   = parseInt(this.capacity);
                var unit  = this.capacity_unit;
                var label = this.capacity_label;
                sCapacity.each(function() {
                    if ($(this).data('unit') == unit && $(this).data('label') == label &&
                      cap >= parseInt($(this).val()) && cap < parseInt($(this).data('max'))) {
                        isLo = false;
                    }
                });
                if (isLo == true) { return true; }
            }

            if (sModel =! '' && !this.model2.match(moRe)) { return true; }

            fKeys.push(i);
        });

        // ページャ再生成
        pageNum = Math.ceil(fKeys.length / pageLimit);
        $('.pager').html($.render.pager_tmpl({
            'num'       : fKeys.length,
            'pageNum'   : pageNum,
            'pageArray' : Array(pageNum),
            'pageLimit' : pageLimit
        }));

        // ソート処理初期化
        if (p != 'nochange') {
            this.sort();
        } else {
            // Lazyload用スクロール
            $(window).triggerHandler('scroll');
        }

        return this;
    }

    // ソート処理
    this.sort = function(column)
    {
        var sort = $('.sort_area input:checked').val();

        if (!sort) {
            fKeys.sort(function(a, b) { return a - b; });
        } else {
            // ソート条件を取得
            sort.match(/(.*)_(.*)/);
            var column = RegExp.$1;

            fKeys.sort(function(a, b) {
                if (!list[b][column]) { return -1; }
                else if (!list[a][column]) { return 1; }

                return (RegExp.$2 == 'desc' ? 1 : -1) * (list[b][column] - list[a][column]);
            });
        }

        this.pager(1);
        return this;
    }

    /**
     * 表示リファイン
     *
     * @access public
     * @return this
     */
    this.refine = function()
    {
        if (template == 'list') {
            var $_machines = $('.machine_list table.machines.list');
            var contents = '<thead>' + $_machines.find('thead').html() + '</thead>';
            var offset = (page-1) * pageLimit;

            $.each(pageArray, function(i){
                if (fKeys[offset + i] == undefined ) { return true; }

                var m = list[fKeys[offset + i]];

                // テンプレート用にデータ整形
                if (m['pdfs'] && !m['_render_pdfs']) {
                    m['_render_pdfs'] = $.map(m['pdfs'], function(d, key) {
                         return {'key':key, 'data':d};
                    });
                }

                // テンプレートにレンダリング
                contents += $.render.list_tmpl(m);
            });

            $_machines.html(contents).hide().fadeIn('fast');
        } else if (template == 'img') {
            var $_machines = $('.machine_list table.machines.img');
            var contents = '';
            var offset = (page-1) * pageLimit;

            $.each(pageArray, function(i){
                if (fKeys[offset + i] == undefined ) { return true; }

                var m = list[fKeys[offset + i]];

                // 画像がない場合はスキップ
                if (!m['top_img']) { return true; }

                // テンプレート用にデータ整形
                if (m['imgs'] && !m['_render_imgs']) {
                    m['_render_imgs'] = $.map(m['imgs'], function(d, key) {
                         return {'id':m['id'], 'img':d};
                    });
                }

                if (m['youtube'] && !m['_render_youtube']) {
                    m['_render_youtube'] = m['youtube'].replace(/http:\/\/youtu.be\//, '');
                }

                // テンプレートにレンダリング
                contents += $.render.img_tmpl(m);
            });
            $_machines.html(contents).hide().fadeIn('fast');
        } else if (template == 'map') {
            var $_machines = $('.machine_list .machines.map');

            // マーカー情報生成
            adds   = {};
            states = [];
            $.each(fKeys, function(key, i){
                var m = list[i];

                // 緯度経度がない場合はスキップ
                if (!m['lat'] || !m['lng']) { return true; }

                var address = m['addr1'] + m['addr2'] + m['addr3'];
                if (!adds[address]) {
                    adds[address] = { 'elem': m, 'keys': [] }
                }
                adds[address]['keys'].push(i);

                if ($.inArray(m.addr1, states) == -1) { states.push(m.addr1); }
            });
            $_machines.html('マーカーにマウスオーバーすると<br />ここに機械情報が表示されます').hide().fadeIn();

            // マップの生成
            this.mapMake('#gmap');
        }

        /// サムネイル画像の遅延読み込み再設定 ///
        this.lazyload();

        // location.hash = 't=' + template + '&p=' + page;

        return this;
    }

    /**
     * すべて表示処理
     *
     * @access public
     * @return this
     */
    this.reset = function($_target)
    {
        $_target.removeAttr('checked');
        this.filtering();
        return this;
    };

    /**
     * 地図の生成
     *
     * @access public
     */
    this.mapMake = function(expr)
    {
        /// 地図の初期化、イベントの初期化(1回だけ実行) ///
        if (!self.map) {
            // googlemap生成
            self.gc  = new google.maps.Geocoder(); // ジオコーディング
            self.map = new google.maps.Map($(expr).get(0), {
                mapTypeId : google.maps.MapTypeId.ROADMAP
            });

            /// 地図用メソッドの生成 ///
            /**
             * 地図移動
             */
            self.mapMove = function(address, zoom)
            {
                address = $.trim(address);
                // ジオコーディング
                self.gc.geocode({'address': address},
                function(results, status) {
                    if (status != 'OK') { return true; }
                    self.map.setCenter(results[0].geometry.location);
                    self.map.setZoom(zoom || 13);
                });

                return self;
            };

            /**
             * アイコン点滅
             *
             * @param object marker マーカーオブジェクト
             */
            self.mapBrinkMarker = function(add)
            {
                // マーカー点滅タイマ解除
                self.mapClearMarker();

                if (!add || !add.marker) { return self; }

                // マーカー点滅開始
                timerMarker = add.marker; // クロージャ
                clearTimeout(this.mapTimerObj);
                this.mapTimerObj = setInterval(function() {
                    var icon = timerMarker.getIcon().match(/red/i) ? mapBMarker : mapMarker;
                    timerMarker.setIcon(icon);
                }, 300);

                // ウィンドウを開く
                add.infowin.open(add.marker.getMap(), add.marker);
                // 現在のマーカーを保持
                self.nowAdd = add;

                return self;
            }

            /**
             * アイコン点滅、ウィンドウ表示解除
             */
            self.mapClearMarker = function()
            {
                if (self.nowAdd) {
                    clearInterval(this.mapTimerObj);
                    self.nowAdd.marker.setIcon(mapMarker);
                    self.nowAdd.infowin.close();
                }
                return self;
            };

            /**
             * 表示位置リセットリセット
             */
            self.reset = function()
            {
                 // 地図の位置のリセット
                self.map.setCenter(mapDefault);
                self.map.setZoom(5);

                // ズーム枠(都道府県)
                $('.maplocation_area').html($.render.maplocation_area_tmpl({'label':'都道府県', 'deep':'state', 'data':states}));

                return self;
            }

            /// 地図移動イベントハンドラ ///
            $('.maplocation_area.state a.move').live('click', function() {
                var state = $(this).text();
                self.mapMove(state, 9);

                /// 市区町村絞り込み生成 ///
                var cities = [];
                $.each(fKeys, function(key, i){
                    var m = list[i];

                    // 緯度経度がない場合はスキップ
                    if (!m['lat'] || !m['lng']) { return true; }
                    if (m.addr1 == state && $.inArray(m.addr2, cities) == -1) {
                        cities.push(m.addr2);
                    }
                });
                $('.maplocation_area').html($.render
                    .maplocation_area_tmpl({'label':'市区町村', 'deep':'city', 'now':state, 'data':cities})
                );

                return false;
            });

            $('.maplocation_area.city a.move').live('click', function() {
                self.mapMove($('input.now_state').val() + $(this).text(), 13);
                return false;
            });

            $('.maplocation_area.city a.remove').live('click', function() {
                self.mapMove($('input.now_state').val(), 9);
                return false;
            });

            // 地図の位置のリセット
            $('.maplocation_area .state_all').live('click', function() {
                self.reset();
                return false;
            });
        }

        /// リセット処理 ///
        // 表示位置リセット
        self.reset();

        // マーカー点滅タイマ解除
        self.mapClearMarker();

        // マーカーの設定(再設定)
        $.each(adds, function(key, add) {
            /// マーカークリックでウィンドウ生成の内容 ///
            var msg = '<a class="map_company" href="company_detail.php?c=' + add.elem.company_id + '">' + add.elem.company + '</a>' +
                '<div class="map_location">' + add.elem.location + '</div>' +
                '<div class="map_pure_addr">' + key + '</div>' +
                '<div class="map_machine_num"><strong>' + add.keys.length + '</strong>件</div>';

            // すでにマーカーがある場合は、内容だけ変更
            if(add.marker) {
                add.marker.setMap(self.map);
                add.infowin.setContent(msg);
                return true;
            }

            // マーカー・中央値の設定
            var marker = new google.maps.Marker({
                map: self.map,
                position: new google.maps.LatLng(add.elem.lat, add.elem.lng),
                icon: mapMarker
            });

            /// ウィンドウの生成 ///
            var infowin = new google.maps.InfoWindow({content:msg});

            /// マーカーとウィンドウをこのオブジェクトに登録 ///
            add.marker  = marker;
            add.infowin = infowin;

            /// MAPのイベントハンドラ登録 ///
            // マーカーmouseoverで開く
            google.maps.event.addListener(marker, 'mouseover', function(event) {
                // マーカー点滅・ウィンドウを表示
                self.mapBrinkMarker(add);

                // テンプレートをレンダリング
                var contents = '';
                $.each(add.keys, function(key, i) {
                    contents += $.render.map_tmpl(list[i]);
                });
                $('.machine_list .machines.map').html(contents).hide().fadeIn();

                // Lazyload再生成
                self.lazyload();
            });
        });
    }

    /// lazyloadのセット ///
    this.lazyload = function()
    {
        $('img.lazy').lazyload({
            effect : "fadeIn",
            threshold : 400,
            failure_limit: 0,
            appear: function(l, settings) {
                var $_self = $(this);
                $("<img />").error(function() {
                    $_self.attr('src', 'imgs/noimage.png');
                    return true;
                }).attr("src", $_self.data(settings.data_attribute));
            }
        });

        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
    }

    // ページ表示数切り替え
    this.setPageLimit = function(val)
    {
        pageLimit = parseInt(val);
        pageArray = new Array(pageLimit);

        self.filtering();
        return this;
    }
}

$(function() {
    /// 在庫一覧オブジェクト ///
    var ml = new MachineList();

    /// サムネイル画像の遅延読み込み（Lazyload） ///
    ml.lazyload();

    /// イベントハンドラ ///
    // ページャ
    $('.pager a.num, .pager a.jump').live('click', function() {
        ml.pager($(this).text());
        return false;
    });

    // 絞り込み
    $('.genre_area input:checkbox, .maker_area input:checkbox, ' +
        '.location_area input:checkbox, .capacity_area input:checkbox, select.location')
    .change(function() { ml.filtering(); });

    // キーボード入力時にもイベント発生
    $('input#model2').keyup(function() { ml.filtering(); });

    // すべて表示
    $('a.maker_all').click(function() { ml.reset(ml.$_makerList); return false; });
    $('a.genre_all').click(function() { ml.reset(ml.$_genreList); return false; });
    // $('a.addr1_all').click(function() { ml.reset(ml.$_locationList); return false; });
    $('a.addr1_all').click(function() { $('select.location').val('').change(); return false; });
    $('a.capacity_all').click(function() { ml.reset(ml.$_capacityList); return false; });

    $('.all_clear').button().live('click', function() {
        ml.$_locationList.val('');
        ml.$_inputModel.val('');
        ml.reset(ml.$_genreList);
        ml.reset(ml.$_makerList);
        ml.reset(ml.$_capacityList);
        return false;
    });

    // 表示数変更
    $('select.limit').live('change', function() {
        ml.setPageLimit($(this).val());
        $('select.limit').val($(this).val());
    });

    // メーカーもっと見る表示・非表示切り替え
    $('a.maker_other_show').click(function() {
        if ($(this).text() == '▲閉じる▲') {
            $('.maker_area li.other').css('display', 'none');
            $(this).text('▼もっと表示▼');
        } else {
            $('.maker_area li.other').css('display', 'inline-block');
            $(this).text('▲閉じる▲');
        }
        return false;
    });

    // ソート
    $('.sort_area input:radio').live('change', function() { ml.sort(); });

    /// 画像拡大処理 ///
    // 表示枠の作成
    $('<img class="hoverimg">').appendTo('body').hide();

    // 表示・非表示処理
    $('.machine_list img.hover').live('mouseover', function() {
        $('.hoverimg')
            // .attr('src', $(this).attr('src'))
            // .css('top', $(this).offset().top - ($('.hoverimg').height() - $(this).height()) / 2)
            .attr('src', $(this).data('source'))
            .css('top', $(this).offset().top - $(this).height() / 2)
            .css('left', $(this).offset().left + $(this).width() + 16)
            .show();
    }).live('mouseout', function() { $('.hoverimg').hide(); });

    /// 表示切替 ///
    $('.machine_tab a').click(function() {
        if ($(this).attr('class').match(/([0-9a-zA-Z]+)_tab/)) { ml.template(RegExp.$1); }
        return false;
    });

    /// 画像で表示 スクロールリスト ///
    $('.scrollRight').live('click', function() {
        $_i = $(this).parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() + $_i.width()}, 1000, 'easeOutCubic');
        $(window).triggerHandler('scroll');
    });

    $('.scrollLeft').live('click', function() {
        $_i = $(this).parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() - $_i.width()}, 1000, 'easeOutCubic');
        $(window).triggerHandler('scroll');
    });

    /// 動画ボタン再生 ///
    // $('button.movie').live('click', function() {
    //     if (!$('#movie_dialog').length) {
    //         $('<div id="movie_dialog" style="width:640px;height:480px;">').appendTo('body');
    //     }

    //     var $_moDir = $('#movie_dialog');
    //     var contents = '<iframe width="640" height="480" id="movie_dialog" ' +
    //         'src="https://www.youtube.com/embed/' +
    //         $(this).val() + '?rel=0" frameborder="0" allowfullscreen></iframe>';

    //     $_moDir.html(contents).dialog({
    //         show: "fade",
    //         hide: "fade",
    //         closeText: '閉じる',
    //         title: '動画の再生',
    //         width: 675,
    //         height: 540,
    //         resizable: false,
    //         modal: true,
    //         close: function() { $_moDir.empty(); }
    //     });

    //     return false;
    // });

    // 期間指定の処理
    $('input[name=pe][type=radio]').change(function() {
        $("#start_date").val('');
        $('#period_form').submit();
    });

    // 日付指定イベントハンドラ、datepicker
    $("#start_date").change(function() {
        $('input[name=pe][type=radio]').val('');
        $('#period_form').submit();
    }).datepicker({
        showAnim    : 'fadeIn',
        prevText    : '',
        nextText    : '',
        dateFormat  : 'yy-mm-dd',
        altFormat   : 'yy-mm-dd',
        appendText  : '',
        maxDate     : '+0d',
        minDate     : '2011-07-07'
    });

    // lazyload用のスクロールイベント
    $('.machines.map').scroll(function() {
        $(window).triggerHandler('scroll');
    });
});
