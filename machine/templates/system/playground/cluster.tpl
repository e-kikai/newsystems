{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {});
    </script>
    <style type="text/css">
      .cluster {
        width: 148px;
        height: 148px;
        border: 1px solid #999;
        padding: 2px;
        float: left;
        display: block;
        margin-right: 4px;
        margin-bottom: 4px;
        text-align: center;
        ;
      }

      a.cluster_title {
        display: block;
      }

      .score {
        color: #00C;
        font-weight: bold;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  {if $machines}

    <div><a href="/system/playground/cluster.php">リセット(クラスタ一覧)</a></div>

    {* 結果一覧 *}

    {if $query_machine}
      <h4>
        {if !empty($queryId)}ベクトル比較
        {elseif !empty($lfId)}局所特徴
        {/if}
        ソート元画像
      </h4>
      <div class="cluster">
        <img class="top_image hover lazy" src='imgs/blank.png'
          data-original="{$_conf.media_dir}machine/thumb_{$query_machine.top_img}"
          data-source="{$_conf.media_dir}machine/{$query_machine.top_img}"
          alt="中古{$query_machine.name} {$query_machine.maker} {$query_machine.model}" />
        <noscript><img src="{$_conf.media_dir}machine/thumb_{$query_machine.top_img}" alt="" /></noscript>

        <div class="cluster_title">{$query_machine["id"]} : {$query_machine["name"]}</div>
        <div class="buttons">
          <a href="/system/playground/cluster.php?cid={$clusterId}&qid={$query_machine['id']}">[vector]</a>
          <a href="/system/playground/cluster.php?cid={$clusterId}&lfid={$query_machine['id']}">[lf]</a>
          {if !empty($sorts)}
            <span class="score">{$sorts[$m["id"]]}</span>
          {/if}
        </div>
      </div>
      <br clear="both" />
      <hr />
    {/if}


    {foreach from=$machines item=m key=k}
      {if !empty($query_machine) && $m.id == $query_machine.id}{continue}{/if}
      <div class="cluster">
        <img class="top_image hover lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}"
          data-source="{$_conf.media_dir}machine/{$m.top_img}" alt="中古{$m.name} {$m.maker} {$m.model}" />
        <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="" /></noscript>

        <div class="cluster_title">{$m["id"]} : {$m["name"]}</div>
        <div class="buttons">
          <a href="/system/playground/cluster.php?cid={$clusterId}&qid={$m['id']}">[vector]</a> |
          <a href="/system/playground/cluster.php?cid={$clusterId}&lfid={$m['id']}">[lf]</a>
          {if !empty($sorts)}
            <span class="score">{$sorts[$m["id"]]}</span>
          {/if}
        </div>
      </div>
    {/foreach}
  {else}

    {* クラスタ一覧 *}
    {foreach from=$clusters item=cl key=k}
      <div class="cluster">
        {$m = $cMachineById[$cl.first]}

        <img class="top_image hover lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}machine/thumb_{$m.top_img}"
          data-source="{$_conf.media_dir}machine/{$m.top_img}" alt="中古{$m.name} {$m.maker} {$m.model}" />
        <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="" /></noscript>
        <a href="/system/playground/cluster.php?cid={$k}" class="cluster_title">
          クラスタ{$k} : {$m["name"]} ({$cl.count})
        </a>

      </div>
    {/foreach}
  {/if}
  <br clear="both" />


{/block}