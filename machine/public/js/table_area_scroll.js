/**
 * テーブルスクロール
 */
$(function () {
  // $(window)
  //   .resize(function () {
  //     $("div.table_area").css("height", $(window).height() - 240);
  //   })
  //   .triggerHandler("resize");

  /// テーブルスクロール ///
  $("div.table_area").scroll(function () {
    $(window).triggerHandler("scroll");
  });
});
