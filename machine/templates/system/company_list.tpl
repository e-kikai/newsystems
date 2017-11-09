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
            _target    : 'company',
            _action    : 'delete',
            company_id : $.trim($(this).val()),
        };
        
        // 送信確認
        var company = $.trim($_parent.find('td.company').text());
        if (!confirm(company + "\nこの会社情報を削除します。よろしいですか。")) { return false; }
        
        $.post('/system/ajax/post.php', data, function(res) {
            if (res != 'success') { alert(res); return false; } // エラーアラート
            
            $_parent.remove(); // 削除完了 : 表示項目削除
        }, 'text');
        
        return false;
    });
    
    //// 代理ログイン処理 ////
    $('button.login').click(function() {
        $_parent = $(this).closest('tr');
        var data = {
            _target    : 'company',
            _action    : 'login',
            company_id : $.trim($(this).val())
        };
        
        // 送信確認
        var company = $.trim($_parent.find('td.company').text());
        if (!confirm(company + "\nこの会社情報で代理ログインします。よろしいですか。")) { return false; }
        
        $.post('/system/ajax/post.php', data, function(res) {
            if (res != 'success') { alert(res); return false; } // エラーアラート
            
            // ログイン完了 : 代理ログインした会社で会員ページヘ移動
            alert(company + "\nで代理ログインしました。\n会員ページに移動します。");
            location.href = '/admin/';
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

<a href="system/company_form.php">新規登録</a> |
<a href="system/company_list.php?output=csv">CSV出力</a>

<table class='list contact'>
  <thead>
    <tr>
      <th class='id'>ID</th>
      <th class="login">代理ログイン</th>
      <th class="rank">ランク</th>
      <th class="company">会社名</th>
      <th class="representative">代表者</th>
      <th class="address">住所</th>
      <th class="tel">TEL・FAX</th>
      <th class="mail">代表メールアドレス</th>
      <th class="website">Web</th>
      <th class="delete">削除</th>
    </tr>
  </thead>
  
  {foreach $companyList as $c}
    {if $c@first || $companyList[$c@key-1]['treenames'] !=  $c.treenames}
      <tr><th id="{$c.treenames}" colspan="10" class="groups">{$c.treenames}</th></tr>
    {/if}
    <tr>
      <td class='id'>{$c.id}</td>

      <td class='login'>
        <button class="login" value="{$c.id}">ログイン</a>
      </td>
      <td class='rank'>
        <span class="rank-{($c.rank)}">{Companies::getRankLabel($c.rank)}</span>
      </td>
      <td class='company'>
        <a href="/system/company_form.php?id={$c.id}">{$c.company}</a>
      </td>
      <td class='representative'>{$c.representative}</td>
      <td class='address'>〒 {$c.zip}<br />{$c.addr1} {$c.addr2} {$c.addr3}</td>
      <td class='tel'>{$c.tel}<br />{$c.fax}</td>
      <td class='mail'>{if !empty($c.mail)}<a href="mailto:{$c.mail}">{$c.mail}</a>{/if}</td>
      <td class='website'>{if !empty($c.website)}<a href="{$c.website}" target="_blank">◯</a>{/if}</td>
      <td class='delete'>
        <button class="delete" value="{$c.id}">削除</a>
      </td>
    </tr>
  {/foreach}
</table>
{/block}
