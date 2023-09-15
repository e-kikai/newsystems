<div class="same_machine">

  <a href="machine_detail.php?m={$machine.id}&r={$r}" target="_blank"
    {* onClick="_gaq.push(['_trackEvent', 'log_detail', 'nitamono', '{$machine.id}', 1, true]);" *}
    onClick="ga('send', 'event', 'log_detail', '{$ga_key}', '{$machine.id}', 1, true);">
    {if !empty($machine.top_img)}
      <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="" />
    {else}
      <img class='noimage' src='./imgs/noimage.png' alt="" />
    {/if}
    <div class="names">
      {if !empty($machine.name)} <div class="name">{$machine.name}</div>{/if}
      {if !empty($machine.maker)}<div class="name">{$machine.maker}</div>{/if}
      {if !empty($machine.model)}<div class="name">{$machine.model}</div>{/if}
      {if !empty($machine.year)}<div class="name">{$machine.year}年式</div>{/if}
      {if !empty($machine.addr1)}<div class="name">{$machine.addr1}</div>{/if}
      {if !empty($machine.company)}<div class="name">{$machine.company|regex_replace:'/(株式|有限|合.)会社/u':''}</div>{/if}
    </div>
  </a>
</div>