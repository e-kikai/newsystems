{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

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

      div.table_area {
        height: auto;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <form method="GET" id="" action="/system/admin_history_logs/" class="row align-items-end justify-content-center mb-2">
    <div class="col-2">
      <label for="target" class="form-label">ページ</label>
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

    <div class="col-1 px-0">
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

  {if empty(count($admin_history_logs))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-pen-to-square"></i> 会員ページ分析ログは、まだありません。
    </div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl" pager=$r}

  <div class="table_area max_area">
    <table class="machines list">
      {foreach $admin_history_logs as $ahl}
        {if $ahl@first}
          <tr>
            {*
            <th class="id">ID</th>
            *}
            <th class="created_at">登録日時</th>
            <th class="id">管理者</th>
            <th class="company">会社名</th>
            <th class="uniq_account">utag</th>
            <th class="IP">IP</th>
            {*
            <th class="host">host</th>
            *}
            <th class="page">ページ</th>
            <th class="event">イベント</th>
            <th class="datas">datas</th>
            <th class="referer">リファラ</th>
          </tr>
        {/if}

        <tr {if !empty($ahl.deleted_at)} class="deleted" {/if}>
          {*
          <td class="id text-right">{$ahl.id}</td>
          *}
          <td class="created_at">{$ahl.created_at|date_format:'%m/%d %H:%M:%S'}</td>
          <td class="id text-center">{if $ahl.is_system}◯{/if}</td>
          <td class='company'>{$ahl.company_id}: {'/(株式|有限|合.)会社/u'|preg_replace:' ':$ahl.company|trim}</td>
          <td class="uniq_account">{$ahl.utag}</td>
          <td class="ip">{$ahl.ip}</td>
          {*
          <td class="host">{$ahl.host}</td>
          *}
          <td class="page">{$ahl.page}</td>
          <td class="event">{$ahl.event}</td>
          <td class="datas">{$ahl.datas}</td>
          <td class="referer">
            {if !empty($ahl.referer)}
              <a href="{$ahl.referer}" target="_blank">
                {$ahl.referer}
              </a>
            {/if}
          </td>
        </tr>
      {/foreach}
    </table>
  </div>
{/block}