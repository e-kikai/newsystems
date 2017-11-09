{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
    //// 処理 ////
    $('button.submit').click(function() {
        var data = {
            'id': $.trim($('input.bid_open_id').val()),
        };

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
        if (!confirm('リストNo付加の処理と、リストPDF生成処理を行います。よろしいですか。')) { return false; }
        
        $('button.submit').attr('disabled', 'disabled');
        
        $.post('/system/ajax/bid.php', {
            'target': 'system',
            'action': 'makeList',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                $('button.submit').removeAttr('disabled');
                alert(res);
                return false;
            }
            
            // 処理完了
            alert('処理が完了しました');
            location.href = '/system/';
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
<input type="hidden" class="bid_open_id" value="{$bidOpenId}" />

<table class="info form">
  <tr class="title">
    <th>タイトル</th>
    <td>{$bidOpen.title}</td>
  </tr>
  
  <tr class="announce_list">
    <th>商品リストPDF</th>
    <td>
      {if !empty($bidOpen.list_pdf)}
        <a href="media/pdf/{$bidOpen.list_pdf}" target="_blank">{$bidOpen.list_pdf}</a>
      {else}
        出品番号,PDF未作成
      {/if}
    </td>
  </tr>
</table>

<button type="button" name="submit" class="submit">出品番号付加、リストPDF生成</button>
{/block}
