{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.upload.js"></script>
<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

{*** JQueryバリデータ ***}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.validate.min.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/messages_ja.js"></script>

{literal}
<script type="text/JavaScript">
$(function() {
    //// フォームバリデータ初期化 ////
    $_form = $('#form');
    $_form.validate();

    //// 送信処理 ////
    $('button.submit').click(function() {
        if (!$_form.valid()) { return false; }

        if (!confirm('変更を保存します。よろしいですか。')) { return false; }

        //// 入力データを取得 ////////
        var data = $_form.find('[name]').serializeArray();

        $('button.submit').attr('disabled', 'disabled');
        
        $.post('/system/ajax/post.php', data, function(res) {
            $('button.submit').removeAttr('disabled');

            if (res != 'success') { alert(res); return false; } // エラー表示
            
            // 保存完了 : 自社サイト一覧に戻る
            location.href = '/system/genre_list.php?l=' + $('input[name=large_genre_id]').val();
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
.spec_labels td input {
  width: 100px;
}
</style>
{/literal}
{/block}

{block 'main'}
<form id="form">
<input type="hidden" name="_target" value="genre" />
<input type="hidden" name="_action" value="set" />
<input type="hidden" name="id" value="{$genre.id}" />
<input type="hidden" name="large_genre_id" value="{$genre.large_genre_id}" />

<table class="member form">
  <tr class="xl_genre">
    <th>中ジャンル名</th>
    <td>{$genre.xl_genre} > {$genre.large_genre}</td>
  </tr>
  <tr class="genre">
    <th>ジャンル名<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="genre" value="{$genre.genre}"
        placeholder="ジャンル名" required />
    </td>
  </tr>

  <tr class="genre">
    <th>ジャンル名(カナ)</th>
    <td>
      <input type="text" name="genre_kana" value="{$genre.genre_kana}"
        placeholder="ジャンル名(カナ)" />
    </td>
  </tr>

  <tr class="capacity_label">
    <th>能力項目名</th>
    <td>
      <input type="text" name="capacity_label" value="{$genre.capacity_label}" placeholder="能力項目名" />
    </td>
  </tr>

  <tr class="capacity_unit">
    <th>能力単位</th>
    <td>
      <input type="text" name="capacity_unit" value="{$genre.capacity_unit}" placeholder="能力単位" />
    </td>
  </tr>

{*
  <tr class="spec_labels">
    <th>その他能力項目</th>
    <td>
      {foreach $genre.spec_labels as $s}
        <div>
          <input type="text" name="spec_labels[{$s@key}][label]" value="{$s.label}" placeholder="項目名" />
          <input type="text" name="spec_labels[{$s@key}][unit]" value="{$s.unit}" placeholder="単位" />
          {html_options name="spec_labels[{$s@key}][unit]" options=$others selected=$s.type}
        </div>
      {/foreach}
      <textarea name="spec_labels">{$genre.spec_labels_json}</textarea>
    </td>
  </tr>
*}

  <tr class="naming">
    <th>命名規則</th>
    <td>
      <input type="text" name="naming" value="{$genre.naming}" placeholder="機械名自動入力用" />
    </td>
  </tr>

  <tr class="order_no">
    <th>並び順<span class="required">(必須)</span></th>
    <td>
      <input type="number" class="digits num" name="order_no" value="{$genre.order_no}" 
        placeholder="並び順(整数)" required />
    </td>
  </tr>
  </table>
</form>
<button type="button" class="submit">情報を保存</button>
{/block}
