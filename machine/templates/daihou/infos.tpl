{extends file='daihou/layout/layout.tpl'}

{block 'header'}

{literal}
<script type="text/javascript">
$(function() {
});
</script>
<style type="text/css">
.all_infos dt {
  display: inline-block;
  width: 120px;
}

.all_infos dd {
  display: inline-block;
  width: 600px;
}
</style>
{/literal}
{/block}

{block 'main'}
  {if !empty($dInfo)}
    <div class="row infos">
      <div class="col-md-8 order-md-2 p-3">
        <h5 ><i class="fas fa-info-circle"></i>{$dInfo.info_date|date_format:'%Y/%m/%d'} {$dInfo.title}</h5>

        <p>
          {$dInfo.contents|escape|auto_link|nl2br nofilter}
        </p>

      </div>

      <nav class="col-md-4 order-md-1 bd-links p-3" id="bd-docs-nav">
        <h6><i class="fas fa-list-ul"></i>お知らせ一覧</h6>
        <ul class="list-unstyled fw-normal pb-1">
          {$diList}
          {foreach from=$diList item=di key=key name=name}
            <li>
              <dt>{$di.info_date|date_format:'%Y/%m/%d'}</dt>
              <dd><a href="./infos.php?id={$di.id}">{$di.title}</a></dd>
            </li>
          {/foreach}
        </ul>
      </nav>
    {else}
      <nav class="all_infos bd-links p-3" id="bd-docs-nav">
        <h6><i class="fas fa-list-ul"></i>お知らせ一覧</h6>
        <ul class="list-unstyled fw-normal pb-1">
          {$diList}
          {foreach from=$diList item=di key=key name=name}
            <li>
              <dt>{$di.info_date|date_format:'%Y/%m/%d'}</dt>
              <dd><a href="./infos.php?id={$di.id}">{$di.title}</a></dd>
            </li>
          {/foreach}
        </ul>
      </nav>
    {/if}


  </div>


{/block}