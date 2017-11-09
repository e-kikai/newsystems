<?php
/**
 * 自社サイトテンプレートCSS生成
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2013/04/11
 */
require_once '../../../lib-machine.php';

// テンプレート名を分割
$t = Req::query('t');
$tempName = explode('_', $t);

// テンプレート名がなければ,デフォルト
$temps = Companysites::getTempalteColors();

if (empty($temps[$tempName[0]])) { $temps = array('cyan', '01'); }
$temp = $temps[$tempName[0]];

// 元色から、各色の生成
$rev = ($temp[0] + 180) % 360;
$tColors = array(
    'darkness'  => Companysites::hsv2rgb($temp[0], 1.00, 0.15),
    'dark'      => Companysites::hsv2rgb($temp[0], 1.00, 0.40),
    'base'      => Companysites::hsv2rgb($temp[0], 0.85, 0.75),
    'right'     => Companysites::hsv2rgb($temp[0], 0.25, 1.00),
    'rightness' => Companysites::hsv2rgb($temp[0], 0.10, 1.00),    
    'rev'       => Companysites::hsv2rgb($rev,     0.70, 0.50),
    'rightrev'  => Companysites::hsv2rgb($rev,     0.25, 1.00),
    'darkrev'   => Companysites::hsv2rgb($rev,     1.00, 0.40),    
);
?>
<?php header('Content-Type: text/css; charset=utf-8'); ?>
@charset "utf-8";
strong.header_catchcopy,
footer {
  background: <?=$tColors['darkness'];?>;
}

header {
  background: <?=$tColors['base'];?>;
}

.header_menu {
  background: <?=$tColors['base'];?>;
}

.header_menu a {
  background: -webkit-gradient(linear, left top, left bottom, color-stop(1.00, #FFFFFF), color-stop(0.22, <?=$tColors['right'];?>));
  background: -moz-linear-gradient(top, #FFFFFF 100%, <?=$tColors['right'];?> 22%);
  background: -o-linear-gradient(top, #FFFFFF 100%, <?=$tColors['right'];?> 22%);
  background: -ms-linear-gradient(top, #FFFFFF 100%, <?=$tColors['right'];?> 22%);
  background: linear-gradient(top, #FFFFFF 100%, <?=$tColors['right'];?> 22%);
}

a.button {
  /*
  border: 1px solid <?=$tColors['base'];?>;
  background: #b9ce44;

  background: -webkit-gradient(linear, left top, left bottom, color-stop(0.96, <?=$tColors['dark'];?>), color-stop(0.51, <?=$tColors['base'];?>), color-stop(0.50, #8eb92a), color-stop(0.08, #a8c732), color-stop(0.00, #b9ce44));
  background: -webkit-linear-gradient(top, #b9ce44 0%, #a8c732 8%, #8eb92a 50%, <?=$tColors['base'];?> 51%, <?=$tColors['dark'];?> 96%);
  background: -moz-linear-gradient(top, #b9ce44 0%, #a8c732 8%, #8eb92a 50%, <?=$tColors['base'];?> 51%, <?=$tColors['dark'];?> 96%);
  background: -o-linear-gradient(top, #b9ce44 0%, #a8c732 8%, #8eb92a 50%, <?=$tColors['base'];?> 51%, <?=$tColors['dark'];?> 96%);
  background: -ms-linear-gradient(top, #b9ce44 0%, #a8c732 8%, #8eb92a 50%, <?=$tColors['base'];?> 51%, <?=$tColors['dark'];?> 96%);
  background: linear-gradient(top, #b9ce44 0%, #a8c732 8%, #8eb92a 50%, <?=$tColors['base'];?> 51%, <?=$tColors['dark'];?> 96%);
  */

  border: 1px solid <?=$tColors['darkrev'];?>;
  background: <?=$tColors['rev'];?>;
  border-radius: 2px;
}

table.machines th {
  background: <?=$tColors['base'];?>;
}

table.machines tr.odd td {
  background: <?=$tColors['rightness'];?>;
}

table.company th {
  background: <?=$tColors['base'];?>;
}

table.mysite th:before,
ul.maker_area li:before {
  content:"■";
  color: <?=$tColors['rev'];?>;
  font-size: 13px;
}

table.company th:before {
  content:"";
}

h1 {
  border-left-color: <?=$tColors['rev'];?>;
}

.machines td.buttons a {
    border: 1px solid #DB6E00;
    background: rgb(234, 120, 19);
    border-radius: 2px;
}