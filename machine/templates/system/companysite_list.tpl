{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 削除処理 ////
    $('button.delete').click(function() {
        $_parent = $(this).closest('tr');
        var data = {
            '_target'        : 'companysite',
            '_action'        : 'delete',
            'companysite_id' : $.trim($(this).val()),
        };
        
        // 送信確認
        var company = $.trim($_parent.find('td.company').text());
        if (!confirm(company + "\nこの情報を削除します。よろしいですか。")) { return false; }
        
        $.post('/system/ajax/post.php', data, function(res) {
            if (res != 'success') { alert(res); return false; } // エラー表示
            
            $_parent.remove(); // 削除完了 : 表示項目削除
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}

<a href="system/companysite_form.php">新規登録</a>
<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="rank">ランク</th>
      <th class="company">会社名</th>
      <th class="subdomain">サイトURL</th>
      <th class="closed">公開</th>
      <th class="delete">削除</th>
    </tr>
  </thead>
  
  {foreach $companysiteList as $s}
    <tr>
      <td class='id'>{$s.companysite_id}</td>
      <td class='rank'>
        <span class="rank-{($s.rank)}">{Companies::getRankLabel($s.rank)}</span>
      </td>
      <td class='company'>
        <a href="/system/companysite_form.php?id={$s.companysite_id}">{$s.company}</a>
      </td>
      <td class='subdomain'><a href="/s/{$s.subdomain}/" target="_blank">{$_conf.site_uri}s/{$s.subdomain}/</a></td>
      <td class='closed'>
        {if $s.closed > 0}閉鎖中{else}公開中{/if}
      </td>
      <td class='delete'>
        <button class="delete" value="{$s.companysite_id}">削除</a>
      </td>
    </tr>
  {/foreach}
</table>
{/block}
