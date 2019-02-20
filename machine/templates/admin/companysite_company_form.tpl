{extends file='include/layout.tpl'}

{block 'header'}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.upload.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/jsrender.js"></script>

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.validate.min.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/messages_ja.js"></script>

<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(function() {
    //// フォームバリデータ初期化 ////
    $_form = $('#form');
    $_form.validate();

    //// 処理 ////
    $('button.submit').click(function() {
        ///// バリデーション ////
        if (!$_form.valid()) { return false; }

        if (!confirm('変更を保存します。よろしいですか。')) { return false; }

        //// 入力データを取得 ////////
        var data = $_form.find('[name]').serializeArray();
        
        $('button.submit').attr('disabled', 'disabled');
        
        $.post('/admin/ajax/companysite.php', data, function(res) {
            $('button.submit').removeAttr('disabled');

            // 処理失敗 : エラーアラート
            if (res != 'success') { alert(res); return false; }

            // 登録完了 : 会員メニューに戻る
            location.href = '/admin/';
        }, 'text');
        
        return false;
    });
    
    //// 取り扱いメーカー追加処理 ////
    var company_maker_blank = $('tr.company_maker.blank').clone();
    $(document).on('change', 'input[name="company_configs[makers_name][]"]:last', function() {
        if ($.trim($(this).val()) != '') {
            $('table.makers').append(company_maker_blank.clone());
        }
    });
    
    //// 沿革追加処理 ////
    var company_history_blank = $('tr.company_history.blank').clone();
    $(document).on('change', 'input[name="company_configs[histories_contents][]"]:last', function() {
        if ($.trim($(this).val()) != '') {
            $('table.histories').append(company_history_blank.clone());
        }
    });
    
    //// ファイルが選択されたら、自動的にアップロード開始 ////
    $('input.file').change(function() {
        $_self = $(this);
        
        $_self.after('<span class="dd_wait">ファイルをアップロードしています</span>').hide();

        $_self.upload('/admin/ajax/upload.php', {
            'target'     : 'system',
            'action'     : 'set',
            'data[type]' : $_self.attr('accept'),
        }, function(res) {
            $_self.val('').show();
            $('.dd_wait').remove();
            try {
                data = $.parseJSON(res); // $.parseJSON() で変換
            } catch(e) { alert(res); return false; }
        
            // アップロード完了 : アップロードした画像プレビュ要素を追加
            $.each(data, function(i, val) {
                if ($_self.data('target') == "top_img") {
                    $('.top_img .upload_img').html($("#top_img_tmpl").render(val));
                }
            });
        }, 'text');

        return false;
    });
});
</script>
<script id="top_img_tmpl" type="text/x-jsrender">
<div class="top_img">
  <a href="/media/tmp/{{>filename}}" target="_blank"><img src="/media/tmp/{{>filename}}" /></a>
  <input name="company_configs[top_img]" type="hidden" value="{{>filename}}" />
</div>
</script>
<style type="text/css">
table.form td input[type=text] {
  width: 500px;
}

table.form td textarea {
  height: 80px;
}

table.makers {
  width: 500px;
}

table.makers td,
table.histories td {
  background: #FFF;
}

table.makers td input[type=text],
table.histories td input[type=text] {
  width: 220px;
}

.upload_img div.top_img {
  width: 500px;
  max-height: 190px;
  overflow: hidden;
  background: #000;
}

.upload_img img {
  width: 500px;
  opacity: 0.7;
  filter: alpha(opacity = 70);
}
</style>
{/literal}
{/block}

{block 'main'}

<form id="form">
<input type="hidden" name="_action" value="set" />
<h2>共通情報</h2>
<table class="member form">
  <tr class="company">
    <th>会社名</th>
    <td>{$company.company}</td>
  </tr>
  
  <tr class="company_kana">
    <th>自社サイトURL</th>
    <td>
      <a href="{$_conf.site_uri}s/{$site.subdomain}/" target=="_blank">{$_conf.site_uri}s/{$site.subdomain}/</a>
    </td>
  </tr>
  
  <tr>
    <th>デザインテンプレート</th>
    <td>
      {html_options name="template" values=Companysites::getTempalteList() output=Companysites::getTempalteList() selected=$site.template}
    </td>
  </tr>
  
  <tr>
    <th>ヘッドコピー<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="company_configs[headcopy]"
        value="{if !empty($site.company_configs.headcopy)}{$site.company_configs.headcopy}{else}中古機械のスペシャリスト {$site.company} {$site.addr1}{/if}"
        placeholder="すべてのページの上部に表示されます" required />
    </td>
  </tr>
