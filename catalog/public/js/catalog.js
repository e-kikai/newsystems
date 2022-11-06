$(function() {
    /// サムネイル画像の遅延読み込み（Lazyload） ///
    $('img.lazy').css('display', 'block').lazyload({
        effect: "fadeIn"
    });

    /// 型式で検索ボタン ///
    $('#model_form').submit(function() {
        if (!$('input.model').val() || $('input.model').val() == $('input.model').attr('title')) {
            alert('型式が入力されていません。');
            return false;
        }
        return true;
    });

    /// すべて表示：メーカー ///
    $('a.maker_all').click(function() {
        $('.maker_area input:checked').removeAttr('checked');
        $('.maker_area input:checkbox').first().change();
        return false;
    });

    /// すべて表示：ジャンル ///
    $('a.genre_all').click(function() {
        $('.genre_area input:checked').removeAttr('checked');
        $('.genre_area input:checkbox').first().change();
        return false;
    });

    /// 絞り込み用にカタログ一覧を配列化 ///
    var $_catalogList = $('.catalog');
    $_catalogList.each(function() {
        $_self = $(this);

        this.genre_id = $_self.find('.genre_id').text();
        this.maker    = $_self.find('.maker').text();
        this.model2   = $_self.find('.model2').text();
    });

    /// ジャンル・メーカーで絞り込む ///
    $('.genre_area input:checkbox, .maker_area input:checkbox, input.model2').change(function() {
        // ジャンル絞り込み条件
        var sGenre = $('.genre_area input:checked')
            .map(function() { return $(this).val(); })
            .get()
            .join('|');
        var gRe = new RegExp("(^|[|])(" + sGenre + ")($|[|])");

        // メーカー絞り込み条件
        var sMaker = $('.maker_area input:checked')
            .map(function() { return $(this).val(); })
            .get()
            .join('|');
        var maRe = new RegExp("(^|[|])(" + sMaker + ")($|[|])");

        // 型式絞り込み条件
        var sModel = $('input.model2').val();
        // 型式検索用に入力値を変換
        sModel = mb_convert_kana(sModel, 'KVrn')
            .toUpperCase()
            .replace(/[^A-Z0-9]/g, '');
        var moRe = new RegExp(sModel);

        // 絞り込み処理
        $_catalogList.show().filter(function() {
            if (sGenre != '' && !this.genre_id.match(gRe)) {
                return true;
            } else if (sMaker != '' && !this.maker.match(maRe)) {
                return true;
            } else if (sModel != '' && !this.model2.match(moRe)) {
                return true;
            } else {
                return false;
            }
        }).hide();

        // Lazyload用スクロール
        $(window).triggerHandler('scroll');
    });

    // キーボード入力時にもイベント発声
    $('input.model2').keyup(function() {
        $(this).triggerHandler('change');
    });

    /**
     * VIEW表示切り替え
     *
     * @access public
     * @param  string  view VIEW名
     * @return boolian true
     */
    var viewChange = function(view) {
        $('.catalogs').hide();
        $('.catalogs.' + view).show();

        // 選択したVIEWタブの背景色更新
        $('.catalog_view a.selected').removeClass('selected');
        $('.catalog_view a.' + view).addClass('selected');

        // Lazyload用スクロール
        $(window).triggerHandler('scroll');

        return true;
    }

    /**
     * 背景色を再定義
     *
     * @access public
     * @return boolian true
     */
//     var changeCycle = function() {
//         $('.catalog:visible:even').removeClass('odd').addClass('even');
//         $('.catalog:visible:odd').removeClass('even').addClass('odd');
//         return true;
//     }

    /// VIEWクッキー切り替え ///
    $('.catalog_view a').click(function() {
        // リンクのhrefから、VIEW名を取得
        $(this).attr('href').match(/\Wv\=(\w+)/);
        var view = RegExp.$1;

        // クッキーに保存
        $.cookie('catalog_view', view);

        // 表示切り替え
        viewChange(view);

        return false;
    });
    viewChange($.cookie('catalog_view'));

    /// マイリストに登録（カタログ：単一） ///
    $('button.set_mylist').click(function() {
        $.post('ajax/mylist.php', {
            "target": "catalog",
            "action": "set",
            "data[]": [$(this).val()]
        },
        function(data) {
            if (data == 'success') {
                cjf.showAlert('マイリストに登録しました');
            } else {
                // alert(data);
                cjf.showAlert(data);
            }
        });
    });

    /// マイリストから削除（カタログ：単一） ///
    $('button.delete_mylist').click(function() {
        if (confirm('チェックしたカタログをマイリストから削除しますか？')) {
            $.post('ajax/mylist.php', {
                "target": "catalog",
                "action": "delete",
                "data[]": [$(this).val()]
            },
            function(data) {
                if (data == 'success') {
                    location.reload();
                } else {
                    // alert(data);
                    cjf.showAlert(data);
                }
            });
        }
    });

});
