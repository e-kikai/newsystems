{extends file='daihou/layout/layout.tpl'}


{block 'header'}

{literal}
<script type="text/javascript">
$(function() {
});
</script>
<style type="text/css">

</style>
{/literal}
{/block}

{block 'main'}
  <div class="top_main">
    <img class="top_mainimg" src="./imgs/daihou_top_01.jpeg" />
    <div class="catchcopy">
      <div>お客様のもの創りを</div>
      <div class="sub_catch">サポートする機械商社</div>
    </div>
  </div>

  <p class="top_message">
    <span class="d-inline-block">遊休機械・廃棄予定機械の買取り</span>
    <span class="d-inline-block">入替え機械や新規設備の対応しております。</span>
    <span class="d-inline-block">新品中古機械売買もしておりますので</span>
    <span class="d-inline-block">お探しの機械、お気軽にお問い合わせください。</span>
  </p>

  <h2 class="minititle"><i class="">NEW!</i>新着情報</h2>
  <div class="top_new_area row row-cols-2 row-cols-sm-3 row-cols-md-4">
    {foreach $newMachineList as $ma}
      {include "daihou/layout/machine_panel.tpl" machine=$ma}
    {/foreach}

    <br clear="both" />
  </div>

  <h2 class="minititle"><i class="fas fa-info-circle"></i>お知らせ</h2>
  <dl class="info row">
    {foreach from=$diList item=di key=key name=name}
        <dt class="col-md-3">{$di.info_date|date_format:'%Y/%m/%d'}</dt>
        <dd class="col-md-9"><a href="./infos.php?id={$di.id}">{$di.title}</a></dd>
    {/foreach}

    <div class="text-end col-12">
      <a href="./infos.php">→ <i class="fas fa-info-circle"></i>過去のお知らせはこちら</a>
    </div>
  </dl>


{/block}