{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css?4" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 画像拡大処理 ///
        // 表示枠の作成
        $('<img class="hoverimg">').appendTo('body').hide();

        // 表示・非表示処理
        $(document).on('mouseover', 'img.hover', function() {
          $('.hoverimg')
            .attr('src', $(this).data('source'))
            .css('top', $(this).offset().top - $(this).height() / 2)
            .css('left', $(this).offset().left + $(this).width() + 16)
            .show();
        });

        $(document).on('mouseout', 'img.hover', function() { $('.hoverimg').hide(); });
      });

      window.onload = () => {
        /// イベントロギング ///
        document.querySelectorAll(".log").forEach(function(elem) {
          elem.addEventListener("click", (e) => {
            let datas = JSON.parse(elem.getAttribute("data-json"));
            set_log("histories", "click", datas);
          }, true);
        });
      };

      /// ajaxでログ保存 ///
      async function set_log(page, event, datas) {
        const url = "/admin/ajax/admin_history_logs.php";
        const body = {"page": page, "event": event, "datas": datas};

        fetch(url, {
            method: "POST",
            headers: {'Content-Type': 'application/json' },
            body: JSON.stringify(body)
          })
          .then(res => res.text())
          .then(text => { if (text != "success") { console.log(text); } })
          .catch(error => console.error('error : ', error));
      }
    </script>

    <style type="text/css">
      table.list td {
        border: 1px solid #dee2e6;
      }

      img.hoverimg {
        display: block;
        position: absolute;
        max-width: 400px;
        max-height: 400px;
        border: 1px solid #aaa;
        box-shadow: 6px 6px 6px rgba(0, 0, 0, 0.6);
      }

      table.list .id {
        width: 70px;
        padding: 4px;
      }

      table.list .name {
        width: 250px;
        padding: 4px;
      }

      table.list .created_at {
        width: 140px;
        padding: 4px;
      }

      table.list .deleted_at {
        width: 140px;
        padding: 4px;
      }

      table.list .company {
        width: 150px;
        padding: 4px;
      }

      table.list .year {
        width: 70px;
        padding: 4px;
      }

      table.list .addr1 {
        width: 80px;
        padding: 4px;
      }

      table.list tr:nth-child(even) .deleted,
      table.list .deleted {
        background-color: #EEE;
      }

      table.list tr.selected:nth-child(even) td,
      tr.selected td {
        background-color: gold;
      }

      a .d-inline-block {
        text-decoration: underline;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <form method="GET" id="" action="/admin/histories/" class="row align-items-end justify-content-center mb-2">
    <input type="hidden" name="id" value="{$machine["id"]}" />

    <div class="col-2">
      <label for="large_genre" class="form-label">ジャンル</label>
      <select class="form-select" id="large_genre" name="large_genre_id">
        <option value="">未選択</option>
        {foreach $xl_genres as $xg}
          <optgroup label="{$xg.xl_genre}">
            {foreach $large_genres as $lg}
              {if $lg.xl_genre_id == $xg.id}
                <option value="{$lg.id}" {if $lg.id == $large_genre_id} selected="selected" {/if}>
                  {$lg.large_genre}
                </option>
              {/if}
            {/foreach}
          </optgroup>
        {/foreach}
      </select>
    </div>

    <div class="col-2">
      <label for="maker" class="form-label">メーカー</label>
      <input type="text" id="maker" name="maker" value="{$maker}" class="form-control" placeholder="" />
    </div>

    <div class="col-2">
      <label for="model" class="form-label">型式(部分一致)</label>
      <input type="text" id="model" name="model" value="{$model}" class="form-control" placeholder="型式(前方一致)" />
    </div>

    <div class="col-2">
      <label for="range" class="form-label">表示期間</label>
      <select class="form-select" id="range" name="range">
        {foreach $range_selector as $key => $val}
          <option value="{$val}" {if $val == $range} selected="selected" {/if}>{$key}</option>
        {/foreach}
      </select>
    </div>
    <div class="col-2">
      <button type="submit" class="btn btn-md btn-primary">
        <i class="fas fa-bars-staggered"></i>
        検索
      </button>
    </div>
  </form>

  {if empty($model)}
    <div class="alert alert-info col-8 mx-auto">
      <i class="fas fa-circle-info"></i>
      型式(部分一致)をもとに同一の機械の在庫登録・削除の履歴を一覧できます。<br /><br />
      ジャンル、メーカーも指定すると、さらに絞り込むことができます(いずれかに一致)。
    </div>
  {elseif empty($histories)}
    <div class="alert alert-danger col-8 mx-auto">
      <i class="fas fa-triangle-exclamation"></i>
      条件に合う検索結果がありませんでした。<br /><br />
      ・ 「表示期間」を伸ばす<br />
      ・ 型式の後半部分を削除してみる(「OBS-60-32B」を「OBS-60」にしてみる)<br />
      ・ ジャンル、メーカーをしている場合は、それを消去して再検索<br />
      などをお試しください。
    </div>
  {else}
    <table class='list contact'>
      <thead>
        <tr>
          <th class='id'>ID</th>
          <th class="img"></th>
          <th class="name">機械名</th>
          <th class="created_at">登録日時</th>
          <th class="deleted_at">削除日時</th>
          <th class="year">年式</th>
          <th class="company">出品会社</th>
          <th class="addr1">都道府県</th>
        </tr>
      </thead>

      {foreach $histories as $ma}
        {$data = ["link" => "machine_detail", "machine_id" => $ma["id"]]}

        <tr {if !empty($machine) && $ma.id == $machine.id}class="selected" {/if}>
          <td class='id'>{$ma.id}</td>
          <td class="img">
            {if !empty($ma.top_img)}
              <a href="/machine_detail.php?m={$ma.id}" target="_blank" class="log" data-json="{$data|json_encode}">
                <img class="lazy hover" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$ma.top_img}"
                  data-source="{$_conf.media_dir}machine/{$ma.top_img}" alt='' />
                <noscript><img src="{$_conf.media_dir}machine/thumb_{$ma.top_img}" alt='PDF' /></noscript>
              </a>
            {else}
              <a href="/machine_detail.php?m={$ma.id}" target="_blank" class="log" data-json="{$data|json_encode}">
                <img class='top_image noimage' src='./imgs/noimage.png' alt='' />
              </a>
            {/if}
          </td>

          <td class='name'>
            <a href="/machine_detail.php?m={$ma.id}" target="_blank" class="log" data-json="{$data|json_encode}">
              <div class="d-inline-block">{$ma.name}</div>
              <div class="d-inline-block">{$ma.maker}</div>
              <div class="d-inline-block">{$ma.model}</div>
            </a>
          </td>
          <td class='created_at text-end'>
            {$ma.created_at|date_format:'%Y/%m/%d %H:%M'}
          </td>
          <td class='deleted_at text-end {if !empty($ma.deleted_at)}deleted{/if}'>
            {$ma.deleted_at|date_format:'%Y/%m/%d %H:%M'}
          </td>
          <td class='year'>{$ma.year}</td>
          <td class='company'>
            <a href='/company_detail.php?c={$ma.company_id}'>
              {'/(株式|有限|合.)会社/u'|preg_replace:'':$ma.company}
            </a>
          </td>
          <td class='addr1'>{$ma.addr1}</td>
        </tr>
      {/foreach}
    </table>
  {/if}
{/block}