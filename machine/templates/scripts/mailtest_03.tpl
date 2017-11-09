<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang='ja'>
<head>
  <meta http-equiv="Content-Language" content="ja">
  <meta http-equiv="Content-Type" content="text/html; charset=iso-2022-jp" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  {*
  <base href="http://machinelife.zenkiren.net/" />
  <base href="{$_conf.site_uri}" />
  *}
</head>
<body style="margin:0;color:#333;font-size:13px;line-height:1.4;font-family:'メイリオ', Meiryo, 'Lucida Grande', Verdana, 'ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro';">

<a href='{$_conf.site_uri}' style="margin: 8px;"><img src='{$_conf.site_uri}imgs/logo_zenkiren_mini.png' alt="全機連 中古機械情報" style="border:0;"/></a>

<h1 style="border-left:6px solid #147543;margin: 0 auto 6px auto;height: 20px;line-height: 20px;margin: 8px;font-size: 18px;font-weight: bold;text-indent: 13px;"
  >マシンライフ中古機械情報 新着情報</h1>

<div style="margin: 8px;">
  {$date|strtotime|date_format:'%Y/%m/%d'}に登録された中古機械新着情報をお送りいたします。(総件数:{$count}件)
</div>

<ul>
{foreach $largeGenreList as $l}
  <li>
    <a href="{$_conf.site_uri}news.php?date={$date}&l={$l.id}" target="_blank">{$l.large_genre} ({$l.count})</a>
    <ul>
      {foreach $machineList as $m}
        {if $m.large_genre_id == $l.id}
          <li>
            <a href="{$_conf.site_uri}machine_detail.php?m={$m.id}" target="_blank">
              {$m.name} {$m.maker} {$m.model} {if !empty($m.year)}{$m.year}年式{/if} : {'/(株式|有限|合.)会社/'|preg_replace:'':$m.company}
            </a>
          </li>
        {/if}
      {/foreach}
    </ul>
  </li>
{/foreach}
</ul>

{if !empty($bidinfoList)}
<h1 style="border-left: 6px solid #147543;margin: 0 auto 6px auto;height: 20px;line-height: 20px;margin: 8px;font-size: 18px;font-weight: bold;text-indent: 13px;"
  >入札会情報</h1>

<table style="margin: 0 auto 8px auto;width:96%;font-size:13px;line-height:1.4;" border="1">
  <tr style="background:#CFC;">
    <th>入札会名</th>
    <th>主催者名</th>
    <th>会場</th>
    <th>下見期間</th>
    <th>入札締切日時</th>
  </tr>
  
  {foreach $bidinfoList as $b}
  <tr style="background:#FFF;">
    <td><a href="{$b.uri}" target="_blank">{$b.bid_name}</a></td>
    <td>{$b.organizer}</td>
    <td>{$b.place|escape|nl2br nofilter}</td>
    <td>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</td>
    <td>{$b.bid_date|date_format:'%Y/%m/%d %H:%M'}</td>
  </tr>
  {/foreach}
</table>
{/if}

<a href="{$_conf.site_uri}help_mailuser_unsend_form.php">メール配信停止はこちら＞＞</a>
  
<div style="margin-top: 8px;width: 100%;height: 30px;line-height: 30px;text-align: center;background: #111;color: #FFF;">
  Copyright &copy; {$smarty.now|date_format:"%Y"} <a href="http://www.zenkiren.net" target="_blank" style="color:#FFF;">全日本機械業連合会</a> All Rights Reserved.
</div>
</body>
</html>
