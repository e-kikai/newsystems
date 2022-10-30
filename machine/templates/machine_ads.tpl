<!DOCTYPE html>
<html>
<head>
  <link href="{$_conf.libjs_uri}/css/html5reset.css" rel="stylesheet" type="text/css" />
  <link href="/css/machine_ads.css?i" rel="stylesheet" type="text/css" />

  <meta name="robots" content="noindex" />
</head>
<body class="ads_body">

  <div>
    {foreach $machineList as $m}
      <div class="thumbnail product-pannel">
        {if !empty($bidOpen)}
          <a target="_blank" href="/bid_detail.php?m={$m.id}&r={$res}_ads">
            {if !empty($m.top_img)}
              <img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}"  />
            {else}
              <img class='top_image noimage' src='./imgs/noimage.png'
                alt="{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
            {/if}
            <div class="bid_list_no">出品番号 {$m.list_no}</div>
            <div class="bid_name">{$m.maker} {$m.name} {$m.model}{if !empty($m.year) && $m.year != '-'} {$m.year}年式{/if}</div>
            <div class="price">
              <span class="min_price_label">最低入札金額</span>
              <span class="min_price">{$m.min_price|number_format}円</span>
            </div>
          </a>
        {else}
          <a target="_blank" href="/machine_detail.php?m={$m.id}&r={$res}_ads">
            {if !empty($m.top_img)}
              <img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}"  />
            {else}
              <img class='top_image noimage' src='./imgs/noimage.png'
                alt="{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
            {/if}

              <div class="maker">{$m.maker}</div>
              <div class="name">{$m.name}</div>
              <div class="model">{$m.model}{if !empty($m.year) && $m.year != '-'} {$m.year}年式{/if}</div>
            {/if}
          </a>
      </div>
    {/foreach}
    <br clear="both"; />
  </div>

  <a class="ads_logo" target="_blank" href="/">
    <img alt="マシンライフ" src="/imgs/logo_machinelife.png" />
    <div class="site">by zenkiren.net</div>

    {if empty($bidOpen)}
      <div class="desc">中古機械のスペシャリスト、全機連会員の中古機械在庫情報</div>
    {/if}
  </a>

  {if !empty($bidOpen)}
    <a href="/bid_door.php?o={$bidOpen.id}" class="bid_title" target="_blank">{$bidOpen.title} 開催中!!</a>
  {/if}
</body>
</html>