</table>

<h2>トップページ</h2>
<table class="member form">
  <tr>
    <th>トップ中央画像</th>
    <td class="top_img">
      画像ファイル<br />
      <span class="alert">※</span> 登録できる画像ファイル形式はJPEGのみです<br />
      <span class="alert">※</span> 画像は自動的にページに合わせて横長(はみ出た下部分はカット)になります<br />
      また、文章を重ねるために、画像の明るさが自動的に調整されます。
      <input type="file" class="file" name="f[]" data-target="top_img" accept="image/jpeg" />
      <div class="upload_img">
        {if !empty($site.company_configs.top_img)}
          <div class="top_img">
            <a href='{$_conf.media_dir}companysite/{$site.company_configs.top_img}' target="_blank">
              <img src='{$_conf.media_dir}companysite/{$site.company_configs.top_img}' />
            </a>
            <input type="hidden" name="company_configs[top_img]" value="{$site.company_configs.top_img}" />
          </div>
        {/if}
      </div>
      
      タイトル<br />
      <input type="text" name="company_configs[top_img_title]" value="{$site.company_configs.top_img_title}"
        placeholder="トップ中央画像上の文章のタイトル" /><br />
      本文<br />
      <textarea name="company_configs[top_img_contents]" 
        placeholder="トップ中央画像上の文章の本文">{$site.company_configs.top_img_contents}</textarea>
    </td>
  </tr>
  <tr>
    <th>トップ下概要</th>
    <td>
      タイトル<br />
      <input type="text" name="company_configs[top_summary_title]"
        value="{$site.company_configs.top_summary_title}"
        placeholder="トップ下・概要のタイトル" /><br />
      本文<br />
      <textarea name="company_configs[top_summary_contents]" 
        placeholder="トップ下・概要の本文">{$site.company_configs.top_summary_contents}</textarea>
    </td>
  </tr>
</table>

<h2>会社情報ページ</h2>
<table class="member form">
  <tr>
    <th>会社情報上部</th>
    <td>
      タイトル<br />
      <input type="text" name="company_configs[company_top_title]"
        value="{$site.company_configs.company_top_title}"
        placeholder="会社情報上部のタイトル" /><br />
      本文<br />
      <textarea name="company_configs[company_top_contents]" 
        placeholder="会社情報上部の本文">{$site.company_configs.company_top_contents}</textarea>
    </td>
  </tr>
  <tr class="">
    <th>取り扱いメーカー</th>
    <td>
      <table class="makers">
        <tr>
          <th>メーカー名</th>
          <th>サイトURL</th>
        </tr>
        
        {if !empty($site.company_configs.makers_name)}
          {foreach $site.company_configs.makers_name as $m}
            {if !empty($m)}
              <tr class="company_maker">
                <td><input type="text" name="company_configs[makers_name][]" value="{$m}" placeholder="メーカー名" /></td>
                <td><input type="text" name="company_configs[makers_url][]" 
                  value="{$site.company_configs.makers_url[$m@key]}" placeholder="リンクURL(なければ空白)" /></td>
              </tr>
            {/if}
          {/foreach}
        {/if}
        
        <tr class="company_maker blank">
          <td><input type="text" name="company_configs[makers_name][]" placeholder="メーカー名" /></td>
          <td><input type="text" name="company_configs[makers_url][]" placeholder="リンクURL(なければ空白)" /></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr class="">
    <th>沿革</th>
    <td>
      <table class="histories">
        <tr>
          <th>年月</th>
          <th>内容</th>
        </tr>
        
        {if !empty($site.company_configs.histories_contents)}
          {foreach $site.company_configs.histories_contents as $h}
            {if !empty($h)}
             <tr class="company_history">
                <td><input type="text" name="company_configs[histories_date][]"
                  value="{$site.company_configs.histories_date[$h@key]}" placeholder="年月" /></td>
                <td><input type="text" name="company_configs[histories_contents][]" value="{$h}"  placeholder="内容" /></td>
              </tr>
            {/if}
          {/foreach}
        {/if}
        
        <tr class="company_history blank">
          <td><input type="text" name="company_configs[histories_date][]" placeholder="年月" /></td>
          <td><input type="text" name="company_configs[histories_contents][]" placeholder="内容" /></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<button type="submit" class="submit" value="member">変更を保存</button>
{/block}

