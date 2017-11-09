{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.host}{$_conf.js_dir}ekikaiMylist.js"></script>
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}mylist_handler.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// サムネイル画像の遅延読み込み（Lazyload） ////
    $('img.lazy').css('display', 'block').lazyload({
        effect: "fadeIn",
        threshold : 200
    });
});
</script>
<style type="text/css">
.machine_list button.mylist {
  display : none;
}
</style>
{/literal}
{/block}

{block 'main'}
{*** マイリスト切り替え ***}
{*
{if $smarty.server.PHP_SELF == '/mylist_company.php'}
  <div class='machine_tab'>
    <a href='mylist.php'>在庫機械</a>
    <a href='mylist_genres.php'>検索条件</a>
    <a href='mylist_member.php' class="selected">会社</a>
  </div>
{/if}
*}

{if $companyList}
  {include file="include/machine_company.tpl"}
{else}
  <div class="message">会社情報がありません</div>
{/if}
{/block}
