<div class="col" style="">
  <div class="machine card">
    <a href="./detail.php?m={$machine.id}">
      <div class="machine_img">
        {if !empty($machine.top_img)}
          <img src="{$_conf.media_dir}machine/{$machine.top_img}" class="card-img-top" alt="" />
        {else}
          <img class='noimage' src='./imgs/daihou_noimg.png' class="card-img-top" alt="" />
        {/if}
      </div>
      <div class="card-body">
        <p class="card-text">
        <i class="bi bi-app-indicator"></i>

          {if !empty($machine.no)}<span class="no_label">管理番号</span><span class="no">{$machine.no}</span><br />{/if}
          {if !empty($machine.name)}<span class="name"><i class="fas fa-play"></i>{$machine.name}</span>{/if}

          {if !empty($machine.maker)}<span class="model">{$machine.maker}</span>{/if}
          {if !empty($machine.model)}<span class="model">{$machine.model}</span>{/if}

          {if !empty($machine.year)}<span class="model">{$machine.year}年式</span>{/if}
        </p>
      </div>
    </a>
  </div>
</div>