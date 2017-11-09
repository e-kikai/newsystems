/**
 * 共通Javascropt関数
 */
var cjf = {
    //// showAlert表示枠のjQueryオブジェクトを格納 ////
    _showAlertJqo : null,
    
    //// showAlertのsetTimeoutハンドルを格納 ////
    _showAlertTimeout : null,
    
    //// 拡大縮小枠のjQueryオブジェクトを格納 ////
    _showMapboxJqo : null,
    
    /**
     * アラート表示処理
     *
     * @access public
     * @param  string data 表示内容
     * @param  integer timeout 表示時間msec default 2000
     * @param  string fade フェード処理時間msec default normal
     * @return boolean true
     */
    showAlert : function(data, timeout, fade)
    {
        // 引数のデフォルト値の設定
        if (timeout == undefined)   { timeout = 2000; }
        if (fade == undefined)      { fade = 'normal'; }
    
        // アラート表示枠の生成
        if (!this._showAlertJqo) {
            $('<div>').addClass('cjf_alert').hide().appendTo('body');
            this._showAlertJqo = $('div.cjf_alert');
        }
        var alertArea = this._showAlertJqo;
        
        // アラート表示が表示されている場合、一旦非表示、テキストのセット
        clearTimeout(this._showAlertTimeout);
        alertArea.fadeOut(fade, function() { alertArea.text(data) });
        
        // アラート表示処理（フェードイン）
        alertArea.fadeIn(fade);
        
        // アラート消去処理設定（フェードアウト）
        this._showAlertTimeout = setTimeout(function() { alertArea.fadeOut(fade); }, timeout);
    
        return true;
    },
    
    /**
     * 拡大縮小枠表示
     *
     * @access public
     * @param  string img トップ表示する画像ファイルパス
     * @param  array imgs その他表示させる画像ファイルパス一覧
     * @return boolean true
     */
    showMapbox : function(img, imgs)
    {
        // 拡大縮小枠の生成
        if (!this._showMapboxJqo) {
            $('<div>').addClass('cjf_mapbox').hide().appendTo('body');
            this._showMapboxJqo = $('div.cjf_mapbox');
            
            // メイン部分
            $('<div id="viewport">').appendTo(this._showMapboxJqo);
            
            // 操作ボタン
            $('<button class="mapbox_button pluse">＋</button>')
                .click(function() { $("#viewport").mapbox("zoom"); })
                .appendTo(this._showMapboxJqo);
            $('<button class="mapbox_button minus">－</button>')
                .click(function() { $("#viewport").mapbox("back"); })
                .appendTo(this._showMapboxJqo);
            
            // 背景枠
            $('<div>').addClass('cfj_bg')
                .click(function() {
                    $('div.cjf_mapbox').fadeOut('normal');
                    $('div.cfj_bg').fadeOut('normal');
                }).hide().appendTo('body');
        }
        
        // 要素をクリア
        $('#viewport').empty();
        
        // レイヤ群
        $('<div>').addClass('layer_01').css({'width' : '640px', 'height' : '480px'}).appendTo('#viewport');
        $('<img />').appendTo('.layer_01');
        
        $('<div>').addClass('layer_02').css({'width' : '2560px', 'height' : '2560px'}).appendTo('#viewport');
        $('<img /><div class="mapcontent"></div>').appendTo('.layer_02');
        
        // 画像サイズの自動調整イベント
        $('.layer_01 img').load(function() {
            var rate = $('.layer_01 img').width() / $('.layer_01 img').height();
            $('.layer_01').css({ height : '480px', width : (480 * rate) + 'px'});
            $('.layer_02').css({ height : (480 * 4) + 'px', width : (480 * 4 * rate) + 'px'});
            
            // mapbox生成
            $("#viewport").mapbox({
                layerSplit : 8,
                clickZoom : true
            });
            
            // ダブルクリックイベントを登録
            $('.layer_01 img, .mapcontent').dblclick(function() { $("#viewport").mapbox("zoom"); });
        
            // ズーム倍率のリセット
            $("#viewport").mapbox("zoomTo", 0);
        });
        
        // 画像の読み込み
        $('.layer_01 img, .layer_02 img').attr('src', img);
        
        // 拡大縮小枠の表示処理（フェードイン）
        this._showMapboxJqo.fadeIn('normal');
        $('div.cfj_bg').fadeTo('normal', '0.85');

        return true;
    },
    
    /**
     * 数値の3桁カンマ区切り
     *
     * @access public
     * @param  integer str カンマ区切りする数値
     * @return string カンマ区切り後の数値
     */
    numberFormat : function(str)
    {
        var num = new String(str).replace(/,/g, "");
        while(num != (num = num.replace(/^(-?\d+)(\d{3})/, "$1,$2")));
        return num;
    }
}

$(function(){
    //// 動画ボタン再生 ////
    $(document).on('click', 'button.movie, a.movie, .label.movie', function() {
        if (!$('#movie_dialog').length) {
            $('<div id="movie_dialog" style="width:640px;height:480px;">').appendTo('body');
        }
        
        var $_moDir = $('#movie_dialog');
        var contents = '<iframe width="768" height="432" id="movie_dialog" ' +
            'src="http://www.youtube.com/embed/' +
            $(this).data('youtubeid') + '?rel=0" frameborder="0" allowfullscreen></iframe>';
        
        $_moDir.html(contents).dialog({
            show: "fade",
            hide: "fade",
            closeText: '閉じる',
            title: '動画の再生',
            width: 800,
            height: 500,
            resizable: false,
            modal: true,
            close: function() { $_moDir.empty(); }
        });
        
        return false;
    });

    $('img.lazy').lazyload({
        // effect : "fadeIn",
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
    setTimeout(function() { $(window).triggerHandler('scroll'); }, 100);
});

//// Stringにtrim追加 ////
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
}
