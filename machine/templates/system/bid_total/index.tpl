{extends file='include/layout.tpl'}

{block 'header'}
  <script type="text/javascript" src="{$_conf.libjs_uri}/scrolltopcontrol.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript"></script>
    <style type="text/css"></style>
  {/literal}
{/block}

{block 'main'}
  {if empty($results)}
    <div class="error_mes">条件に合う内容がありません。</div>
  {/if}

  <a href="{$smarty.server.REQUEST_URI}&output=csv" class="btn btn-primary"
    style="position: absolute; right: 8px; top: -46px;">
    <i class="fas fa-file-csv"></i> CSV出力
  </a>

  <div class="table_area max_area">
    {$keys = array_keys($results)}
    {$cls = []}
    {foreach $keys as $key}

      {if is_numeric(current($results[$key]))}
        {if current($results[$key]) > 10000}
          {$cls[$key] = "min_price"}
        {else}
          {$cls[$key] = "num"}
        {/if}
      {else if preg_match("/金額/", $key)}
        {$cls[$key] = "min_price"}
      {else if preg_match("/会社|氏名/", $key)}
        {$cls[$key] = "company2"}
      {else if preg_match("/ジャンル/", $key)}
        {$cls[$key] = "genre"}
      {else if preg_match("/都道府県/", $key)}
        {$cls[$key] = "addr1"}
      {else}
        {$cls[$key] = "text"}
      {/if}
    {/foreach}

    {foreach $ids as $id}
      {if $id@first}
        <table class="machines list">
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
              {else}
                {$results[$key][$id]}
              {/if}
            </td>
          {/foreach}
        </tr>

        {if $id@last}
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

          </tfoot>
        </table>
      {/if}
    {/foreach}
  </div>
{/block}