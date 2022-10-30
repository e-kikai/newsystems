<?php

/**
 * ファイルアップロード(iframe)処理
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2012/08/02
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
  //// 認証 ////
  Auth::isAuth('member');

  $t = Req::query('t');
  $m = Req::query('m');
  $c = Req::query('c');
} catch (Exception $e) {
  echo $e->getMessage();
}
?>
<!DOCTYPE html>
<html lang='ja'>

<head>
  <script type="text/javascript" src="../libjs/jquery.js"></script>

  <script type="text/javascript">
    var fList = [];
    <?php if (!empty($fList)) : ?>
      fList = <?= json_encode($fList); ?>;
    <?php endif; ?>

    var t = '<?= $t; ?>';

    $(function() {
      //// ファイルが選択されたら、自動的にアップロード開始 ////
      $('#imgs').change(function() {
        $('#upload').submit();
        $(this).after('ファイルをアップロードしています').hide();
        $('#img_label, .dd_message').hide();
      });

      // $('#img_label').click(function() { $('#imgs').click(); });

      //// ファイルのドラッグアンドドロップをサポート ////
      if (window.File) {
        $('.dd_message').show();
      }
      /*
      if (window.File) {
          $('.dd_message').show();

          // File APIに関する処理を記述
          $.event.props.push('dataTransfer');

          $('#drop_area').bind('drop', function(event) {
              event.stopPropagation();
              event.preventDefault();

              var dt = event.dataTransfer;

              // ドロップされたファイルをinputフォームにコピー
              $('#imgs').get(0).files = dt.files;
              $(this).trigger('dragleave');

              return false;
          }).bind('dragover', function() {
              $(this).addClass('dragged');
              return false;
          }).bind('dragleave', function() {
              $(this).removeClass('dragged');
              return false;
          });
      }
      */
    });
  </script>
  <style>
    body {
      margin: 0;
      font-size: 13px;
      color: #333;
      overflow: hidden;
      background: transparent;
    }

    /*** アップロードフォーム ***/
    .dragged {
      background: #FFF0F0;
      border: 1px dotted #FF70F0;
    }

    #img_label {
      font-size: 14px;
      width: 100px;
      height: 21px;
      line-height: 21px;
      cursor: pointer;

      display: inline-block;
      position: relative;
      margin: auto;
      padding: 1px 6px;
      text-decoration: none;
      text-align: center;
      color: #fff;
      border: 1px solid #9c9c9c;

      text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.2);
      box-shadow: 1px 1px 0.2em rgba(0, 0, 0, 0.4);
      border-radius: 0.3em;

      background: #4477a1;
      background: -webkit-gradient(linear, left top, left bottom, from(#81a8cb), to(#4477a1));
      background: -moz-linear-gradient(-90deg, #81a8cb, #4477a1);
      background: -o-linear-gradient(-90deg, #81a8cb, #4477a1);
      filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0, startColorstr='#81a8cb', endColorstr='#4477a1');
    }

    #imgs {
      width: 220px;
    }

    .dd_message {
      display: none;
      padding: 4px;
    }
  </style>
</head>

<body>
  <div id="drop_area">
    <form method="POST" action="../ajax/upload_do.php" enctype="multipart/form-data" id="upload">
      <input type="hidden" name="t" value="<?= $t; ?>" />
      <input type="hidden" name="m" value="<?= $m; ?>" />
      <input type="hidden" name="c" value="<?= $c; ?>" />

      <?php /*
  <label id="img_label" >ファイル選択</label>
  */ ?>
      <input type="file" name="f[]" id="imgs" class="imgs" accept="<?= $t; ?>" <?php if (!empty($m)) : ?>multiple<?php endif; ?> />

      <span class="dd_message">⇐にドラッグ＆ドロップできます</span>

    </form>
  </div>
</body>

</html>