{extends file='include/layout.tpl'}

{block name='header'}
{*
<meta name="robots" content="noindex, nofollow" />
*}

<link href="{$_conf.libjs_uri}/css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="{$_conf.libjs_uri}/login.js?1"></script>

{literal}
<script type="text/JavaScript">
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
<div class="help_contents">

<table class="tender_schedule">
  <tr><th>Web入札会</th><th>下見期間</th><th>入札締切・開票日</th></tr>

  {foreach $bidOpenList as $bo}
    <tr itemscope itemtype="http://data-vocabulary.org/Event">
      <td itemprop="summary">
        <a itemprop="url" href="bid_lp.php?o={$bo.id}" target="_blank">{$bo.title}</a>
      </td>
      <td>
        <time itemprop="startDate" datetime="{$bo.preview_start_date|date_format:"%Y-%m-%d"}+09:00">
          {$bo.preview_start_date|date_format:"%Y/%m/%d"}
        </time>～
        <time itemprop="endDate" datetime="{$bo.preview_end_date|date_format:"%Y-%m-%d"}+09:00">
          {$bo.preview_end_date|date_format:"%Y/%m/%d"}
        </time>
      </td>
      <td>
        <div itemprop="location">
          {$bo.user_bid_date|date_format:"%Y/%m/%d"}
          ({B::strtoweek($bo.user_bid_date)})
          {$bo.user_bid_date|date_format:"%H:%M"}
          <span style="display:none;"> 入札締切・開票</span>
        </div>
        <div itemprop="description" style="display:none;">全機連が主催する、マシンライフ{$bo.title}</div>
      </td>
    </tr>
  {/foreach}
</table>
<div class="right">
  <a class="form_button" href="../imgs/2022schedule.pdf" target="_blank"><img src="./imgs/2014schedule.png" alt="2022年Web入札会日程(スケジュール)"></a>
</div>

{*
<h2>全機連会員 入札会開催日程</h2>
<table class="tender_schedule">
  <tr>
    <th>タイトル</th>
    <th>主催者</th>
    <th>入札会場</th>
    <th>下見期間</th>
    <th>入札締切</th>
  </tr>

  {foreach $bidinfoList as $bi}
    <tr itemscope itemtype="http://data-vocabulary.org/Event">
      <td itemprop="summary">
        <a itemprop="url" href="{$bi.uri}" target="_blank"
        onClick="ga('send', 'event', 'banner_schedule', 'bid', 'bidinfo_{$b.id}', 1, true);">
          {$bi.bid_name}
          <img itemprop="photo" src="./media/banner/{$bi.banner_file}" alt="" />
        </a>
      </td>
      <td>
        {$bi.organizer}
      </td>
      <td>
        <time itemprop="startDate" datetime="{$bi.preview_start_date|date_format:"%Y-%m-%d"}+09:00">
          {$bi.preview_start_date|date_format:"%Y/%m/%d"}
        </time>～
        <time itemprop="endDate" datetime="{$bi.preview_end_date|date_format:"%Y-%m-%d"}+09:00">
          {$bi.preview_end_date|date_format:"%Y/%m/%d"}
        </time>
      </td>
      <td itemprop="location">
       {$bi.place|escape|nl2br nofilter}
      </td>

      <td>
        <div itemprop="description">
          {$bi.bid_date|date_format:"%Y/%m/%d"}
          ({B::strtoweek($bi.bid_date)})
          {$bi.bid_date|date_format:"%H:%M"}
          <span style="display:none;"> 入札締切・開票</span>
        </div>
      </td>
    </tr>
  {/foreach}
</table>
*}

</div>

{/block}
