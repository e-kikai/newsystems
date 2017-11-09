{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
<link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.upload.js"></script>

<script type="text/JavaScript">
{literal}
$(function() {
    //// 処理 ////
    $('button.submit').click(function() {
        var error = '';
        $('input[required]').each(function() {
            if ($(this).val() == '') {
                error = '必須項目が入力されていません';
                return false;
            }
        });
    });
    
    $('button.submit').click(function() {
        var data = {
            'message': $.trim($('textarea#message').val()),
            'subject': $.trim($('input#subject').val()),
            'target': $.trim($('select.val option:selected').closest('optgroup').attr('value')),
            'val': $.trim($('select.val').val()),
            'val_label': $.trim($('select.val option:selected').closest('optgroup').attr('label') + ' ' + $('select.val option:selected').text()),
        }

        //// 入力のチェック ////
        var e = '';
        if (data.subject == '') { e += "タイトルが入力されていません\n"; }
        if (data.message == '') { e += "内容が入力されていません\n"; }

        //// エラー表示 ////
        if (e != '') { alert(e); return false; }

        // 送信確認
        if (!confirm('メールを一括送信します。よろしいですか。')) { return false; }
        
        $('button.submit').attr('disabled', 'disabled').text('メール送信処理中、終了までそのままお待ち下さい');
        
        $('input.file').upload('/system/ajax/mail.php', {
            'target': 'system',
            'action': 'send',
            'data[message]'  : data['message'],
            'data[subject]'  : data['subject'],
            'data[target]'   : data['target'],
            'data[val]'      : data['val'],
            'data[val_label]' : data['val_label'],
        }, function(res) {
            if (res != 'success') {
                $('button.submit').removeAttr('disabled').text('メールを一括送信する');
                alert(res);
                return false;
            }
            
            // お問い合せ完了
            alert('送信が完了しました');
            location.href = '/system/';
            return false;
        }, 'text');
        
        return false;
    });
    
    //// 送信数の取得 ////
    $('select.val').change(function() {
        var data = {
            'target': $.trim($('select.val option:selected').closest('optgroup').attr('value')),
            'val': $.trim($('select.val').val()),
        }
    
        $.get('/system/ajax/mail_get.php', {
            'target': 'system',
            'action': 'count',
            'data'  : data
        }, function(res) {
            if (parseInt(res)) {
                $('.group_count').text(res + ' 件の送信先にメールが送信されます');
                $('button.submit').removeAttr('disabled');
            } else if (res == '0') {
                $('.group_count').text('送信対象がありません(メールアドレスが0件です');
                $('button.submit').attr('disabled', 'disabled');
            } else {
                $('.group_count').text(res);
                $('button.submit').attr('disabled', 'disabled');
            }
            return false;
        });
    }).change();
    
    //// ファイル選択のクリア ////
    $('button.clear_file').click(function() {
        $('input.file').replaceWith($('input.file').clone());
        
        return false;
    });
});
</script>
<style type="text/css">
#message {
  height: 400px;
}

button.clear_file {
  width: auto;
}
</style>
{/literal}
{/block}

{block 'main'}
<form class="info" method="POST" action="/system/mail_conf.php" enctype="multipart/form-data">
<table class="info form">
  {*
  <tr class="id">
    <th>ID</th>
    <td>
      {if empty($id)}新規{else}{$id}<input type="hidden" name="id" id="id" value="{$id}" />{/if}
    </td>
  </tr>

  <tr class="info_date">
    <th>日付<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="info_date" id="info_date" value="{$info.info_date|date_format:'%Y/%m/%d'}"
        placeholder="日付" required />
    </td>
  </tr>
    
  <tr class="target">
    <th>対象<span class="required">(必須)</span></th>
    <td>
      {html_options name=target id=target options=$targetList selected=$info.target}
    </td>
  </tr>
  *}
    
  <tr class="subject">
    <th>タイトル<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="subject" id="subject" required />
    </td>
  </tr>
    
  <tr>
    <th>内容<span class="required">(必須)</span></th>
    <td>
    [[会社名]] 様<br /><br />
    
      <textarea name="message" id="message" required></textarea>
    
    <br /><br />
    全機連事務局
    </td>
  </tr>
  
  <tr class="contents">
    <th>添付ファイル</th>
    <td>
      <input type="file" name="file" class="file" />
      <button class="clear_file">リセット</button>
    </td>
  </tr>
  
  <tr class="group_id">
    <th>送信対象</th>
    <td>
      <select name="val" class="val">
        <optgroup label="全機連メンバー" value="group_id">
        <option value="">すべての全機連メンバー</option>
        {foreach $groupList as $g}
          <option value="{$g.id}" {if $g.id==$mail.group_id} selected{/if}>
            {$g.treenames}
          </option>
        {/foreach}

        <optgroup label="全機連メンバー(ランク)" value="rankeq">
          {html_options options=Companies::getRankRatio()}
        </optgroup>

        <optgroup label="お問い合せ" value="contact">
          <option value="[[Web入札会 参加申し込み]]">Web入札会 参加申し込み</option>
          <option value="ALL">すべてのお問い合せ</option>
        </optgroup>
        <optgroup label="マイリスト登録ユーザ" value="preuser">
          <option value="ALL">すべてのマイリスト登録ユーザ</option>
        </optgroup>
        <optgroup label="ワーキンググループ" value="workinggroup">
          <option value="ALL">すべてのメンバー</option>
        </optgroup>
        <optgroup label="その他" value="other">
          <option value="test">送信テスト</option>
        </optgroup>
      </select>
      
      <div class="group_count">送信数</div>
    </td>
  </tr>
</table>

<button type="button" name="submit" class="submit" value="member">メールを一括送信する</button>

</form>
{/block}
