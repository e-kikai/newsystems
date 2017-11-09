/**
 * 共通印刷ボタン関数
 */
$(function() {
    //// 印刷ボタン ////
    $('<button class="print"><img src="./imgs/print_icon3.png" />ページを印刷する</button>')
        .appendTo('header');
    
    $('button.print').click(function() {
        $('img.lazy').each(function() {
            $(this).attr('src', $(this).data('original'));
        });
        window.print();
        // _gaq.push(['_trackEvent', 'common', 'print', 'button', 1, true]);
        ga('send', 'event', 'common', 'print', 'button', 1, true);
    });
    
    // foe IE
    document.body.onbeforeprint = function() {
        $('img.lazy').each(function() {
            $(this).attr('src', $(this).data('original'));
        });
        // _gaq.push(['_trackEvent', 'common', 'print', 'IE', 1, true]);
        ga('send', 'event', 'common', 'print', 'IE', 1, true);
    };
});
