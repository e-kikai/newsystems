/**
 * 入札会一括問い合わせ処理
 */
$(function() {
    //// 解説ボタン ////
    $('button.bid_help').click(function() {
        $('.bid_help_area').dialog({
            title: '入札のご依頼方法について',
            modal: true,
            width: 800,
            height: 510,
            zIndex: 3000,
            show : "fade",
            hide : "fade",
        });
    });

    //// サムネイル画像の遅延読み込み（Lazyload） ////
    $('img.lazy').css('display', 'block').lazyload({
        effect: "fadeIn",
        threshold : 200
    });

    setTimeout(function() {
        $(window).triggerHandler('scroll');
    }, 100);

    //// 一括問い合わせ登録 ////
    $('button.mylist, button.delete_mylist').click(function() {
        var $_self       = $(this);
        var bidMachineid = $.trim($(this).val());
        var action       = $_self.hasClass('delete_mylist') ? 'delete' : 'set';

        $.post('/ajax/bid_batch.php', {
            'target': 'machine',
            'action': action,
            'data'  : { 'bid_machine_id': bidMachineid, },
        }, function(res) {
            var contents = '';
            var title    = '一括問い合わせ'
            if (res == 'success') {
                if (action == 'delete') {
                    contents = '一括問い合わせから削除しました';
                    $_self.parent().find(' > .mylist').show();
                    $_self.hide();
                } else {
                    contents = '一括問い合わせに登録しました';
                    $_self.parent().find(' > .delete_mylist').show();
                    $_self.hide();
                }
            } else {
                contents = res;
            }

            $('<div class="mylist_alert">').text(contents).dialog({
                show: "fade",
                hide: "fade",
                closeText: '閉じる',
                title: title,
                width: 320,
                height: 80,
                resizable: false,
                modal: false,
                open: function(e, ui) {
                    setTimeout(function() { $(e.target).dialog('close'); }, 2000);
                }
            });
        });
        return false;
    });

    //// 共通URLウィンドウ ////
    $('a.subwindow').on('click', function() {
        var $_self = $(this);
        var url    = $_self.attr('href');
        var title  = $_self.data('title');

        $('<iframe src="'+ url + '" id="dialog1" width="640"></iframe>').dialog({
            title: title,
            show: "fade",
            hide: "fade",
            closeText: '閉じる',
            width: 640,
            height: 480,
            resizable: false,
            modal: true,
            buttons: { '閉じる': function () { $(this).dialog('close'); } },
            open: function(){ $(this).css('width', '100%'); }
        });

        return false;
    });
});
