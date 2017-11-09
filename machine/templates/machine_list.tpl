{extends file='include/layout.tpl'}

{block 'header'}
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}machines.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}ekikaiMylist.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />
{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

{*** 期間絞り込み ***}
{if !empty($period)}
<form method="GET" id="period_form">
<div class='period_area'>
  <li>
    <span class="area_label">期間</span>：
  </li>
  
  <li>
    <label><input type="radio" name="pe" value="1" {if !empty($period) && $period==1}checked="checked"{/if} />1日前</label>
  </li>
  <li>
    <label><input type="radio" name="pe" value="2" {if !empty($period) && $period==2}checked="checked"{/if} />2日前</label>
  </li>
  <li>
    <label><input type="radio" name="pe" value="3" {if !empty($period) && $period==3}checked="checked"{/if} />3日前</label>
  </li>
  <li>
    <label><input type="radio" name="pe" value="7" {if !empty($period) && $period==7}checked="checked"{/if} />1週間</label>
  </li>
  <li>
    <label><input type="radio" name="pe" value="14" {if !empty($period) && $period==14}checked="checked"{/if} />2週間</label>
  </li>
  <li>
    <label><input type="radio" name="pe" value="31" {if !empty($period) && $period==31}checked="checked"{/if} />1ヶ月</label>
  </li>
  
  <input type="radio" name="pe" value="input" {if !empty($period) && $period=='input'}checked="checked"{/if} />
  <input type="text" name="input_date" id="input_date" value="{$input_date}" placeholder="日付指定" />
</div>
</form>
{/if}
 
{if $machineList}
  {*** 表示切り替えタブ／並び替え ***}
  {include file="include/order.tpl"}

  {*** テンプレート表示切り替え ***}
  {include file="include/machine_`$tp`.tpl"}
{/if}
{/block}

