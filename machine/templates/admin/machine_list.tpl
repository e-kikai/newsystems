{extends file='include/layout.tpl'}

{block 'header'}

  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    //// 変数の設定 ////
    var checkList = {
      'view_option_0': ['.view_option', ''],
      'view_option_1': ['.view_option', '非'],
      'view_option_2': ['.view_option', '商談'],
      'commission_0': ['.commission', ''],
      'commission_1': ['.commission', '可'],
      'location_address': ['.location', '本社'],
      {if !empty($company)}
        {foreach $company.offices as $o}
          'location_{$o@key}' : ['.location', '{$o.name}'],
        {/foreach}
      {/if}
    }

    {literal}
      $(function() {
          //// サムネイル画像の遅延読み込み（Lazyload） ////
          $('img.lazy').css('display', 'block').lazyload({
            effect: "fadeIn"
          });

          //// すべて表示：メーカー ////
          $('a.maker_all').click(function() {
            $('.maker_area input:checked').removeAttr('checked');
            $('.maker_area input:checkbox').first().change();
            return false;
          });

          //// すべて表示：ジャンル ////
          $('a.genre_all').click(function() {
            $('.genre_area input:checked').removeAttr('checked');
            $('.genre_area input:checkbox').first().change();
            return false;
          });

          //// ジャンル・メーカーで絞り込む ////
          $('.genre_area input:checkbox, .maker_area input:checkbox').change(function() {
            // 前処理、すべて表示
            $('.machine').show();

            // ジャンル絞り込み
            var searchGenre = $('.genre_area input:checked')
              .map(function() { return $(this).val(); })
              .get().join('|');

            if (searchGenre != '') {
              var re = new RegExp("([^0-9]|^)(" + searchGenre + ")([^0-9]|$)");
              // console.log("([^0-9]|^)(" + searchGenre + ")([^0-9]|$)");
              $('.machine').filter(function(i) {
                var flg = true;
                $(this).find('.genre_id').each(function() {
                  if ($(this).text().match(re)) { flg = false; return false; }
                });

                return flg;
              }).hide();
            }

            // メーカー絞り込み
            var searchMaker = $('.maker_area input:checked')
              .map(function() { return $(this).val(); })
              .get().join('|');

            if (searchMaker != '') {
              var re = new RegExp('(^|\|)(' + searchMaker + ')($|\|)');
              $('.machine').filter(function(i) {
                return !$(this).find('.maker').text().match(re);
              }).hide();
            }

            // 色分けの再編
            $('.machine:visible').removeClass('even').removeClass('odd');
            $('.machine:visible:even').addClass('even');
            $('.machine:visible:odd').addClass('odd');

            // Lazyload用スクロール
            $(window).triggerHandler('scroll');
          });

          /*
      $('form.delete').submit(function() {
          if (confirm('この在庫機械情報を削除しますか？')) {
              return ture;

          } else {
              return false;
          }
      });
      */

          //// 一括処理 ////
          /*
    $('select.action').change(function() {
        var action = $(this).val();

        if (!action) { return false; }

        // チェック情報を取得
        var vals = $('input.m:visible:checked').map(function() {
            return $(this).val();
        }).get();

        if (!vals.length) {
            alert('処理を行いたい在庫機械情報にチェックを入れてください');
            $(this).val('');
            return false;
        }

        if (confirm($(
            'select.action option:selected').text() +
            "\nチェックした " + vals.length + "件 の在庫機械にこの処理を行いますか？"
        )) {
            // 処理を実行
            $.post('../ajax/admin_machine_list.php',
{"target": "machine", "action": action, "data": vals},
          function(data) {
            location.href = '/admin/machine_list.php';
          }
        );
      }
      else {
        $(this).val('');
        return false;
      }
      });
      */

      //// 一括チェック ////
      $('select.check').change(function() {
        var action = $(this).val();

        // チェックをリセット
        $('input.m').removeAttr('checked');

        if (action == 'all') {
          $('input.m:visible').attr('checked', 'checked');
        } else if (checkList[action]) {
          $('tr.machine:visible').each(function(i, val) {
            if ($(this).find(checkList[action][0]).text() == checkList[action][1]) {
              $(this).find('input.m').attr('checked', 'checked');
            }
          });
        }
      });

      //// 一括削除 ////
      $('button.delete').click(function() {
      // チェック情報を取得
      var vals = $('input.m:visible:checked').map(function() {
        return $(this).val();
      }).get();

      if (!vals.length) {
        alert('削除を行いたい在庫機械情報にチェックを入れてください');
        return false;
      }

      if (confirm("チェックした " + vals.length + "件 の在庫機械の削除を行いますか？")) {
        // 処理を実行
        $.post('../ajax/admin_machine_list.php',
          {"target": "machine", "action": 'delete', "data": vals},
          function(data) {
            location.reload();
          }
        );
      } else {
        return false;
      }
      });
      });
    </script>
    <style type="text/css">
      table.list .location,
      table.list .number {
        width: 70px;
      }

      table.list .count {
        width: 50px;
      }

      table.list td.count {
        text-align: right;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <fieldset class="search">
    <legend>検索</legend>
    <form method="GET" id="company_list_form">
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
      -
      <select class="order" name="order">
        <option value="">▼並び順▼</option>
        <option value="no" {if $q.sort=="no"} selected="selected" {/if}>管理番号</option>
        <option value="name" {if $q.sort=="name"} selected="selected" {/if}>機械名</option>
        <option value="maker" {if $q.sort=="maker"} selected="selected" {/if}>メーカー</option>
        <option value="model" {if $q.sort=="model"} selected="selected" {/if}>型式</option>
        <option value="year" {if $q.sort=="year"} selected="selected" {/if}>年式</option>
        <option value="created_at" {if $q.sort=="created_at"} selected="selected" {/if}>登録日時</option>
      </select>

      <br />
      登録日{html_select_date prefix='start' field_order='YMD' time=$q.start_date
          year_empty='年' month_empty='月' day_empty='日' month_format='%m'
          start_year='2012' reverse_years=true field_separator=" / "} ～
      {html_select_date prefix='end' field_order='YMD' time=$q.end_date
          year_empty='年' month_empty='月' day_empty='日' month_format='%m'
          start_year='2012' reverse_years=true field_separator=" / "}


      <button type="submit" class="company_list_submit">検索</button>

      <a href="/admin/machine_list.php">条件リセット</a>
    </form>
  </fieldset>

  <a class="new" href="admin/machine_form.php">新規登録する</a>

  {if empty($machineList)}
    <div class="error_mes">条件に合う機械はありません</div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  {foreach $machineList as $m}
    {if $m@first}
      <div class="">同期の項目について、◯:新九郎、CSVで同期された機械、△:同期後に変更を行った機械(削除以外の同期の影響を受けません)</div>
      <table class="machines list">
        <tr>
          <th class="check"><button class="delete">削除</button></th>
          <th class="img"></th>
          <th class="uid">同期</th>
          <th class="number">管理番号</th>
          <th class="name">機械名</th>
          <th class="maker">メーカー</th>
          <th class="model">型式</th>
          <th class="year">年式</th>
          <th class="capacity">能力</th>
          <th class="location">在庫場所</th>
          <th class="commission">試運</th>
          <th class="view_option">表示</th>
          <th class="created_at">登録日</th>
          <th class="count">閲覧数<br />過去7日</th>
        </tr>
      {/if}

      <tr>
        <td class="check"><input type="checkbox" class="m" value="{$m.id}" /></td>
        <td class="img">
          <div class="genre_id">{$m.genre_id}</div>
          {if !empty($m.top_img)}
            <img class="lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='' />
            <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt='PDF' /></noscript>
          {/if}
        </td>
        <td class="uid">{if !empty($m.used_id) && !empty($m.used_change)}△{elseif !empty($m.used_id)}◯{/if}</td>
        <td class="number">{$m.no}</td>
        <td class="name"><a href="admin/machine_form.php?m={$m.id}">{$m.name}</a></td>
        <td class="maker">{$m.maker}</td>
        <td class="model">{$m.model}</td>
        <td class="year">{$m.year}</td>
        <td class="capacity">{if !empty($m.capacity_label)}{$m.capacity}{$m.capacity_unit}{/if}</td>
        <td class="location">{$m.location}</td>
        <td class="commission">{if !empty($m.commission)}可{/if}</td>
        <td class="view_option">{if $m.view_option==1}非{elseif $m.view_option==2}商談{/if}</td>
        <td class="created_at">{$m.created_at|date_format:'%Y/%m/%d'}</td>
        <td class="count">{$actionCountPair[$m.id]|number_format}</td>
      </tr>

      {if $m@last}
      </table>
      <button class="delete">削除</button>
    {/if}
  {/foreach}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

{/block}