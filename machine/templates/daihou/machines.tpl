{extends file='daihou/layout/layout.tpl'}


{block 'header'}

{literal}
<script type="text/javascript">
$(function() {
});
</script>
<style type="text/css">


</style>
{/literal}
{/block}

{block 'main'}
  <h2 class="minititle"><i class="fas fa-cogs"></i>在庫検索</h2>

  <div class="filters">
    <div class="d-none d-lg-block">
      <h5><i class="fas fa-search"></i>ジャンルで検索</h5>
      <div class='filter_area genre_area'>
        {foreach $genreList as $gekey => $ge}
            <a href="./machines.php?g={$ge.id}">
            {$ge.genre|mb_strimwidth :0:18:"…"}</span><span class="count">({$ge.count})
            </a>
        {/foreach}
      </div>

      <h5><i class="fas fa-search"></i>メーカーで検索</h5>
      <div class='filter_area maker_area'>
        {foreach $makerList as $makey => $ma}
          {if $ma.count && !empty($ma.maker)}
          {* <a href="./machines.php?ma={if $ma.makers}{$ma.makers}{else}{$ma.maker}{/if}"> *}
          <a href="./machines.php?ma={$ma.maker}">
            {$ma.maker|mb_strimwidth :0:18:"…"}</span><span class="count">({$ma.count})
            </a>
          {/if}
        {/foreach}
      </div>
    </div>

    <div class="col-4 d-md-none ">
      <div class="btn-group">
        <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="fas fa-search"></i>ジャンルで検索
        </button>
        <ul class="dropdown-menu">
          {foreach $genreList as $gekey => $ge}
            <li>
              <a class="dropdown-item" href="./machines.php?g={$ge.id}">
                {$ge.genre}<span class="count">({$ge.count})</span>
              </a>
            </li>
          {/foreach}
        </ul>
      </div>

      <div class="btn-group">
        <button type="button" class="btn btn-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="fas fa-search"></i>メーカーで検索
        </button>
        <ul class="dropdown-menu">
          {foreach $makerList as $makey => $ma}
            <li>
              <a class="dropdown-item" href="./machines.php?ma={$ma.maker}">
                {$ma.maker}<span class="count">({$ma.count})</span>
              </a>
            </li>
          {/foreach}
        </ul>
      </div>
    </div>
    {*
    <a class="filter_all" href="./machines.php">検索を解除(すべての商品)</a>
    *}
  </div>

  <div class="top_new_area row row-cols-2 row-cols-sm-3 row-cols-md-4">
    {foreach $machineList as $ma}
      {include "daihou/layout/machine_panel.tpl" machine=$ma}
      {*
      <div class="machine">
        <a href="./detail.php?m={$ma.id}">
          <div class="machine_img">
            {if !empty($ma.top_img)}
              <img src="{$_conf.media_dir}machine/{$ma.top_img}" alt="" />
            {else}
              <img class='noimage' src='./imgs/noimage.png' alt="" />
            {/if}
          </div>
          <div class="names">
            {if !empty($ma.no)}<div class="no">No. {$ma.no}</div>{/if}
            {if !empty($ma.name)}<div class="name">{$ma.name}</div>{/if}
            {if !empty($ma.maker)}<div class="name">{$ma.maker}</div>{/if}
            {if !empty($ma.model)}<div class="name">{$ma.model}</div>{/if}

            {if !empty($ma.year)}<div class="name">{$ma.year}年式</div>{/if}
          </div>
        </a>
      </div>
      *}
    {/foreach}

    <br clear="both" />
  </div>
{/block}