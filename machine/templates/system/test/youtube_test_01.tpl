{extends file='include/layout.tpl'}

{block 'header'}
<meta name="description" content="全機連中古機械情報の{$pageTitle}です" />
<meta name="keywords" content="中古機械,used_machine,全機連,{$pageTitle}" />

<!-- Google Maps APL ver 3 -->
<script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jsrender.js"></script>

<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}search.js"></script>
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}mylist_handler.js"></script>
<script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}ekikaiMylist.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />
{literal}
<script type="text/javascript">
$(function() {
    // $('#sort_area label').button();
    // $('#sort_area').buttonset();
    
    $('a.all_clear').button();
    
    $('#bid_area label').button();
    $('#bid_area').buttonset();
    
    $('.movie_area .movie_link').hover(function() {
        $(this).find('.name_area').animate({
            height: '163px',
        }, 300);
    },function() {
        $(this).find('.name_area').animate({
            height: '38px',
        }, 300);
    });
});
</script>
<style type="text/css">
.movie_area .movie_link {
  float: left;
  position: relative;
  width: 304px;
  height: 171px;
  margin: 0 12px 12px 0;
}

.movie_area .movie_link .movie_icon {
  position: absolute;
  bottom: 46px;
  left: 6px;
}

.movie_area .movie_link .movie_img {
  position: absolute;
  width: 304px;
  height: 171px;
  top: 0;
  left: 0;
}

.movie_area .movie_link .name_area {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 38px;
  padding: 8px 6px 0 6px;
  width: 290px;
  color: #FFF;
  background: rgba(10, 10, 10, 0.6);
  background: -webkit-gradient(linear, left top, left bottom, from(rgba(90, 90, 90, 0)), to(rgba(10, 10, 10, 0.9)) );
  background: -moz-linear-gradient(-90deg, rgba(10, 10, 10, 0), rgba(10, 10, 10, 0.9));
  background: -o-linear-gradient(-90deg, rgba(10, 10, 10, 0), rgba(10, 10, 10, 0.9));
  background: linear-gradient(to bottom, rgba(10, 10, 10, 0), rgba(10, 10, 10, 0.9));
  overflow: hidden;
}

.movie_area .movie_link .name {
  display: inline-block;
  margin: 0 2px;
  font-weight: bold;
}

.movie_area .movie_link .spec {
  margin-top: 16px;
}

.movie_area .movie_link:hover .name_area {
  background: rgba(10, 10, 10, 0.6);
}

.movie_area .movie_link:hover .movie_img {
  opacity: 1;
  -moz-opacity: 1;
  filter: alpha(opacity=100);
  -ms-filter: "alpha(opacity=100)";
}

.movie_area .movie_link:hover .movie_icon {
  display: none;
}
</style>
{/literal}
{/block}

{block 'main'}
{if $machineList}
<div class="movie_area">
{foreach $machineList as $m}
  {*** youtube ***}
  {if !empty($m.youtube) && preg_match("/http:\/\/youtu.be\/(.+)/", $m.youtube, $res)}
    {*
    <a href="javascript:void(0)" data-youtubeid="{$res[1]}" class="movie" title="クリックで動画再生します">
    *}
    <a href="machine_detail.php?m={$m.id}"  class="movie_link" >

      <img class="movie_img" src="http://img.youtube.com/vi/{$res[1]}/mqdefault.jpg" alt="" />
      <div class="name_area">
        <div class="name">{$m.name}</div>
        {if !empty($m.maker)}<div class="name">{$m.maker}</div>{/if}
        {if !empty($m.model)}<div class="name">{$m.model}</div>{/if}<br />
        {if !empty($m.year)}<div class="name">{$m.year}年式</div>{/if}
        {if !empty($m.addr1)}<div class="name">{$m.addr1}</div>{/if}
        {if !empty($m.company)}<div class="name">{$m.company|regex_replace:'/(株式|有限|合.)会社/u':''}</div>{/if}
        {if !empty($m.no)}<div class="name">({$m.no})</div>{/if}
        <div class="spec">{$m.spec}</div>
      </div>
      {*
      <img class="movie_icon" src="imgs/youtube_icon_48_02.png" />
      *}
    </a>
  {/if}
{/foreach}
<br class="clear" />
</div>
{/if}
{/block}
