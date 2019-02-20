{extends file='include/layout.tpl'}

{block 'header'}

<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {

});
</script>
<style type="text/css">
table.form td textarea {
    width: 492px;
    height: 9.6em;
    line-height: 1.2;
}

.info_goal {
  display: inline-block;
  font-weight: bold;
}

.info_goal.cell {
  color: #C00;
}

.info_goal.buy {
  color: #00C;
}

.imgs {
  margin: 8px auto;
}
</style>
{/literal}
{/block}

{block 'main'}

<form class="info" method="POST" action="">
<table class="info form">
  <tr class="target">
    <th>売り買い</th>
    <td>
      <div class="info_goal {$urikai.goal}">{if $urikai.goal == "cell"}売りたし{else}買いたし{/if}</div>
    </td>
  </tr>

  <tr class="id">
    <th>No.</th>
    <td>{$urikai.id}</td>
  </tr>

  <tr class="">
    <th>依頼主</th>
    <td>{$company.company}</td>
  </tr>

  <tr class="info_date">
    <th>書きこみ日時</th>
    <td>{$urikai.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
  </tr>

  <tr class="contents">
    <th>内容</th>
    <td>{$urikai.contents|escape|auto_link|nl2br nofilter}</td>
  </tr>

  <tr class="">
    <th>問い合わせ</th>
    <td>
      {if empty($urikai.end_date)}
        <a href="/contact.php?c={$urikai.company_id}">→この{if $urikai.goal == "cell"}売りたし{else}買いたし{/if}について問合せ</a>
      {else}
        この{if $urikai.goal == "cell"}売りたし{else}買いたし{/if}は解決済みです({$urikai.end_date|date_format:'%Y/%m/%d %H:%M'})
      {/if}
    </td>
  </tr>
</table>

<div class="imgs">
</div>


</form>
{/block}
