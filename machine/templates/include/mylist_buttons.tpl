<div class='machine_full'>
  まとめて：
  <button class='contact_full' value='search'>問い合わせする</button>
  
  {if Auth::check('mylist')}
    {if preg_match("/\/mylist.php/", $smarty.server.PHP_SELF)}
      <button class='mylist_delete' value='mylist'>リストから削除する</button>
    {else}
      <button class='mylist_full' value='mylist'>マイリストに追加</button>
    {/if}
  {/if}
  <label>
    <input type='checkbox' id='machine_check_full' name='machine_check_full' value='' /> すべての機械をチェック
  </label>
</div>
