<!doctype html>
<html lang='ja'>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{$flyer.subject}</title>

  <style type="text/css">
    a.back_link {
      margin: 16px 64px;
      display: inline-block;
    }
  </style>
</head>
<body id="templateBody" style="height: 100%;margin: 0;padding: 0;width: 100%;-ms-text-size-adjust: 100%;-webkit-text-size-adjust: 100%;">
  <a href="/admin/flyer_menu.php?id={$flyer.id}" class="back_link">← 操作メニューに戻る</a>
  {include "admin/flyer_design_body.tpl"}
  <a href="/admin/flyer_menu.php?id={$flyer.id}" class="back_link">← 操作メニューに戻る</a>
</body>
</html>
