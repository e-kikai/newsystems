/**
 * ログ機械一覧の左右スクロール処理
 */
$(function() {
    //// スクロールリスト ////
    $(document).on('click', '.scrollRight', function() {
        $_i = $(this).parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() + $_i.width() - 74}, 1000, 'easeOutCubic');
        $(window).triggerHandler('scroll');
    });

    $(document).on('click', '.scrollLeft', function() {
        $_i = $(this).parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() - $_i.width() + 74}, 1000, 'easeOutCubic');
        $(window).triggerHandler('scroll');
    });
});
