<div class="same_machine bid">
  <a href="bid_detail.php?m={$machine.id}&{$label}=1"
    onClick="ga('send', 'event', 'log_bid', '{$label}', '{$machine.id}', 1, true);">
    {if !empty($machine.top_img)}
      <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="" />
    {else}
      <img class='noimage' src='./imgs/noimage.png' alt="" />
    {/if}
    <div class="names">
      {if !empty($machine.maker)}<div class="name">{$machine.maker}</div>{/if}
      {if !empty($machine.model)}<div class="name">{$machine.model}</div>{/if}
      {if !empty($machine.year)}<div class="name">{$machine.year}年式</div>{/if}
      {if !empty($machine.addr1)}<div class="name">{$machine.addr1}</div>{/if}
    </div>
    <div class="min_price">{$machine.min_price|number_format}円</div>
  </a>
</div>