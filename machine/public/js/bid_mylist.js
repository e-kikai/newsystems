/**
 * 入札会マイリスト処理
 */
$(function() {
    //// タイマ ////
    // setEndTimer($('.now_time').val(), $('.end_time').val(), $('.times'));
    
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
    
    //// マイリスト登録 ////
    $('button.mylist').click(function() {
        var $_self = $(this);
        var bid_machine_id = $.trim($(this).val());
        
        // マイリスト初回クリック時
        if ($.cookie('bid_preuser_check') == null) {
            /*
            $('.preuser_form_area').dialog({
                show: "fade",
                hide: "fade",
                closeText: '閉じる',
                title: 'メールアドレス登録',
                width: 540,
                height: 360,
                resizable: false,
                modal: true,
            });
            
            $('input.preuser_bid_machine_id').val(bid_machine_id);
            $('input.mail').focus();
            
            return false;
            */

            // cookie登録
            $.cookie('bid_preuser_check', 1, { expires: 31 });
        }
    
        $.post('/ajax/bid_mylist.php', {
            'target': 'machine', 'action': 'set', 'data'  : { 'bid_machine_id': bid_machine_id, },
        }, function(res) {
            var contents = '';
            if (res == 'success') {
                title    = 'お気に入りに登録';
                contents = 'お気に入りに登録しました';
            } else {
                title    = 'お気に入り登録';
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

            // お気に入りボタンをリンクに
            if (res == 'success') {
                $_self.after('<a class="mylist_text_link" href="/bid_list.php?o=' + $('input.bid_open_id').val() + '&mylist=1">お気に入り表示</a>').remove();
            }

            return false;
        });
        return false;
    });
    
    //// ユーザ登録処理 ////
    $('button.preuser_submit').click(function() {
        var data = {
            'mail': $.trim($('input.mail').val()),
            'user_name': $.trim($('input.user_name').val()),
        };
        
        //// 入力のチェック ////
        var e = '';
        if (data.mail == '') {
            e += "メールアドレスが入力されていません\n";
        } else if(!data.mail.match(/^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/)){
            e += "メールアドレスが間違っている可能性があります。\nもう一度お確かめください\n";
        }
        if ($('input.privacy_check').is(':checked') == false) {
            e += "プライバシーポリシーに同意されていません\n";
        }

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }
        
        $('button.preuser_submit').attr('disabled', 'disabled').text('処理中、そのままお待ち下さい');
        
        $.post('/ajax/bid_mylist.php', {
            'target': 'machine',
            'action': 'setPreuser',
            'data': data,
        }, function(res) {
            if (res != 'success') {
                $('button.preuser_submit').removeAttr('disabled').text('メールアドレスを登録してマイリストを使う');
                alert(res);
                return false;
            }
            
            // cookie登録
            $.cookie('bid_preuser_check', 1, { expires: 31 });
            $('.preuser_form_area').dialog('close');
            $('button.mylist[value=' + $('input.preuser_bid_machine_id').val() + ']').click();
            
            // 登録完了
            return false;
        });
        
        return false;
    });
    
    //// マイリスト削除 ////
    $('button.delete_mylist').click(function() {
        var $_self = $(this);
        var $_parent = $_self.closest('div.product_line');
        
        $.post('/ajax/bid_mylist.php', {
            'target': 'machine', 'action': 'delete', 'data'  : { 'bid_machine_id': $.trim($_self.val()), },
        }, function(res) {
            var contents = '';
            if (res == 'success') {
                title    = 'お気に入り削除';
                contents = 'お気に入りから削除しました';
                
                $_parent.remove();
            } else {
                title    = 'お気に入り削除';
                contents = res;
            }
                        
            $('<div class="mylist_alert">').text(contents).dialog({
                show: "fade",
                hide: "fade",
                closeText: '閉じる',
                title: title,
                width: 300,
                height: 80,
                resizable: false,
                modal: false,
                open: function(e, ui) {
                    setTimeout(function() { $(e.target).dialog('close'); }, 2000);
                }
            });
            return false;
        });
        return false;
    });

    //// 共通URLウィンドウ ////
    $('a.subwindow').on('click', function() {
        var url = $(this).attr('href');

        $('<iframe src="'+ url + '" id="dialog1" width="640"></iframe>').dialog({
            title: '',
            show: "fade",
            hide: "fade",
            closeText: '閉じる',
            width: 640,
            height: 480,
            resizable: false,
            modal: true,
            buttons: {
                '閉じる': function () { $(this).dialog('close'); }
            },
            open: function(){
                $(this).css('width', '100%');
            }
        });

        return false;
    });
});

function setEndTimer(serverTime, endTime, $_result) {
    if (!$_result) { return false; }
    
    // サーバ時間と現在時間の差分を取得
    var timeMargin = parseInt((new Date)/1000) - serverTime;
    
    // 残り時間を表示させる処理
    var timeTimer = setInterval(function() {
        var tmp = endTime - parseInt((new Date)/1000) - timeMargin;
        
        if (tmp < 0) {
            var tmpText = '入札は締切ました';
            clearInterval(timeTimer);
        } else {
            var tmpDay    = Math.floor(tmp / (3600*24));
            var tmpHour   = Math.floor((tmp % (3600*24) / 3600));
            var tmpMinute = Math.floor((tmp % 3600) / 60);
            var tmpSecond = tmp % 60;
            
            var tmpText = '入札締切まで、';
            if (tmpDay) { tmpText += tmpDay + '日 '; }
            tmpText += ("0" + tmpHour).slice(-2) + ':';
            tmpText += ("0" + tmpMinute).slice(-2) + ':';
            tmpText += ("0" + tmpSecond).slice(-2) + '';
        }
        $_result.text(tmpText);
    } ,1000);
};
