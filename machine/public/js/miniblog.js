/**
 * ミニブログ
 */
$(function () {
  //// 表示初期化 ////
  /*
    $('body').append(
        $('<div class="tools_area">').append(
            $('<button class="miniblog_open">').text('書きこむ')
        )
    ).append(
        $('<div class="miniblog_area">').html(
            'メッセージを書きこんで「送信する」をクリックしてください<br />' +
            '書きこんだ内容はトップページに表示されます'
        ).append(
            $('<textarea class="miniblog_input">')
        ).append(
            $('<button class="miniblog_submit">').text('メッセージを送信する')
        )
    );
    */

  //// 表示初期化 ////
  $('<div class="tools_area">').appendTo("body");
  $('<button class="miniblog_open">書きこむ</button>').appendTo(".tools_area");
  $('<div class="miniblog_area">')
    .html(
      "メッセージを書きこんで「送信する」をクリックしてください<br />書きこんだ内容は会員ページに表示されます"
    )
    .appendTo("body");
  $('<textarea class="miniblog_input"></textarea>').appendTo(".miniblog_area");
  $(
    '<button type="button" class="miniblog_submit">メッセージを送信する</button>'
  ).appendTo(".miniblog_area");

  //// @ba-ta 20150114 親ID、レスポンスIDの追加 ////
  $('<input type="hidden" class="parent_id" value="" />').appendTo(
    ".miniblog_area"
  );
  $('<input type="hidden" class="response_id" value="" />').appendTo(
    ".miniblog_area"
  );

  //// フォームを開く ////
  $(".miniblog_open, .miniblog_response").click(function () {
    $("button.miniblog_submit").removeAttr("disabled");
    $(".miniblog_area").slideToggle("normal", function () {
      $(".miniblog_input").focus();
    });

    // 返信の場合、返信元の本文を埋め込む
    var thisId = $(this).data("id");
    if (thisId) {
      var thisText =
        $(".info_contents[data-id=" + thisId + "]")
          .text()
          .replace(/(^|\n\r|\r|\n)/g, "$1> ") + "\n\n";
      $(".miniblog_input").val(thisText);
    }
  });

  //// メッセージを送信 ////
  $("button.miniblog_submit").click(function () {
    $("button.miniblog_submit").attr("disabled", "disabled");

    //// 送信処理 ////
    $.post(
      "ajax/miniblog.php",
      {
        target: "machine",
        action: "set",
        data: $(".miniblog_input").val(),
      },
      function (data) {
        $(".miniblog_area").slideUp();
        $(".miniblog_input").val("");
        if (data == "success") {
          cjf.showAlert("メッセージを送信しました");
        } else {
          cjf.showAlert(data);
        }
      }
    );
  });
});
