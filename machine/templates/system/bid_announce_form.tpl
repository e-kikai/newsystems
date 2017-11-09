{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
    //// 数値のみに自動整形 ////
    $('input.number').change(function() {
        var number = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9.]/g, '');
        $(this).val(number ? parseInt(number) : '');
    });
    
    //// 処理 ////
    $('button.submit').click(function() {
        var data = {
            'id': $.trim($('input.bid_open_id').val()),
            'announce_list': $.trim($('textarea.announce_list').val()),
            'sashizu_flag': $.trim($('input.sashizu_flag:checked').val()),
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
        if (!confirm('入力した入札会お知らせを保存します。よろしいですか。')) { return false; }
        
        $('button.submit').attr('disabled', 'disabled').text('保存処理中、終了までそのままお待ち下さい');
        
        $.post('/system/ajax/bid.php', {
            'target': 'system',
            'action': 'setAnnounce',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                $('button.submit').removeAttr('disabled').text('保存');
                alert(res);
                return false;
            }
            
            // 登録完了
            alert('保存が完了しました');
            location.href = '/system/';
            return false;
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
table.form td textarea.fee_calc {
  width: 150px;
  height: 120px;
}

table.form td textarea.announce {
  height: 8.6em;
}
</style>
{/literal}
{/block}

{block 'main'}
<input type="hidden" class="bid_open_id" value="{$bidOpenId}" />

<div class="form_comment">
  <span class="alert">※</span>
  　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
</div>

<table class="info form">
  <tr class="title">
    <th>タイトル</th>
    <td>{$bidOpen.title}</td>
  </tr>
  
  <tr class="announce_list">
    <th>商品リストお知らせ</th>
    <td>
      <textarea name="list_announce" class="announce announce_list">{$bidOpen.announce_list}</textarea>
    </td>
  </tr>
  
  
  <tr class="announce_list">
    <th>引取指図書フラグ</th>
    <td>
      {html_radios name='sashizu_flag' class='sashizu_flag' options=['' => '不可', '1' => '出力可']
       selected=$bidOpen.sashizu_flag separator=' '}
    </td>
  </tr>
</table>

<button type="button" name="submit" class="submit">保存</button>
{/block}
