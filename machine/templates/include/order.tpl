<div class='machine_tab'>
  <a class="list_tab selected" onclick="_gaq.push(['_trackEvent', 'list', 'tab', 'list', 1, true]);">リストで表示</a>
  {*
  <a class="img_tab" onclick="_gaq.push(['_trackEvent', 'list', 'tab', 'img', 1, true]);">写真で表示</a>
  <a class="map_tab" onclick="_gaq.push(['_trackEvent', 'list', 'tab', 'map', 1, true]);">地図で表示</a>
  *}
  {if !preg_match("/\&?c=[0-9]+/", $smarty.server.REQUEST_URI)}
    <a class="company_tab" onclick="_gaq.push(['_trackEvent', 'list', 'tab', 'company', 1, true]);">会社別一覧</a>
  {/if}
</div>

<div class='machine_num'>
  <span class="count_no">{$pager->totalItemCount}</span>件登録されています
</div>
