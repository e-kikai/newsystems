{**
 * ジャンル一覧選択用 
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2012/02/17
 *}
<style>
</style>
<div class='genre_menu' id="genre_menu">
  {*
  <form action='/search.php' method='get'>
  *}
    <div class='genre_submit'>
      中古機械ジャンル検索 : 以下からお探しの中古機械ジャンルを選択してください
      {*
      <button type="submit" class="submit">検索する</button>
      *}
    </div>
  
    <table class='genre_list'>
      <tr>
        <td class='genre_list_cell'>
          {if !empty($largeGenreList) && is_array($largeGenreList)}
            {foreach $largeGenreList as $l}
              {*
              {if !($l@first) && !($l@key % ceil($l@total / 5))}  
              *}
              {if !($l@first) && in_array($l@key, array(13, 27, 41, 53))}                  
                </td>
                <td class="genre_list_cell">
              {/if}
              {*
              <label class="genre" title="{$l.large_genre} ({$l.count})">
                <input type="checkbox" name="l[]" value="{$l.id}"
                  {if in_array($l.id, $largeGenreId)}checked="checked"{/if} />
                <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
              </label>
              *}
              <a href="search.php?l={$l.id}" class="genre xl_{$l.xl_genre_id}">
                <span class="check_label">{$l.large_genre}</span><span class="count">({$l.count})</span>
              </a><br />
            {/foreach}
          {/if}
        </td>
      </tr>
    </table>
  {*
  </form>
  *}
</div>
