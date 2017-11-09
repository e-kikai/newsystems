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
    }
}

$(function() {
    //// placeholderの処理 with Modernizr ////
    if(!Modernizr.input.placeholder) {
        $('[placeholder]:not(:password)').focus(function() {
            var input = $(this);
            if (input.val() == input.attr('placeholder')) {
                input.val('');
            }
            input.removeClass('placeholder');
        }).blur(function() {
            var input = $(this);
            if (input.val() == '' || input.val() == input.attr('placeholder')) {
                input.addClass('placeholder');
                input.val(input.attr('placeholder'));
            }
        }).blur();
        
        $('[placeholder]').parents('form').submit(function() {
            $(this).find('[placeholder]').each(function() {
                var input = $(this);
                if (input.val() == input.attr('placeholder')) {
                    input.val('');
                }
            })
        });
    }
});

//// Stringにtrim追加 ////
String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, "");
}
