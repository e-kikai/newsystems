{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
  $('form.machine').submit(function() {
      return confirm('送信を開始します。よろしいでしょうか\n\n※ 一度送信開始したメールは、キャンセルすることができません。\nご注意ください。');
  });
});
</script>
<style type="text/css">
  .flyer_menu a {
    display: block;
    font-size: 17px;
    margin: 16px 16px;
  }

  p.worning {
    font-size: 16px;
    color: #C00;
    margin: 16px 0;
  }

  .schedule_error {
    color: #C00;
  }
</style>
{/literal}
{/block}

{block 'main'}
  <p>
    メール送信を開始する場合は、「メール送信」をクリックしてください
  </p>
  <p class="worning">
    ※ 一度送信開始したメールは、キャンセルすることができません。ご注意ください。
  </p>

  <form class="machine" method="post" action="/admin/flyer_conf_do.php">
    <input type="hidden" name="id" class="id" value="{$flyer.id}" />
    <table class="machine form">
      <tr class="name">
        <th>送信数</th>
        <td>{$campaign.recipients.recipient_count} 件</td>
      </tr>

      <tr class="name">
        <th>送信開始日時</th>
        <td>
          {if empty($flyer.send_date)}
            今すぐ送信開始します
          {else}
            {$flyer.send_date|date_format:'%Y/%m/%d %H:%M'}
            {if $smarty.now >= $flyer.send_date|strtotime}
              <div class="schedule_error">
                すでに送信開始日時を過ぎています。<br />
                <a href="/admin/flyer_form.php?id={$flyer.id}">送信内容修正</a>で再設定を行ってください。
              </div>
            {/if}
          {/if}
        </td>
      </tr>
    </table>
    {if empty($flyer.send_date)}
      <button type="submit" name="submit" class="submit" value="member">メール送信を開始</button>
    {elseif $smarty.now < $flyer.send_date|strtotime}
      <button type="submit" name="submit" class="submit" value="member">配信日時を設定する</button>
    {/if}
  </form>

{/block}
