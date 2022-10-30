{extends file='daihou/layout/layout.tpl'}

{block 'header'}

{literal}
<script type="text/javascript">
$(function() {
});
</script>
<style type="text/css">

.images .carousel-inner img {
  display: block;
  height: 100%;
  margin: 0 auto;
}

.imgs {
  margin: 16px 0;
  padding: 8px;
  border: 1px dotted var(--dk-m);
  border-width: 1px 0;
  background: #FFF;
}

.imgs a {
  display: inline-block;
  margin: 4px;
}

.details dt {
  clear: both;
  float: left;
  margin: 0 16px 4px 0;
  width: 80px;
  text-align: right;
}

.details dt::after {
  content: " : ";
}

.details dd {
  float: left;
  margin: 0 16px 0 0;
}

.detail_banner {
  display: block;
  width: 300px;
  margin: 32px auto;
}

.detail_banner img {
  width: 100%;
}

.carousel-base{
    position: relative;
}
.carousel-base:before {
    content: '';
    display: block;
    width: 100%;
    padding-top: 75%;
}

.carousel {
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0;
    left: 0;
    background: #CCC;
}

</style>
{/literal}
{/block}

{block 'main'}
  <h2 class="minititle"><i class="fas fa-cogs"></i>{$pageTitle}</h2>

  <div class="row">
    <div class="images col-12 col-md-8">
      {if empty($machine.top_img)}
        <img class='noimage' src='./imgs/daihou_noimg.png' alt="{$alt}" />
      {else}
        {*
        <div class='top_image'>
          <a class="zoom" href="{$_conf.media_dir}machine/{$machine.top_img}" target="_blank">
            <img class="zoom_img" src="{$_conf.media_dir}machine/{$machine.top_img}" alt="{$alt}" />
          </a>
        </div>
        *}

        <div class="carousel-base">
          <div id="carouselExampleIndicators" class="carousel carousel-dark slide" data-bs-ride="carousel" data-bs-interval="false">
            {*
            <div class="carousel-indicators">
              <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide {$machine.top_img}"></button>

              {foreach $machine.imgs as $key => $i}
                <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="{$key + 1}" aria-label="Slide {$key + 1}"></button>
              {/foreach}
            </div>
            *}

            <div class="carousel-inner">
              <div class="carousel-item active">
                <img src="{$_conf.media_dir}machine/{$machine.top_img}" class="d-block" alt="...">
              </div>
              {foreach $machine.imgs as $key => $i}
                <div class="carousel-item">
                  <img src="{$_conf.media_dir}machine/{$i}" class="d-block" alt="...">
                </div>
              {/foreach}
            </div>
          </div>

          <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
          </button>
          <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
          </button>
        </div>
      {/if}


      <div class="imgs">
        {if !empty($machine.imgs)}
          {if !empty($machine.top_img)}
            {*
            <a class="img" href="{$_conf.media_dir}machine/{$machine.top_img}" target="_blank">
              <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="{$alt}" />
            </a>
            *}

            <a href="#" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide {$machine.top_img}">
              <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="{$alt}" />
            </a>

          {/if}

          {foreach $machine.imgs as $key => $i}
            {*
            <a class="img" href="{$_conf.media_dir}machine/{$i}" target="_blank">
              <img src="{$_conf.media_dir}machine/thumb_{$i}" alt="{$alt}" />
            </a>
            *}

            <a href="#" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="{$key + 1}" class="active" aria-current="true" aria-label="Slide {$i}">
              <img src="{$_conf.media_dir}machine/thumb_{$i}" alt="{$alt}" />
            </a>

          {/foreach}
        {/if}
      </div>

    </div>

    <div class="details col-12 col-md-4">
      <table class="table table-striped caption-top">
        <caption><i class="fas fa-list-ul"></i>機械詳細</caption>
        <tr>
          <th class="col-4">管理番号</th>
          <td class="col-8">{$machine.no}</td>
        </tr>
        <tr>
          <th class="col-4">機械名</th>
          <td class="col-8">{$machine.name}</td>
        </tr>
        <tr>
          <th class="col-4">メーカー</th>
          <td class="col-8">{$machine.maker}</td>
        </tr>
        <tr>
          <th class="col-4">型式</th>
          <td class="col-8">{$machine.model}</td>
        </tr>
        <tr>
          <th class="col-4" >年式</th>
          <td class="col-8">{$machine.year}</td>
        </tr>
        <tr>
          <td class="col-12" colspan="2">
            <div style="font-weight:bold;">仕様</div>
            {$machine.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">' nofilter}
          </td>
        </tr>
      </table>

      <a class="footer_contact_link" href="./contact.php?m={$machine.id}">
        <img src="./imgs/daihou_mc_02.png" />
      </a>
    </div>

  </div>

{/block}