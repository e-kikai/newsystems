{**
 * ページャ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/01/07
 *}
{if !empty($pager)}
  <div class='pager'>
    <span class="pcount">検索結果 {$pager->totalItemCount}件</span>
    {if $pager->pageCount > 1}
      <span class="list">
        {if $pager->current != $pager->first}
          <a class="jump" href="{$cUri}&page={$pager->first}">&lt;&lt;先頭</a>
          <a class="jump" href="{$cUri}&page={$pager->previous}">&lt;前へ</a>
        {/if}
        {foreach $pager->pagesInRange as $p}
          <a class="num{if $p == $pager->current} current{/if} p_{$p}" href="{$cUri}&page={$p}">{$p}</a>
        {/foreach}
        {if $pager->current != $pager->last}
          <a class="jump" href="{$cUri}&page={$pager->next}">次へ&gt;</a>
          <a class="jump" href="{$cUri}&page={$pager->last}">最終&gt;&gt;</a>
        {/if}
      </span>
    {/if}
  </div>
{/if}