{include file="include/html_header.tpl"}

<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}ekikaiMylist.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />
{literal}
  <script language="JavaScript" type="text/javascript">
    $(function() {
      //// マイリストから削除する（検索条件：単一） ////
      $('button.mylist_delete_genres').click(function() {
        var genres = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (genres.length) {
          mylist.del(genres, 'genres');
        } else {
          mylist.showAlert('マイリストから削除したい検索条件をチェックしてください。');
        }
      });

      // すべての機械をチェック
      $('#machine_check_full').change(function() {
        $('input.machine_check').attr('checked', this.checked);
      });
    });
  </script>
  <style type="text/css">
    .machine_list button.mylist {
      display: none;
    }

    .mylist_genres .checkbox {
      width: 30px;
      text-align: center;
    }

    .mylist_genres .count {
      width: 100px;
    }

    .mylist_genres .count strong {
      font-size: 16px;
      font-weight: bold;
      color: #FF2819;
      margin-right: 4px;
    }

    .mylist_genres td.count {
      height: 40px;
      text-align: right;
    }

    .mylist_genres .buttons {
      width: 138px;
    }

    .mylist_genres td.buttons {
      text-align: center;
      padding: 0;
    }
  </style>
{/literal}

{*** ヘッダ ***}
{include file="include/header.tpl"}

{*** マイリスト切り替え ***}
<div class='machine_tab'>
  <a href='mylist.php'>在庫機械</a>
  <a href='mylist_genres.php' class="selected">検索条件</a>
  <a href='mylist_member.php'>会社</a>
</div>

{*** 検索条件（暫定） ***}
{foreach $genresList as $g}
  {if $g@first}
    <div class='machine_full'>
      まとめて：
      {*** メールマガジン登録ウィンドウを開く ***}
      {include file="include/open_mailmagazine.tpl"}
      <button type='button' class='input_mailmagazine'>この条件でメールを受け取る</button>
      <button class='mylist_delete_genres' value='mylist_genres'>リストから削除する</button>
      <input type='checkbox' id='machine_check_full' name='machine_check_full' value='' /><label
        for='machine_check_full'>すべての検索条件をチェック</label>
    </div>

    <table class="list mylist_genres">
      <tr>
        <th class="checkbox"></th>
        <th class="genre">検索条件</th>
        <th class='count'>登録件数</th>
        <th class='buttons' class='reset'></th>
      </tr>
    {/if}

    <tr class="genres">
      <td class='checkbox'>
        <input type='checkbox' class='machine_check' name='genre_check' value='{$g.genre_ids}' />
      </td>
      <td class="genre">
        <a href='machine_list.php?{foreach explode(',', $g.genre_ids) as $id}&l[]={$id}{/foreach}'>{$g.label}</a>
      </td>
      <td class="count"><strong>{$g.count}</strong>件</td>
      <td class='buttons'>
        <button type='button' class='input_mailmagazine' value="">メールを受け取る</button>
      </td>
    </tr>

    {if $g@last}
    </table>
  {/if}
{foreachelse}
  <div class="message">マイリストに登録された検索条件はありません</div>
{/foreach}

{*** フッタ ***}
{include file="include/footer.tpl"}