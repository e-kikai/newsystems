<!DOCTYPE html>

<html lang='ja'>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  
  <base href="http://machinelife.zenkiren.net/" />
</head>
<body style="margin: 0;color: #333;font-size: 13px;line-height: 1.4;font-family: 'メイリオ', Meiryo, 'Lucida Grande', Verdana, 'ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro';">

<a href='' style="margin: 8px;">
  <img src='imgs/logo_zenkiren_mini.png' alt="全機連 中古機械情報" />
</a>

<h1 style="border-left: 6px solid #147543;margin: 0 auto 6px auto;height: 20px;line-height: 20px;margin: 8px;font-size: 18px;font-weight: bold;text-indent: 13px;"
  >マシンライフ中古機械情報 新着情報</h1>

<div style="margin: 8px;">
  登録日 : {'-1day'|strtotime|date_format:'%Y/%m/%d'}
  件数 : {$machineList|count}件
</div>

<table style="border-collapse: collapse;border-spacing: 0;margin:8px auto;width: 98%;">
  <tr style="background:#EEE;">
    <th style="border:1px solid #777;padding:3px;width:120px;">画像</th>
    <th style="border:1px solid #777;padding:3px;">機械名</th>
    <th style="border:1px solid #777;padding:3px;">メーカー</th>
    <th style="border:1px solid #777;padding:3px;">型式</th>
    <th style="border:1px solid #777;padding:3px;">年式</th>
    <th style="border:1px solid #777;padding:3px;">主能力</th>
    <th style="border:1px solid #777;padding:3px;">会社名</th>
    <th style="border:1px solid #777;padding:3px;">お問合せ</th>
    <th></th>
  </tr>
  
  {foreach $machineList as $m}
    <tr style="background:{cycle values='#FFF, #EEE'};">
      <td style="border:1px solid #777;padding:0;">
        {if $m.top_img}
          <a href="machine_detail.php?m={$m.id}" target="_blank"><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" style="border:0;" /></a>
        {/if}
      </td>
      <td style="border:1px solid #777;padding:3px;">
        <a href="machine_detail.php?m={$m.id}" target="_blank">{$m.name}</a>
      </td>
      <td style="border:1px solid #777;padding:3px;">{$m.maker}</td>
      <td style="border:1px solid #777;padding:3px;">{$m.model}</td>
      <td style="border:1px solid #777;padding:3px;">{$m.year}</td>
      <td style="border:1px solid #777;padding:3px;">{if !empty($m.capacity)}{$m.capacity}{$m.capacity_unit}{/if}</td>
      <td style="border:1px solid #777;padding:3px;">
        <a href="company_detail.php?c={$m.company_id}" target="_blank">{'/(株式|有限|合.)会社/'|preg_replace:'':$m.company}</a>
      </td>
      <td style="border:1px solid #777;padding:3px;">
        <a href="contact.php?m={$m.id}" target="_blank">お問合せ</a>
      </td>
    </tr>
  {/foreach}
  
</table>
<div style="margin-top: 8px;width: 100%;height: 30px;line-height: 30px;text-align: center;background: #111;color: #FFF;">
  Copyright © 2013 <a href="http://www.zenkiren.net" target="_blank" style="color:#FFF;">全日本機械業連合会</a> All Rights Reserved.
</div>
</body>
</html>
