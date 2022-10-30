{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <table class='list contact'>
    <thead>
      <tr>
        <th class='id'>ID</th>
        <th class="name">お名前</th>
        <th class="mail">連絡先</th>
        <th class="contents">内容</th>
        <th class="created_at">登録日</th>
      </tr>
    </thead>

    {foreach $contactList as $c}
      <tr class='{cycle values='even, odd'}'>
        <td class='id'>{$c.id}</td>
        <td class='name'>{$c.user_company}<br />{$c.user_name}</td>
        <td class='mail'>
          {mailto address=$c.mail encode="javascript"}<br />
          TEL : {$c.tel}<br />
          FAX : {$c.fax}<br />
          {$c.addr1}
          {if !empty($c.return_time)}<br />{$c.return_time|escape|nl2br nofilter}{/if}
        </td>
        <td class='contents'>{$c.message|escape|nl2br nofilter}</td>
        <td class='created_at'>{$c.created_at|date_format:'%Y/%m/%d %H:%M'}</td>
      </tr>
    {/foreach}
  </table>
{/block}