<!DOCTYPE html>
<html lang='ja'>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta http-equiv="Content-Script-Type" content="text/javascript" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />

  <base href="https://www.zenkiren.net" />

<meta name="robots" content="noindex, nofollow" />

{literal}
<style type="text/css">
.bid_machine_list {
  border-collapse: collapse;
  border-spacing: 0;
  width: 720px;
}

.bid_machine_list th,
.bid_machine_list td {
  border: 1px solid #333;
  padding: 2px;
  font-size: 12px;
  font-weight: normal;
  white-space: nowrap;
  vertical-align: middle;
}

.bid_machine_list th {
  font-size: 11px;
}

.bid_machine_list .no {
  width: 40px;
}

.bid_machine_list th.name,
.bid_machine_list td.name {
  width: 70px;
}

.bid_machine_list th.model,
.bid_machine_list td.model {
  width: 70px;
}

.bid_machine_list th.model,
.bid_machine_list td.model {
  width: 70px;
}

.bid_machine_list .year {
  width: 32px;
}

.bid_machine_list .addr {
  width: 54px;
}

.bid_machine_list .spec {
  font-size: 11px;
}

.bid_machine_list td.no,
.bid_machine_list td.year,
.bid_machine_list td.min_price {
  text-align: right;
}

.bid_machine_list .min_price {
  width: 70px;
}
</style>
{/literal}

</head>
<body class="mini">

<table class="bid_machine_list">
  <thead>
    <tr>
      <th class="no">出品番号</th>
      <th class="name">商品名</th>
      <th class="maker">メーカー</th>
      <th class="model">型式</th>
      <th class="year">年式</th>
      <th class="addr">在庫地域</th>
      <th class="spec">仕様</th>
      <th class="min_price">最低入札金額</th>
    </tr>
  </thead>

  {foreach $bidMachineList as $m}
    <tr>
      <td class="no">{$m.list_no}</td>
      <td class="name">{$m.name|escape|wordwrap:7:"\n":true|trim|nl2br nofilter}</td>
      <td class="maker">{$m.maker|escape|wordwrap:7:"\n":true|trim|nl2br nofilter}</td>
      <td class="model">{$m.model|escape|wordwrap:12:"\n":true|trim|nl2br nofilter}</td>
      <td class="year">{$m.year}</td>
      <td class="addr">{$m.addr1|trim}</td>
      <td class="spec">{$m.spec|trim}</td>
      <td class="min_price">{$m.min_price|number_format}</td>
    </tr>
  {/foreach}
</table>
</body>
</html>
