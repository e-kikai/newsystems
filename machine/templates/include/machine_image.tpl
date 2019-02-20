<link href="{$_conf.site_uri}{$_conf.css_dir}mycarousel.css" rel="stylesheet" type="text/css" />
<script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
<link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/javascript">
$(function() {
    //// 画像カルーセル ////
    /*
    $('.imagelist .imgs').filter(function() {
        return $(this).find('li').length > 3;
    }).jcarousel({
        wrap : null,
        auto : 0,
        visible : 3,
        scroll : 3,
        animation : 600
    });
    */
    $('.imagelist .data').filter(function() {
        return $(this).find('.imgs li').length > 3;
    }).each(function() {
        $_i = $(this).find('.imgs');
        $(this).find('.status').append('<div class="scrollRight"></div><div class="scrollLeft"></div>');
        
        $_i.css('width', $(this).find('li').length * 275);
    });
    
    $('.scrollRight').click(function() {
        $_i = $(this).parent().parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() + $_i.width()}, 1000, 'easeOutCubic');
    });
    
    $('.scrollLeft').click(function() {
        $_i = $(this).parent().parent().find('.image_carousel');
        $_i.animate({'scrollLeft': $_i.scrollLeft() - $_i.width()}, 1000, 'easeOutCubic');
    });
    
    
    $(".zoom").each(function() {
        var $_self = $(this);
        var detailUri = $_self.attr('href');
        var imgUri = $_self.find('img.lazy').data('original');
        
        $_self.click(function() {
            location.href = detailUri;
            return false;
        });       

        if (imgUri) {
            $_self
                .attr('href', imgUri)
                .jqzoom({
                    zoomType: 'standard',  
                    lens:true,  
                    preloadImages: true,  
                    alwaysOn:false,  
                    zoomWidth: 480,  
                    zoomHeight: 360,  
                    xOffset:64,  
                    yOffset: 0,  
                    position:'right',
                    title: false
           });
        }
    })

});
</script>
<style type="text/css">
.imgs li {
  position : relative;
}

.image_carousel img.triangle {
  width: 64px;
  height: 64px;
  
  position: absolute;
  right: 0px;
  bottom: 0px;
  z-index: 1000;
}

.image_carousel {
  overflow-x: auto;
  overflow-y: hidden;
}

.machine_list.imagelist .machine .imgs {
  overflow: visible;
}

.jqzoom {
  width: 256px;
}

.scrollRight,
.scrollLeft {
  position: absolute;
  top: 108px;
  width: 30px;
  height: 30px;

  z-index: 700;
  cursor: pointer;
}

.scrollLeft {
  left: 8px;
  background: url('./img/imgs_prev.png') no-repeat;
}

.scrollRight {
  right: -16px;
  background: url('./img/img_next.png') no-repeat;
}
</style>
{/literal}
<div class='machine_list imagelist'>
  <table class='machines'>
    {foreach from=$machineList item=m name='ml'}
    <tbody class="machine machine_{$m.id}">
    <tr>
      <td class='checkbox'>
        <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
      </td>
      <td class='data'>
        <div class='status'>
          <div class='hidden no'>{$smarty.foreach.ml.index|string_format:"%04d"}</div>
          <div class='hidden genre_id'>{$m.genre_id}</div>
          <div class='hidden model2'>{'/[^A-Z0-9]/'|preg_replace:'':($m.model|mb_convert_kana:'KVrn'|strtoupper)}</div>
          <div class='hidden created_at'>{$m.created_at|strtotime}</div>
          <div class="hidden location_address">{'/(都|道|府|県)(.*)$/'|preg_replace:"$1":$m.location_address}</div>
          
          {if $m.created_at|strtotime > '-7day'|strtotime}<div class='new'>新着</div>{/if}
          <div class='name'>{$m.name}</div>
          <div class='maker'>{$m.maker}</div>
          <div class='model'>{$m.model}</div>
          <div class='year'>{$m.year}</div>
          {*
          <span class="capacity">{$m.capacity}</span><span class="capacity_unit">{$m.capacity_unit}</span>
          *}
           
        </div>

        <div class='image_carousel'>

        <ul class='imgs jcarousel-skin-tango'>
          <li>
            <a class='zoom' href='/machine_detail.php?m={$m.id}'>
              {if !empty($m.top_img)}
                <img class="top_image lazy" src='img/blank.png' data-original="{$_conf.media_dir}machine/{$m.top_img}" alt="" />
                <noscript><img src="{$_conf.media_dir}machine/{$m.top_img}" alt="" /></noscript>
              {else}
                <img class='top_image noimage' src='./img/noimage.jpg' />
              {/if}
            </a>
          </li>
          
          {if !empty($m.imgs)}
            {foreach $m.imgs as $i}
              <li>
                <a class='zoom' href='/machine_detail.php?m={$m.id}'>
                  <img class="lazy" src='img/blank.png' data-original="{$_conf.media_dir}machine/{$i}" alt="" />
                  <noscript><img src="{$_conf.media_dir}machine/{$i}" alt="" /></noscript>
                  {if $i@last && $i@total > 1}
                    <img  class='triangle' src='./img/triangle2.gif' />
                  {/if}
                </a>
              </li>
            {/foreach}
          {/if}
        </ul>
        </div>
        
        <div class='company_info'>
          
          <div class='company'>
            <a href='/company_detail.php?c={$m.company_id}'>{$m.company}</a>
          </div>
          <div class='tel'>TEL : {$m.tel}</div>
          <div class='fax'>FAX : {$m.fax}</div>
          {*
          <a class='detail' href='/machine_detail.php?m={$m.id}><img src='./img/detail.png' /></a>
          *}
          <a class='contact' href='/contact.php?m={$m.id}'>問い合わせする</a>
          <button class='mylist' value='{$m.id}'>マイリスト追加</button>
        </div>
        
      </td>
    </tr>
    
    <tr class='separator'><td colspan='2'></td></tr>
    </tbody>
    
    {/foreach}
  </table>
</div>
