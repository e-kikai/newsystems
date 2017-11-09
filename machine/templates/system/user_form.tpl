{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// 送信処理 ////
    $('button.submit').click(function() {
        var data = {
            'id': $.trim($('input.id').val()),
            'user_name': $.trim($('input.user_name').val()),
            'company_id': $.trim($('select.company_id').val()),
            'role': $.trim($('select.role').val()),
            'account': $.trim($('input.account').val()),
            'passwd': $.trim($('input.passwd').val()),
        }
        
        //// 入力のチェック ////
        var e = '';
        $('input[required]').each(function() {
            if ($(this).val() == '') {
                e += "必須項目が入力されていません\n\n";
                return false;
            }
        });
        
        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('入力したユーザ情報を保存します。よろしいですか。')) { return false; }
        
        $('button.submit').attr('disabled', 'disabled').text('保存処理中、終了までそのままお待ち下さい');
        
        $.post('/system/ajax/user.php', {
            'target': 'system',
            'action': 'set',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                $('button.submit').removeAttr('disabled').text('ユーザ情報を保存');
                alert(res);
                return false;
            }
            
            // 保存完了
            alert('ユーザ情報を保存が完了しました');
            location.href = '/system/user_list.php';
            return false;
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
<div class="form_comment">
  <span class="alert">※</span>　<span class="required">(必須)</span>の項目は必須入力項目です。
</div>

<input type="hidden" name="id" class="id" value="{$user.id}" />

<table class="member form">
  <tr class="company">
    <th>ユーザ名<span class="required">(必須)</span></th>
    <td><input type="text" name="user_name" class="user_name" value="{$user.user_name}"
      placeholder="ユーザ名" required /></td>
  </tr>
  
  <tr class="company_kana">
    <th>会社ID</th>
    <td>
      <select class="company_id" name="company_id">
        <option value="">会社IDなし</option>
        {foreach $companyList as $key => $c}
          {if $c@first}
            <optgroup label="{$c.treenames}">
          {elseif $companyList[$key-1]['treenames'] !=  $c.treenames}
            </optgroup>
            <optgroup label="{$c.treenames}">
          {/if}
          <option value="{$c.id}" {if $c.id == $user.company_id} selected="selected"{/if}>
            {'/(株式|有限|合.)会社/'|preg_replace:'':$c.company}
          </option>
          {if $c@last}
            </optgroup>
          {/if}
        {/foreach}
      </select>
    </td>
  </tr>
  <tr class="representative">
    <th>権限<span class="required">(必須)</span></th>
    <td>
      {html_options selected=$user.role class='role' name='role'
         options=['guest' => 'guest : 権限なし', 'user' => 'user : 一般ユーザ' , 'catalog' => 'catalog : 電子カタログのみユーザ', 'member' => 'member : 全機連会員'] 
      }
    </td>
  </tr>
  
  <tr class="company">
    <th>アカウント<span class="required">(必須)</span></th>
    <td><input type="text" name="account" class="account" value="{$user.account}"
      placeholder="ユーザ名" required /></td>
  </tr>
  
  <tr class="company">
  {if empty($user.id)}
    <th>パスワード<span class="required">(必須)</span></th>
    <td><input type="text" name="passwd" class="passwd" value=""
      placeholder="パスワード" required /></td>
  {else}
    <th>パスワード変更</th>
    <td><input type="text" name="passwd" class="passwd" placeholder="パスワード変更する場合のみ入力" /></td>
  {/if}
  </tr>
</table>
<button type="button" name="submit" class="submit" value="member">ユーザ情報を保存</button>
{/block}
