{**
 * メールマガジン登録ウィンドウ表示
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 *}
{literal}
<script type="text/JavaScript">
$(function() {
    //// 再検索の表示 ////
    $('button.genre_open').click(function() {
        $('.genre_list_window').dialog({
          show: "fade",
          hide: "fade",
          closeText: '閉じる',
          title: '条件を追加・変更する',
          width: 980,
          resizable: false,
          modal: true,
        });
    });
});
</script>
{/literal}

{*** ジャンル一覧選択用 ***}
<div class="genre_list_window" style="display:none;">
{include file="include/genre_list_check.tpl"}
</div>
