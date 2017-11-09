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
    var capacities = {};
    var locations  = [];
    var zoom_addresses = [];
    var addresses  = {};
    var mapDefault = new google.maps.LatLng(37.44446074079564, 137.2412109375);
    
    //// 在庫機械一覧JQO生成 ////
    this.$_list = $('.machine');
    this.$_list.each(function() {
        var $_self = $(this);
        
        // DOMからデータの抽出・格納
        this.id         = $_self.data('id');
        
        this.mapMachine = $('.map_machine[data-id=' + this.id + ']');
        this.imgMachine = $('.img_machine[data-id=' + this.id + ']');
        
        this.name       = $.trim($_self.find('.name').text());
        this.maker      = $.trim($_self.find('.maker').text());
        this.genre_id   = $.trim($_self.find('.genre_id').text());
        this.model      = $.trim($_self.find('.model').text());
        this.model2     = $.trim($_self.find('.model2').text());
        this.created_at = $.trim($_self.find('.created_at').text());
        this.addr1      = $.trim($_self.find('.location_address').text());
        this.location   = $.trim($_self.find('.location').text());
        
        // 能力
        this.capacity       = parseFloat($_self.find('.capacity').text());
        this.capacity_unit  = $.trim($_self.find('.capacity_unit').text());
        this.capacity_label = $.trim($_self.find('.capacity_label').text());
        this.capacity2      = this.capacity + this.capacity_unit;
        
        // 地図で表示用の営業所情報
        this.pure_addr = $.trim($_self.find('.pure_addr').text());
        this.zoom_addr = $.trim($_self.find('.zoom_addr').text());
        this.company   = $.trim($_self.find('.company').text());
        this.lat       = $.trim($_self.find('.lat').text());
        this.lng       = $.trim($_self.find('.lng').text());
        
        // 営業所格納
        // if (this.pure_addr != '') {
        if (this.pure_addr != '' && this.lat != '' && this.lng != '' ) {
            var key = this.company + ' ' + this.location;
            
            // 格納するキーのオブジェクトがなければ生成
            if (!addresses[key]) {
                addresses[key] = {
                    'company'  : this.company,
                    'location' : this.location,
                    'pure_addr' : this.pure_addr,
                    'addr1' : this.addr1,
                    'location' : this.location,
                    'lat' : this.lat,
                    'lng' : this.lng,
                    'elems'  : [],
                    'firstElem' : this
                };
            }
            addresses[key].elems.push(this);
            
            // 機械情報と営業所情報でポインタを持ち合う
            this.myAdd = addresses[key];
            
            // 在庫場所(都道府県)格納
            locations.push(this.zoom_addr);
        }
        
        // 主能力格納
        if (this.capacity > 0) {
            var key = this.capacity_label + this.capacity_unit;
            
            // 格納するキーのオブジェクトがなければ生成
            if (!capacities[key]) {
                capacities[key] = {
                    'label' : this.capacity_label,
                    'unit'  : this.capacity_unit,
                    'vals'  : [],
                    'firstElem' : this
                };
            }
            
            // 旋盤のみの独自仕様(尺とmmを混在、数値化しない)
            if (this.capacity_label == '芯間') {
                this.capacity2 =
                    this.capacity >= 2000 ? this.capacity + 'mm' :
                    this.capacity >= 1500 ? '9尺' :
                    this.capacity >= 1200 ? '8尺' :
                    this.capacity >= 1000 ? '7尺' :
                    this.capacity >= 800  ? '6尺' :
                    this.capacity >= 600  ? '5尺' :
                    this.capacity >= 360  ? '4尺' :
                    this.capacity >= 240  ? '3尺' : '';
            }
            capacities[key].vals.push(this.capacity2);
        }
    });
    
    //// 在庫場所絞り込みリスト生成 ////
    locations.sort();
    // ユニーク化・表示の生成
    var d = '<div class="location_area">' +
        '<li><span class="area_label">在庫場所</span>：' +
        '<a class="location_all" href="#">すべて表示</a></li>';
    
    // 在庫場所ズームボタン
    var d2 = '<div class="map_location_area">' +
        '<li><span class="area_label">ズーム</span>：' +
        '<a class="map_location_all move">全国</a></li>';
    
    var num  = 0;
    $.each(locations, function(i, val) {
        var next = locations[i+1];
        num++;
        if (val != next) {
            d += '<li><label><input type="checkbox" name="lo[]" value="' + val + '" />' +
                val + '(' + num + ')' + '</label></li>';
            d2 += '<li><a class="move"> ' + val + '</a></li>';
            num = 0;
        }
    });
    
    d += '</div>';
    d2 += '</div>';
    
    // 表示
    $('div.model2_area').after(d);
    $('#gmap').before(d2);
    
    //// 主能力リスト表示生成 ////
    $.each(capacities, function(key, caps) {
        // ソート
        caps.vals.sort(function(a, b) { return(parseFloat(a) - parseFloat(b)); });
        
        // ユニーク化・表示の生成
        var d = '<tbody><tr class="separator"><td colspan="8" class="capacity_separator"></td></tr>' + 
            '<tr><td colspan="8" class="capacity_area">' +
            '<li><span class="area_label">' + caps.label + '</span>：' +
            '<a class="capacity_all" href="#">すべて表示</a></li>';
        
        var num  = 0;
        $.each(caps.vals, function(i, val) {
            var next = caps.vals[i+1];
            num++;
            if (val != next) {
                d += '<li><label>' +
                    '<input type="checkbox" name="c[]" value="' + val + '" /> ' +
                    val + '(' + num + ')' + '</label></li>';
                num = 0;
            }
        });
            
        d += '</td></tr></tbody>';
        
        // 表示
        $(caps.firstElem).before(d);
    });
    
    //// 検索条件リスト ////
    this.$_genreList    = $('.genre_area input');
    this.$_makerList    = $('.maker_area input');
    /*
    this.$_periodList   = $('input[name="pe"]');
    this.$_periodForm   = $('#period_form');
    this.$_inputDate    = $('#input_date');
    */
    this.$_inputModel   = $('#model2');
    this.$_locationList = $('.location_area input');
    this.$_capacityList = $('.capacity_area input');
    
    //// 新着用、期間の初期値を取得 ////
    /*
    var now = new Date();
    var nowDate = new Date(now.getFullYear() + '/' + (now.getMonth() + 1) + '/' + now.getDate());
    var defaultPeriod = this.$_periodList.filter(':checked').val();
    var defaultTime = '';

    if (defaultPeriod == 'input') {
        // 日付指定
        var inputDate = this.$_inputDate.val();
        if (inputDate != '') {
            var dt = new Date(inputDate);
            defaultTime = dt.getTime() / 1000;
        }
    } else if (defaultPeriod != '') {
        // 期間選択
        defaultTime = nowDate.getTime() / 1000 - defaultPeriod * (60*60*24);
    }
    */

    /**
     * 絞り込み処理
     * 
     * @access public         
     * @return this                  
     */   
    this.refine = function()
    {
        // 期間絞り込み条件
        /*
        var sPeriod = this.$_periodList.filter(':checked').val();
        var dtTime = '';
        
        if (sPeriod == 'input') {
            // 日付指定
            var inputDate = this.$_inputDate.val();
            if (inputDate != '') {
                var dt = new Date(inputDate);
                dtTime = dt.getTime() / 1000;
            }
        } else if (sPeriod != '') {
            // 期間選択
            dtTime = nowDate.getTime() / 1000 - sPeriod * (60*60*24);
        }

        //// デフォルトで期間指定していて、期間をオーバーして場合 ////
        // if (defaultTime != '' && defaultTime > dtTime) {
        if (defaultTime != '') {
            this.$_periodForm.submit();
            return false;
        }
        */
        
        // ジャンル絞り込み条件
        var sGenre = this.$_genreList.filter(':checked')
          .map(function() { return $(this).val(); }).get().join('|');
        var gRe = new RegExp("(^|[|])(" + sGenre + ")($|[|])");
        
        // メーカー絞り込み条件
        var sMaker = this.$_makerList.filter(':checked')
          .map(function() { return $(this).val(); }).get().join('|');
        var maRe = new RegExp("(^|[|])(" + sMaker + ")($|[|])");
        
        // 型式絞り込み条件
        var sModel = this.$_inputModel.val();
        sModel = mb_convert_kana(sModel, 'KVrn')
            .toUpperCase()
            .replace(/[^A-Z0-9]/g, '');
        var moRe = new RegExp(sModel);
        
        // 在庫場所絞り込み条件
        var sLocation = this.$_locationList.filter(':checked')
          .map(function() { return $(this).val(); }).get().join('|');
        var loRe = new RegExp("(^|[|])(" + sLocation + ")($|[|])");
        
        // 主能力絞り込み条件
        var sCapacity = this.$_capacityList.filter(':checked')
          .map(function() { return $(this).val(); }).get().join('|');
        var cRe = new RegExp("(^|[|])(" + sCapacity + ")($|[|])");
        
        // 絞り込み処理
        this.$_list.show().filter(function() {
            /*
            if (dtTime != '' && dtTime > this.created_at) {
                return true;
            } else if (sGenre != '' && !this.genre_id.match(gRe)) {
            */
            if (sGenre != '' && !this.genre_id.match(gRe)) {
                return true;
            } else if (sMaker != '' && !this.maker.match(maRe)) {
                return true;
            } else if (sLocation != '' && !this.zoom_addr.match(loRe)) {
                return true;
            } else if (sCapacity != '' && !this.capacity2.match(cRe)) {
                return true;
            } else if (sModel != '' && !this.model2.match(moRe)) {
                return true;
            } else {
                return false;
            }
        }).hide();
        
        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
        
        return this;
    };
    
    /**
     * すべて表示処理
     * 
     * @access public         
     * @return this                  
     */   
    this.reset = function($_target)
    {
        $_target.removeAttr('checked');
        this.refine();
        return this;
    };
    
    /**
     * 地図の生成
     * 
     * @access public                  
     */
    this.mapMake = function(expr)
    {
        // googlemap生成
        if (!self.map) {
            self.gc = new google.maps.Geocoder(); // ジオコーディング
            self.map = new google.maps.Map($(expr).get(0), {
                zoom : 5,
                center : mapDefault,
                mapTypeId : google.maps.MapTypeId.ROADMAP
            });
        }
        
        // 地図の位置のリセット
        self.map.setCenter(mapDefault);
        self.map.setZoom(5);
        //// 地図用メソッドの生成 ////
        /**
         * 地図移動
         */
        self.mapMove = function(address)
        {
            address = $.trim(address);
            // ジオコーディング
            self.gc.geocode({'address': address},
            function(results, status) {
                if (status != 'OK') { return true; }                
                self.map.setCenter(results[0].geometry.location);
                // self.map.setZoom(9);
                self.map.setZoom(13);
            });

            // 在庫場所絞り込み条件
            $('.map_machine').show();
            self.$_list
                .filter(function() {
                    if ($(this).css('display') == 'none') { return true; }
                    else if (this.zoom_addr != address)   { return true; }
                })
               .each(function() { $(this.mapMachine).hide(); });
               
            // Lazyload用スクロール
            $(window).triggerHandler('scroll');
            
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
                var icon = timerMarker.getIcon().match(/orange/i) ? './imgs/100305_blue.gif' : './imgs/100305_orange.gif';
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
                // 現在の点滅中のマーカーの場合は、なにもしない
                // if (self.nowAdd.marker == marker) { return true; }
                
                clearInterval(this.mapTimerObj);
                self.nowAdd.marker.setIcon('./imgs/100305_orange.gif');
                self.nowAdd.infowin.close();
            }
                   
            return self;
        };
        
        // マーカー点滅タイマ解除
        self.mapClearMarker();
        
        // マップ用変数の初期化
        $.each(addresses, function(key, add) {
            //// 表示される内容を検索 ////
            var msgBody = '';
            $.each(add.elems, function(key2, elem) {
                if ($(elem).css('display') == 'none') { return true; }
                msgBody += '<div class="map_machine">' + (key2+=1) + '. ' +
                    elem.name + ' ' + elem.maker + ' ' + elem.model + '</div>';
            });
            
            //// マーカークリックでウィンドウ生成の内容 ////
            var msg = '<div class="map_company">' + add.company + '</div>' +
                '<div class="map_location">' + add.location + '</div>' +
                '<div class="map_pure_addr">' + add.pure_addr + '</div>' +
                '<div class="map_machine_list">' + msgBody + '</div>';
            
            // 内容がなければ、マーカーを生成しない
            if (msgBody == '') {
                if(add.marker) { add.marker.setMap(null); }
                return true;
            }
            
            // すでにマーカーがある場合は、内容だけ変更
            if(add.marker) {
                add.marker.setMap(self.map);
                add.infowin.setContent(msg);
                return true;
            }
        
            // ジオコーディングからマーカー生成
            /*
            self.gc.geocode({'address': add.pure_addr},
            function(results, status) {

                // 取得できなかった場合は無視
                if (status != 'OK') { return true; }
            */
                // マーカー・中央値の設定
                var marker = new google.maps.Marker({
                    map: self.map, 
                    // position: results[0].geometry.location,
                    position: new google.maps.LatLng(add.lat, add.lng),
                    icon: "imgs/100305_orange.gif"
                });
                
                //// ウィンドウの生成 ////
                var infowin = new google.maps.InfoWindow({content:msg});
                
                //// マーカーとウィンドウをこのオブジェクトに登録 ////
                add.marker  = marker;
                add.infowin = infowin;
                
                //// MAPのイベントハンドラ登録 ////
                // マーカーmouseoverで開く
                google.maps.event.addListener(marker, 'mouseover', function(event) {
                    // マーカー点滅・ウィンドウを表示
                    // infowin.open(marker.getMap(), marker);
                    self.mapBrinkMarker(add);
                    
                    // 一覧にマーカーの機械のみ表示
                    $('.machine_list.map .map_machine').hide();
                    $.each(add.elems, function() {
                        $(this.mapMachine).show();
                    });
                    
                    // Lazyload用スクロール
                    $(window).triggerHandler('scroll');
                });
            /*
            });
            */
        });
    }
};

