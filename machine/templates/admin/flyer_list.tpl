{extends file='include/layout.tpl'}

{block 'header'}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
//// 変数の設定 ////
{literal}
$(function() {
});
</script>
<style type="text/css">
table.list .count {
  width: 60px;
}

table.list td.count {
  text-align: right;

}

</style>
{/literal}
{/block}

{block 'main'}

<a class="new" href="admin/flyer_form.php">新規チラシ作成</a>

{if empty($flyerList)}
  <div class="error_mes">まだチラシ履歴はありません</div>
{/if}

{*** ページャ ***}
{include file="include/pager.tpl"}

{foreach $flyerList as $f}
  {if $f@first}
  <table class="machines list">
    <tr>
      <th class="name">タイトル</th>
      <th class="">ステータス</th>

      <th class="count">送信数</th>
      <th class="count">開封回数</th>
      <th class="count">開封人数</th>
      <th class="count">開封率</th>

      <th class="count">クリック回数</th>
      <th class="count">クリック人数</th>
      <th class="count">クリック率</th>

      <th class="count">不達数</th>

      <th class="">作成日時</th>
    </tr>
  {/if}
  <tr>

    {if !empty($reportList[$f.campaign])}
      {$c = $campaignList[$f.campaign]}
      {$r = $reportList[$f.campaign]}

      {if $r.emails_sent > 0}
        <td class="name"><a href="admin/flyer_design.php?id={$f.id}">{$f.title}</a></td>
        <td class="">{$r.send_time|date_format:'%Y/%m/%d %H:%M'}<br />送信済</td>
        <td class="count">{$r.emails_sent}人</td>
        <td class="count">{$r.opens.opens_total}回</td>
        <td class="count">{$r.opens.unique_opens}人</td>
        <td class="count">{round($r.opens.open_rate * 100)}%</td>
        <td class="count">{$r.clicks.clicks_total}回</td>
        <td class="count">{$r.clicks.unique_clicks}人</td>
        <td class="count">{round($r.clicks.click_rate * 100)}%</td>
        <td class="count">{$r.bounces.hard_bounces + $r.bounces.soft_bounces + $r.bounces.syntax_errors}人</td>
      {else}
        <td class="name"><a href="admin/flyer_menu.php?id={$f.id}">{$f.title}</a></td>
        {if $c.status == "schedule"}
          <td class="">{$r.send_time|date_format:'%Y/%m/%d %H:%M'}<br />に送信開始予定</td>
        {else}
          <td class="">作成中</td>
        {/if}
        <td class="" colspan="8"></td>
      {/if}
    {else}
      <td class="name"><a href="admin/flyer_menu.php?id={$f.id}">{$f.title}</a></td>
      <td class="">作成中</td>
      <td class="" colspan="8"></td>
    {/if}
    <td class="">{$f.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
  </tr>

  {if $f@last}
  </table>
  {/if}
{/foreach}

{*** ページャ ***}
{include file="include/pager.tpl"}

{/block}
