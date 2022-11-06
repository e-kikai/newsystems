/**
 * ミニブログ
 */
$(function() {
    /// 表示初期化 ///
    $('<div class="tools_area">').appendTo('body');
    $('<button class="miniblog_open">').text('書きこむ')
      .appendTo('.tools_area');
    $('<div class="miniblog_area">')
      .html('メッセージを書きこんで「送信する」をクリックしてください<br />書きこんだ内容はトップページに表示されます')
      .appendTo('body');
    $('<textarea class="miniblog_input"></textarea>').appendTo('.miniblog_area');
    $('<button type="button" class="miniblog_submit">')
      .text('メッセージを送信する')
      .appendTo('.miniblog_area');

    /// フォームを開く ///
    $('.miniblog_open').click(function() {
        $('button.miniblog_submit').removeAttr("disabled");
        $(".miniblog_area").slideToggle('normal', function() {
            $('.miniblog_input').focus();
        });
    });

    /// メッセージを送信 ///
    $('button.miniblog_submit').click(function() {
        $('button.miniblog_submit').attr("disabled", "disabled");

        /// 送信処理 ///
        $.post('ajax/miniblog.php', {
            "target": "catalog",
            "action": "set",
            "data": $('.miniblog_input').val()
        },
        function(data) {
            $(".miniblog_area").slideUp();
            $('.miniblog_input').val('');
            if (data == 'success') {
                cjf.showAlert('メッセージを送信しました');
            } else {
                // alert(data);
                cjf.showAlert(data);
            }
        });
    });
});
