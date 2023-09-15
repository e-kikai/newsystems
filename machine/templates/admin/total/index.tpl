{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css?4" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>

    <style type="text/css">
      table.list td,
      table.list th {
        border: 1px solid #dee2e6;
        padding: 4px;
      }

      table.list .id {
        width: 42px;
      }

      table.list th.sepa,
      table.list td.sepa {
        border-left: 3px double #dee2e6;
      }

      .table_area.max_area table tfoot {
        border-top: 3px double #dee2e6;
      }

      table.list td.ave {
        text-align: right;
        width: 42px;
      }

      table.list .genre {
        width: 160px;
        max-width: 160px;
        padding: 4px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      table.list .xl_genre {
        width: 100px;
        max-width: 100px;
      }

      a .d-inline-block {
        text-decoration: underline;
      }

      div.table_area {
        height: auto;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <form method="GET" id="" action="/admin/total/" class="row align-items-end justify-content-center mb-2">
    <div class="col-2">
      <label for="target" class="form-label">対象</label>
      <select class="form-select" id="target" name="target">
        {foreach $target_selector as $key => $val}
          <option value="{$val}" {if $val == $target} selected="selected" {/if}>{$key}</option>
        {/foreach}
      </select>
    </div>

    <div class="col-2">
      <label for="dYear" class="form-label">表示年</label>
      <select class="form-select" id="dYear" name="dYear">
        {foreach range(date('Y'), 2013) as $key => $val}
          <option value="{$val}" {if $val == date('Y', strtotime($date))} selected="selected" {/if}>{$val}</option>
        {/foreach}
      </select>
    </div>

    <div class="col-2">
      <label for="dMonth" class="form-label">表示月</label>
      <select class="form-select" id="dMonth" name="dMonth">
        {foreach range(1,12) as $key => $val}
          <option value="{$val}" {if $val == date('m', strtotime($date))} selected="selected" {/if}>{$val}</option>
        {/foreach}
      </select>
    </div>

    <div class="col-2">
      <button type="submit" class="btn btn-md btn-primary">
        <i class="fas fa-bars-staggered"></i>
        集計
      </button>
    </div>

    <div class="col-2">
      <button type="submit" class="btn btn-md btn-success" name="output" value="csv">
        <i class="fas fa-file-csv"></i>
        CSV出力
      </button>
    </div>
  </form>

  <div class="table_area max_area">
    {$keys = array_keys($results)}
    {$cls = []}
    {foreach $keys as $key}
      {if preg_match("/金額/", $key)}
        {$cls[$key] = "min_price"}
      {else if preg_match("/件数/", $key)}
        {$cls[$key] = "num sepa"}
      {else if preg_match("/平均/", $key)}
        {$cls[$key] = "ave"}
      {else if is_numeric(current($results[$key]))}
        {if current($results[$key]) > 10000}
          {$cls[$key] = "min_price"}
        {else}
          {$cls[$key] = "num"}
        {/if}
      {else if preg_match("/会社|氏名/", $key)}
        {$cls[$key] = "company2"}
      {else if preg_match("/特大ジャンル/", $key)}
        {$cls[$key] = "xl_genre genre"}
      {else if preg_match("/ジャンル/", $key)}
        {$cls[$key] = "genre"}
      {else if preg_match("/都道府県/", $key)}
        {$cls[$key] = "addr1"}
      {else}
        {$cls[$key] = "text"}
      {/if}
    {/foreach}

    <table class="machines list">

      {foreach $ids as $id}
        {if ($id@index % 50) == 0}
          <thead>
            <tr>
              <th class="id">ID</th>
              {foreach $keys as $key}
                <th class="{$cls[$key]}">{$key}</th>
              {/foreach}
            </tr>
          </thead>
        {/if}

        <tr>
          <td class="id">{$id}</td>
          {foreach $keys as $key}
            <td class="{$cls[$key]}">
              {if preg_match("/(num|min_price)/", $cls[$key])}
                {$results[$key][$id]|number_format}
              {else if preg_match("/(ave)/", $cls[$key])}
                {$results[$key][$id]|number_format:2}
              {else}
                {$results[$key][$id]}
              {/if}
            </td>
          {/foreach}
        </tr>

      {/foreach}
      <tfoot>
        <tr>
          <td class="id">合計</td>
          {foreach $keys as $key}
            <td class="{$cls[$key]}">
              {if preg_match("/(num|min_price)/", $cls[$key])}
                {array_sum($results[$key])|number_format}
              {/if}
            </td>
          {/foreach}
        </tr>

        <tr>
          <th class="id">ID</th>
          {foreach $keys as $key}
            <th class="{$cls[$key]}">{$key}</th>
          {/foreach}
        </tr>
      </tfoot>
    </table>
  </div>
{/block}