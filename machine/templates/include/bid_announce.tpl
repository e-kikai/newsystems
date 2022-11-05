<div class="bid_open">
  <dl class="bid_date">
    <dt {if $bidOpen.status == 'bid'} class="now" {/if}>下見期間</dt>
    <dd {if $bidOpen.status == 'bid'} class="now" {/if}>{$bidOpen.preview_start_date|date_format:'%Y/%m/%d'} ～
      {$bidOpen.preview_end_date|date_format:'%m/%d'}</dd><br />

    {if preg_match('/(admin|system)/', $smarty.server.PHP_SELF)}
      <dt {if $bidOpen.status == 'bid'} class="now" {/if}>入札期間</dt>
      <dd {if $bidOpen.status == 'bid'} class="now" {/if}>{$bidOpen.bid_start_date|date_format:'%Y/%m/%d %H:%M'} ～
        {$bidOpen.bid_end_date|date_format:'%m/%d %H:%M'}</dd><br />
      <dt>入札締切(一般向)</dt>
      <dd>{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</dd><br />
    {else}
      <dt>入札締切</dt>
      <dd>{$bidOpen.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</dd><br />
    {/if}
    <dt {if $bidOpen.status == 'carryout'} class="now" {/if}>搬出期間</dt>
    <dd {if $bidOpen.status == 'carryout'} class="now" {/if}>{$bidOpen.carryout_start_date|date_format:'%Y/%m/%d'} ～
      {$bidOpen.carryout_end_date|date_format:'%m/%d'}</dd><br />
  </dl>
</div>

{if !empty($bidOpen.announce_list)}
  <div class="bid_open">
    <h3>お知らせ</h3>
    <p>{$bidOpen.announce_list|escape|auto_link|nl2br nofilter}</p>
  </div>
{/if}

<br style="clear:both;" />