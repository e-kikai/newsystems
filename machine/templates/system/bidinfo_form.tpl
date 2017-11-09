{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.upload.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// datepicker ////
    $('input.date').datepicker({
        showAnim    : 'fadeIn',
        prevText    : '',
        nextText    : '',
        dateFormat  : 'yy/mm/dd',
        altFormat   : 'yy/mm/dd',
        changeMonth : true, 
        appendText  : '',
        maxDate     : '',
        minDate     : ''
    });

    //// 時間コンボボックス ////
    var timeArray = [];
    for (i=13; i<24; i++) {
        timeArray.push(i + ":00");
        timeArray.push(i + ":30");
    }
    for (i=0; i<13; i++) {
        timeArray.push(i + ":00");
        timeArray.push(i + ":30");
    }
    $('input.time').autocomplete({
        source :  function(req, res) { res(timeArray);},
        minLength : 0
    }).click(function() {
        $(this).autocomplete('search');
    });

    //// 送信処理 ////
    $('button.submit').click(function() {
        var data = {
            'target'          : 'system',
            'action'          : 'set',
            'data[id]'        : $.trim($('input.id').val()),
            'data[bid_name]'  : $.trim($('input.bid_name').val()),
            'data[uri]'       : $.trim($('input.uri').val()),
            'data[organizer]' : $.trim($('input.organizer').val()),
            'data[place]'     : $.trim($('textarea.place').val()),
            'data[bid_date]'  : $.trim($('input.bid_date').val()) + ' ' + $.trim($('input.bid_time').val()),
            'data[preview_start_date]' : $.trim($('input.preview_start_date').val()),
            'data[preview_end_date]'   : $.trim($('input.preview_end_date').val()),
        }
        
        //// 画像ファイルの削除 ////
        if ($('#file_delete').prop('checked')) { alert('true'); data['data[banner_file]'] = ''; }
        
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
        if (!confirm('情報を保存します。よろしいですか。')) { return false; }
        
        // $('button.submit').attr('disabled', 'disabled');

        //// 送信処理(ファイルアップロード含) ////
        $('input.banner_file').upload('/system/ajax/bidinfo.php', data, function(res) {
            if (res != 'success') {
                // $('button.submit').removeAttr('disabled');
                alert(res);
                return false;
            }
            
            // 保存完了
            alert('情報を保存が完了しました');
            location.href = '/system/bidinfo_list.php';
            return false;
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
input.date {
  width: 90px;
}

input.time {
  width: 60px;
}

table.form textarea.place {
  height: 5.8em;
}
</style>
{/literal}
{/block}

{block 'main'}
<input type="hidden" name="id" class="id" value="{$bidinfo.id}" />

<table class="member form">
  <tr class="bid_name">
    <th>入札会名<span class="required">(必須)</span></th>
    <td><input type="text" name="bid_name" class="bid_name" value="{$bidinfo.bid_name}"
      placeholder="入札会名" required /></td>
  </tr>

  <tr class="website">
    <th>リンクURL<span class="required">(必須)</span></th>
    <td>
      <input type="url" class="uri" value="{$bidinfo.uri}" placeholder="http://www.～～～～.com/" required />
    </td>
  </tr>


  <tr class="organizer">
    <th>主催者名<span class="required">(必須)</span></th>
    <td><input type="text" name="organizer" class="organizer" value="{$bidinfo.organizer}"
      placeholder="主催者名" required /></td>
  </tr>
  <tr class="representative">
    <th>入札会場<span class="required">(必須)</span></th>
    <td>
      <textarea name="place" class="place" placeholder="入札会場" required>{$bidinfo.place}</textarea>
    </td>
  </tr>
  <tr class="bid">
    <th>下見期間<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="preview_start_date" class="preview_start_date date"
        value="{$bidinfo.preview_start_date|date_format:'%Y/%m/%d'}" required />
      ～
      <input type="text" name="preview_end_date" class="preview_end_date date"
        value="{$bidinfo.preview_end_date|date_format:'%Y/%m/%d'}" required />
    </td>
  </tr>
  
  <tr class="bid">
    <th>入札日時<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="bid_date" class="bid_date date" value="{$bidinfo.bid_date|date_format:'%Y/%m/%d'}" required />
      <input type="text" name="bid_time" class="bid_time time" value="{$bidinfo.bid_date|date_format:'%H:%M'}" required />
    </td>
  </tr>

  <tr class="banner">
    <th>バナー画像</th>
    <td>
      バナー画像がない場合は、新着メールのみに表示されるようになります。<br />
      {if !empty($bidinfo.banner_file)}
        <div class="img">
          <img src='{$_conf.media_dir}banner/{$bidinfo.banner_file}' />
          <input type="checkbox" id="file_delete" value="1" /><label for="file_delete">ファイルを削除する</label>
        </div>
        ファイル更新
      {/if}
      <input type="file" name="banner_file" class="banner_file" accept="image/*" />
    </td>
  </tr>
  </table>
<button type="button" name="submit" class="submit">情報を保存</button>
{/block}
