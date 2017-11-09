/**
 * 詳細画面の画像拡大、クリックジャンプ処理
 */
$(function() {
    //// 画像処理 ////
    // 表示する画像の変更
    $('a.img, a.zoom').mouseover(function() {
        var href = $(this).attr('href');
        
        $('#viewport').html('<a class="zoom" href="' + href + '"><img class="zoom_img" src="' + href + '" /></a>');
            
        $(".zoom").jqzoom({
            zoomType: 'standard',  
            lens:true,  
            preloadImages: true,  
            alwaysOn:false,  
            zoomWidth: 420,  
            zoomHeight: 470,  
            xOffset: 16,  
            yOffset: 0,  
            position:'right',
            title: false
        }).click(function() {
            // 画像クリックで元画像表示
            window.open($(this).attr('href'));
        });
            
        return false;
    }).mouseout(function() {
        $('a.img.selected').triggerHandler('mouseover');
    }).click(function() {
        $('a.img.selected').removeClass('selected');
        $(this).addClass('selected');
        return false;
    });
    
    // ロード時に、拡大縮小を生成
    $('.zoom').click();
    
    //// クリックジャンプ ////
    $('a[href*=#]').click(function() {
        var target = $(this.hash);
        if (target) {
            var targetOffset = target.offset().top;
            $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
            return false;
        }
    });
    
    //// アクセスマップへジャンプ ////
    // $('button.accessmap').click(function() {
    //     var target = $('#gmap_label');
    //     if (target) {
    //         var targetOffset = target.offset().top;
    //         $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
    //         return false;
    //     }
    // });
});