$(function() {
    //// maker carousel表示 ////
    /*
    $('#maker_carousel').filter(function() {
        return $(this).find('li').length > 6;
    }).jcarousel({
        wrap : 'both',
        auto : 0,
        scroll : 6,
        visible : 6,
        animation : 600
    });
    */
    
    //// 在庫一覧オブジェクト ////
    var ml = new MachineList();
    
    //// 絞り込みイベントハンドラ ////
    $('.genre_area input:checkbox, .maker_area input:checkbox, input#model2,' +
        '.location_area input:checkbox, .capacity_area input:checkbox')
    .change(function() { ml.refine(); });
    
    // キーボード入力時にもイベント発生
    $('input#model2').keyup(function() {
        ml.refine();
    });
    
    // すべて表示
    $('a.maker_all').click(function() { ml.reset(ml.$_makerList); return false; });
    $('a.genre_all').click(function() { ml.reset(ml.$_genreList); return false; });
    $('a.capacity_all').click(function() { ml.reset(ml.$_capacityList); return false; });
    
    // 期間指定の処理
    $('input[name=pe]').change(function() {
        if ($(this).val() == 'input') {
            $('#input_date').focus();
        } else {
            // ml.refine();
            $('#period_form').submit();
        }
    });
    
    // 日付指定イベントハンドラ、datepicker
    $("#input_date")
        .focus(function() {
            $('input[name=pe][value=input]').attr('checked', 'checked');
        })
        .change(function() {
            // ml.refine();
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

    // 地図で表示のイベントハンドラ
    if (typeof isMap != 'undefined') {
        ml.mapMake('#gmap');
        $('.location_area input:checkbox').click(function() {
            ml.mapMove($(this).val());
        });
    }
    
    //// 新マップ表示イベントハンドラ ////
    // 地図で表示
    $('.machine_tab .map_tab').click(function() {
        $('.machine_tab a').removeClass('selected');
        $(this).addClass('selected');
        
        // マップの生成
        ml.mapMake('#gmap');
        $('.machine_list.list').hide();
        $('.img_container').hide();
        $('.company_container').hide();
        $('.map_container').show();
        
        $('.map_machine').show();
        ml.$_list
            .filter(function() { return $(this).css('display') == 'none' ? true : false })
            .each(function() { $(this.mapMachine).hide(); });
            
        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
        
        return false;
    });
    
    // 写真で表示
    $('.machine_tab .img_tab').click(function() {
        $('.machine_tab a').removeClass('selected');
        $(this).addClass('selected');
        
        $('.machine_list.list').hide();
        $('.map_container').hide();
        $('.company_container').hide();
        $('.img_container').show();
        
        $('.img_machine').show();
        ml.$_list
            .filter(function() { return $(this).css('display') == 'none' ? true : false })
            .each(function() { $(this.imgMachine).hide(); });
            
        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
        
        return false;
    });
    
    // 会社別一覧
    $('.machine_tab .company_tab').click(function() {
        $('.machine_tab a').removeClass('selected');
        $(this).addClass('selected');
        
        $('.machine_list.list').hide();
        $('.map_container').hide(); 
        $('.img_container').hide();
        $('.company_container').show();
        
        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
        
        return false;
    });
    
    // リストに戻る
    $('.machine_tab .list_tab').click(function() {
        $('.machine_tab a').removeClass('selected');
        $(this).addClass('selected');
    
        $('.map_container').hide(); 
        $('.img_container').hide();
        $('.company_container').hide();
        $('.machine_list.list').show();
        
        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
        
        return false;
    });
    
    //// 地図移動イベントハンドラ ////
    $('.map_location_area .move').click(function() {
        var address = $(this).text();
        
        if (address == '全国') {
            // リセット
            $('.machine_tab .map_tab').click();
        } else {
            ml.mapMove(address);
        }
            
        return false;
    });

    //// 画像拡大処理 ////
    // 表示枠の作成
    $('<img class="hoverimg">').appendTo('body').hide();
    
    // 表示・非表示処理
    $('.machine_list img.hover').hover(
        function() {
            $('.hoverimg')
                .attr('src', $(this).attr('src'))
                .css('top', $(this).offset().top - ($('.hoverimg').height() - $(this).height()) / 2)
                .css('left', $(this).offset().left + $(this).width() + 16)
                .show();
        },
        function() {
            $('.hoverimg').hide();
        }
    );
    
    //// 地図で表示のイベントハンドラ ////
    $('.map_machine').hover(function() {
        ml.$_list.filter('[data-id=' + $(this).data('id') + ']')
            .each(function() {
                ml.mapBrinkMarker(this.myAdd);
            });
    }, function() {
        ml.mapClearMarker();
    });
    
    
    //// サムネイル画像の遅延読み込み（Lazyload） ////
    $('img.lazy').lazyload({
        effect : "fadeIn",
        threshold : 250,
        failure_limit: 0,
        appear: function(l, settings) {
            var $self = $(this);
            $("<img />")
                .error(function() {
                    $self.attr('src', 'imgs/noimage.jpg');
                    return true;
                })
                .attr("src", $self.data(settings.data_attribute));
        }
    });
    
    //// ソート処理 ////
    /*
    $('.machine_order a').click(function() {
        $(this).attr('href').match(/#([a-z_]+)-([a-z]+)/);
        var order = RegExp.$1;
        var dir   = RegExp.$2;
        
        $('.machine').sort( function(a, b) {
            var da = $(a).find('.' + order).text();
            var db = $(b).find('.' + order).text();
            
            if (da == db)     { return $(a).find('.no').text() > $(b).find('.no').text() ? 1 : -1; }
            if (da == '')     { return 1; }
            if (db == '')     { return -1; }
            if (dir == 'asc') { return da > db ? 1 : -1; }
            else              { return da > db ? -1 : 1; }
        }).each(function() {
            $('table.machines').append($(this));
        })
        
        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
    
        return false;
    });
    */
    
    //// マイリストイベントハンドラ ////
    //// マイリストに登録（機械：単一） ////
    $('button.mylist').click(function() {
        mylist.set($(this).val(), 'machine');
    });
    
    //// マイリストに登録（機械：一括） ////
    $('button.mylist_full').click(function() {
        var machines = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (machines.length) {
            mylist.set(machines, 'machine');
        } else {
            mylist.showAlert('マイリスト登録', 'マイリストに登録したい機械をチェックしてください');
        }
    });
    
    //// マイリストに登録（検索条件：単一） ////
    $('button.input_mylist_genres').click(function() {
        // var id = $(this).val().split(',');
        mylist.set($(this).val(), 'genres');
    });
    
    //// マイリストに登録（会社：単一） ////
    $('button.mylist_company').click(function() {
        mylist.set($(this).val(), 'company');
    });
    
    //// マイリストに登録（会社：一括） ////
    $('button.mylist_full_company').click(function() {
        var companies = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (companies.length) {
            mylist.set(companies, 'company');
        } else {
            mylist.showAlert('マイリストに登録したい会社をチェックしてください');
        }
    });
    
    //// 問い合わせ（一括） ////
    $('button.contact_full').click(function() {
        if ($('input.machine_check:checked').length) {
            url = 'contact.php?';
            $('input.machine_check:checked').each(function() {
                url += 'm[]=' + $(this).val() + '&';
            });
            location.href = url;
        } else {
            mylist.showAlert('問い合わせしたい機械をチェックしてください');
        }
    });
    
    //// マイリストから削除する（機械：一括） ////
    $('button.mylist_delete').click(function() {
        var machines = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (machines.length) {
            mylist.del(machines, 'machine');
        } else {
            mylist.showAlert('マイリストから削除したい機械をチェックしてください');
        }
    });
    
    //// マイリストから削除する（検索条件：単一） ////
    $('button.mylist_delete_genres').click(function() {
        var genres = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (genres.length) {
            mylist.del(genres, 'genres');
        } else {
            mylist.showAlert('マイリストから削除したい検索条件をチェックしてください。');
        }
    });
    
    //// マイリストから削除する（会社：一括） ////
    $('button.mylist_delete_company').click(function() {
        var companies = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (companies.length) {
            mylist.del(companies, 'company');
        } else {
            mylist.showAlert('マイリストに削除したい会社をチェックしてください');
        }
    });
    
    //// 問い合わせ（会社：一括） ////
    $('button.contact_full_company').click(function() {
        if ($('input.machine_check:checked').length) {
            url = 'contact.php?';
            $('input.machine_check:checked').each(function() {
                url += 'c[]=' + $(this).val() + '&';
            });
            location.href = url;
        } else {
            cjf.showAlert('問い合わせしたい機械をチェックしてください。');
        }
    });
    
    // すべての機械をチェック
    $('#machine_check_full').change(function() {
        $('input.machine_check').attr('checked', this.checked);
    });
    
    
    //// 画像で表示イベントハンドラ ////
    // 横スクロールイベント
    $('.imagelist .data').filter(function() {
        return $(this).find('.imgs li').length > 3;
    }).each(function() {
        $_i = $(this).find('.imgs');
        // $(this).find('.status').append('<div class="scrollRight"></div><div class="scrollLeft"></div>');
        $(this).append('<div class="scrollRight"></div><div class="scrollLeft"></div>');
        
        $_i.css({
            'width': ($(this).find('li').length * 276),
            'height': 192
        });
        
        $(this).find('.triangle').show();
    });
    
    $('.scrollRight').click(function() {
        $_i = $(this).parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() + $_i.width()}, 1000, 'easeOutCubic');
    });
    
    $('.scrollLeft').click(function() {
        $_i = $(this).parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() - $_i.width()}, 1000, 'easeOutCubic');
    });
    
    // ズームイベント
    $('<div id="jqzoom"><a><img /></a></div>')
        .hover(function() {}, function() {
            $('#jqzoom').hide();
        }).appendTo('body');
    $('.imagelist .imgs li img').mouseover(function() {
        var $_self = $(this);
        var src    = $_self.attr('src');
        
        $('#jqzoom').css({
            display : 'block',
            position : 'absolute',
            width : $_self.outerWidth(),
            height : $_self.outerHeight(),
            top : $_self.offset().top,
            left : $_self.offset().left,
        }).show();
        
        // 同じ画像の場合、以降の処理は飛ばす
        if (src == $('#jqzoom a').attr('href')) { return true; }
        
        $('#jqzoom').html('<a><img /></a>');
        
        $('#jqzoom img')
            .attr('src', src)
            .css({
                width : $_self.outerWidth(),
                height : $_self.outerHeight(),
            });
        
        var detailUri = $_self.parent().attr('href');
        var position  = $(window).width() / 2 - 128 < $_self.offset().left ? 'left' : 'right';
        
        $('#jqzoom a')
            .attr('href', src)
            .css({
                width : $_self.outerWidth(),
                height : $_self.outerHeight(),
            }).click(function() {
                location.href = detailUri;
                return false;
            }).jqzoom({
                zoomType: 'standard',
                lens:true,
                preloadImages: true,
                alwaysOn:false,
                zoomWidth: 480,
                zoomHeight: 360,
                xOffset: 32,
                yOffset: -96,
                position: position,
                title: false
            });
    });
    
    //// jqzoom ////
    /*
    $(".zoom").each(function() {
        var $_self = $(this);
        var detailUri = $_self.attr('href');
        var imgUri = $_self.find('img.lazy').data('original');
        
        $_self.click(function() {
            location.href = detailUri;
            return false;
        });       
        
        if (imgUri) {
            $_self
                .attr('href', imgUri)
                .jqzoom({
                    zoomType: 'standard',  
                    lens:true,  
                    preloadImages: true,  
                    alwaysOn:false,  
                    zoomWidth: 480,  
                    zoomHeight: 360,  
                    xOffset:64,  
                    yOffset: 0,  
                    position:'right',
                    title: false
           });
        }
    });
    */
    
    //// 動画ボタン再生 ////
    $('button.movie').click(function() {
        if (!$('#movie_dialog').length) {
            $('<div id="movie_dialog" style="width:640px;height:480px;">').appendTo('body');
        }
        var $_moDir = $('#movie_dialog');
        
        var contents = '<iframe width="640" height="480" id="movie_dialog" ' +
            'src="http://www.youtube.com/embed/' +
            $(this).val() + 
            '?rel=0" frameborder="0" allowfullscreen></iframe>';
        
        $_moDir.html(contents).dialog({
            show: "fade",
            hide: "fade",
            closeText: '閉じる',
            title: '動画の再生',
            width: 675,
            height: 540,
            resizable: false,
            modal: true,
            close: function() { $_moDir.empty(); }
        });
        
        return false;
    });
    
    // lazyload用のスクロールイベント
    $('.machine_list.map').scroll(function() {
        $(window).triggerHandler('scroll');
    });
});

/*
$('body').load(function() {
    //// end画像の位置調整 ////
    $('.triangle').each(function() {
        var sibling_img = $(this).siblings('.last_img');
        var pos = sibling_img.position();
        
        var left = pos.left + sibling_img.outerWidth() - $(this).outerWidth();
        var top  = pos.top + sibling_img.outerHeight() - $(this).outerHeight();
        
        $(this).css({'left' : left + 'px', 'top' : top + 'px'});
    });
});
*/
