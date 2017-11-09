<div class="machine_news">
  <a class="img_link" href='/machine_detail.php?m={$m.id}'
    onclick="ga('send', 'event','toppage', 'news', 'detail_{$baseKey}', 1, true);"
  >
    {if !empty($m.top_img)}
      <img class="top_image hover lazy" src='imgs/blank.png'
        data-original="http://www.zenkiren.net/media/machine/thumb_{$m.top_img}"
        data-source="http://www.zenkiren.net/media/machine/{$m.top_img}"
        alt="中古{$m.name} {$m.maker} {$m.model}" />
      <noscript><img src="http://www.zenkiren.net/media/machine/thumb_{$m.top_img}" alt="" /></noscript>
    {else}
      <img class='top_image noimage' src='./imgs/noimage.png'
        alt="中古{$m.name} {$m.maker} {$m.model}" />
    {/if}
  </a>

  <div class="news_span">
    {$span = time() - strtotime($m.created_at)}
    {if $span / (60*60*24) > 1}{floor($span / (60*60*24))}日前
    {elseif $span / (60*60) >= 1}{floor($span / (60*60))}時間前
    {else}{floor($span / 60)}分前{/if}
  </div>

  <a href='/machine_detail.php?m={$m.id}' class="names"
    onclick="ga('send', 'event','toppage', 'news', 'detail_{$baseKey}', 1, true);"
  >
    {$m.name} {$m.maker} {$m.model} {if !empty($m.year) && $m.year != '-'}{$m.year}年式{/if} : 
    {'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company}
  </a>
</div>
