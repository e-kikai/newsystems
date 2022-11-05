{extends file='include/layout.tpl'}

{block 'header'}

  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        $('button.bid_entry').click(function() {
          var $_self = $(this);
          var $_parent = $_self.closest('tr');

          var data = {
            'machine_id': $.trim($_self.val()),
            'min_price': $_parent.find('input.min_price').val(),
            'bid_open_id': $('input.bid_open_id').val(),
          }

          var e = '';

          if (!data['min_price']) {
            e = '最低入札金額が入力されていません';
          } else if (data['min_price'] < parseInt($('input.bidopen_min_price').val())) {
            e = '最低入札金額が、入札会の最低入札金額より小さく入力されています';
          } else if ((data['min_price'] % parseInt($('input.bidopen_rate').val())) != 0) {
            e = '最低入札金額が、入札レートの倍数ではありません';
          }
          if (e != '') { alert(e); return false; }

          // 送信確認
          var mes = $_parent.find('td.number').text() + ' ' + $_parent.find('td.name').text() + ' ';
          mes += $_parent.find('td.maker').text() + ' ' + $_parent.find('td.model').text() + "\n";
          mes += '最低入札金額 : ' + data['min_price'] + "円\n\n";
          mes += 'この商品を出品します。よろしいですか。';


          if (!confirm(mes)) { return false; }

          $_self.attr('disabled', 'disabled').text('処理中');

          $.post('/admin/ajax/bid.php', {
            'target': 'admin',
            'action': 'set2machine',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              $_self.removeAttr('disabled').text('出品');
              alert(res);
              return false;
            }

            // 登録完了
            alert('出品処理が完了しました');
            $_parent.find('td.bid').text('出品中');
            return false;
          }, 'text');

          return false;
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  <fieldset class="search">
    <legend>検索</legend>
    <form method="GET" id="company_list_form">
      <input type="hidden" name="o" value="{$bidOpenId}" />
      <select class="genre_id" name="g">
        <option value="">▼ジャンル▼</option>
        {foreach $genreList as $g}
          {if !empty($g.id)}
            <option value="{$g.id}" {if $q.genre_id==$g.id} selected="selected" {/if}>{$g.genre} ({$g.count})</option>
          {/if}
        {/foreach}
      </select>

      <select class="maker" name="m">
        <option value="">▼メーカー▼</option>
        {foreach $makerList as $m}
          {if !empty($m.maker)}
            <option value="{$m.maker}" {if $q.maker==$m.maker} selected="selected" {/if}>{$m.maker} ({$m.count})</option>
          {/if}
        {/foreach}
      </select>
      <input type="text" class="keyword_search" name="k" value="{$q.keyword}" placeholder="キーワード検索">
      <br />
      登録日{html_select_date prefix='start' field_order='YMD' time=$q.start_date
          year_empty='年' month_empty='月' day_empty='日' month_format='%m'
          start_year='2012' reverse_years=true field_separator=" / "} ～
      {html_select_date prefix='end' field_order='YMD' time=$q.end_date
          year_empty='年' month_empty='月' day_empty='日' month_format='%m'
          start_year='2012' reverse_years=true field_separator=" / "}


      <button type="submit" class="company_list_submit">検索</button>

      <a href="/admin/bid_machine2machine.php?o={$bidOpenId}">条件リセット</a>
    </form>
  </fieldset>

  {if empty($machineList)}
    <div class="error_mes">条件に合う機械はありません</div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}


  <input type="hidden" name="bid_open_id" class="bid_open_id" value="{$bidOpenId}" />
  <input type="hidden" name="min_price" class="bidopen_min_price" value="{$bidOpen.min_price}" />
  <input type="hidden" name="rate" class="bidopen_rate" value="{$bidOpen.rate}" />

  {foreach $machineList as $m}
    {if $m@first}
      <div class="">同期の項目について、◯:新九郎、CSVで同期された機械、△:同期後に変更を行った機械(削除以外の同期の影響を受けません)</div>
      <table class="machines list">
        <tr>
          <th class="img"></th>
          <th class="uid">同期</th>
          <th class="number">管理番号</th>
          <th class="name">機械名</th>
          <th class="maker">メーカー</th>
          <th class="model">型式</th>
          <th class="year">年式</th>
          <th class="capacity">能力</th>
          <th class="location">在庫場所</th>
          <th class="bid">入札会に出品</th>
        </tr>
      {/if}

      <tr>
        <td class="img">
          <div class="genre_id">{$m.genre_id}</div>
          {if !empty($m.top_img)}
            <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
            <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
          {/if}
        </td>
        <td class="uid">{if !empty($m.used_id) && !empty($m.used_change)}△{elseif !empty($m.used_id)}◯{/if}</td>
        <td class="number">{$m.no}</td>
        <td class="name">{$m.name}</td>
        <td class="maker">{$m.maker}</td>
        <td class="model">{$m.model}</td>
        <td class="year">{$m.year}</td>
        <td class="capacity">{if !empty($m.capacity_label)}{$m.capacity}{$m.capacity_unit}{/if}</td>
        <td class="location">{$m.location}</td>

        <td class="bid">
          {if !empty($m.bid_title)}
            {$m.bid_title} 出品中<br />
            最低入札金額 : {$m.min_price|number_format}円
          {elseif empty($m.top_img)}
            TOP画像が必要です
          {else}
            {*
      <input type="text" class="min_price num" value="" placeholder="最低入札金額(円)" />
      <button class="bid_entry" value="{$m.id}" data-label="{$m.no} {$m.name} {$m.maker} {$m.model}" >出品</button>
      *}
            <a href="/admin/bid_machine_form.php?o={$bidOpenId}&machine_id={$m.id}" class="button">出品</button>
            {/if}
        </td>
      </tr>

      {if $m@last}
      </table>
    {/if}
  {/foreach}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}