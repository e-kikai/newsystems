{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

{*** JQueryバリデータ ***}
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.validate.min.js"></script>
<script type="text/javascript" src="{$_conf.libjs_uri}/messages_ja.js"></script>

<!-- Google Maps APL ver 3 -->
<script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>
{literal}
<script type="text/JavaScript">
$(function() {
    //// フォームバリデータ初期化 ////
    $_form = $('#form');
    $_form.validate();

    //// 送信処理 ////
    $('button.submit').click(function() {
        ///// バリデーション ////
        if (!$_form.valid()) { return false; }

        if (!confirm('変更を保存します。よろしいですか。')) { return false; }

        //// 入力データを取得 ////////
        var data = $_form.find('[name]').serializeArray();

        $('button.submit').attr('disabled', 'disabled');
        
        $.post('/system/ajax/post.php', data, function(res) {
            $('button.submit').removeAttr('disabled');

            if (res != 'success') { alert(res); return false; } // エラー表示
            
            // 保存完了 : 自社サイト一覧に戻る
            location.href = '/system/company_list.php';
        }, 'text');
        
        return false;
    });

    //// 支店・営業所情報select表示切り替え ////
    $('[name=rank]').change(function() {
        if ($(this).val() == '201') {
            $('select[name=parent_company_id').show().removeAttr('disabled');
            $('input[type=hidden][name=parent_company_id').attr('disabled', 'disabled');
        } else {
            $('select[name=parent_company_id').hide().attr('disabled', 'disabled');
            $('input[type=hidden][name=parent_company_id').removeAttr('disabled');
        }
    }).triggerHandler('change');

    //// 郵便番号 -> 住所(営業所Ver.) ////
    $(document).on('click', 'button.zip2address', function() {
        var zip = $('input.zip').val();
        
        if (!zip) { alert('郵便番号が入力されていません'); return false; }
        
        $.getJSON('../ajax/admin_genre.php',
            {"target": "machine", "action": "zip2address", "data": zip},
            function(json) {
                if (json.state == '') {
                    alert('郵便番号から住所を取得できませんでした');
                    return false;
                }
                
                $('input.addr1').val(json.state);
                $('input.addr2').val(json.city);
                $('input.addr3').val(json.address).focus();
            }
        );
        
        return false;
    });
    
    //// 営業所の緯度経度の取得 ////
    gc = new google.maps.Geocoder();
    $(document).on('change', 'input.addr3', function() {
        if ($(this).val() == '') { return false; }
        
        //// 住所を結合する ////
        var pureAddr = $('input.addr1').val() + ' ' + $('input.addr2').val() + ' ' + $(this).val();
           
        gc.geocode({'address': pureAddr}, function(results, status) {
            // 取得できなかった場合は無視
            if (status != 'OK') { return false; }
            
            $('input.lat').val(results[0].geometry.location.lat());
            $('input.lng').val(results[0].geometry.location.lng());
            
            return false;
        });
    });
});
</script>
<style type="text/css">
</style>
{/literal}
{/block}

{block 'main'}
<form id="form">
<input type="hidden" name="_target" value="company" />
<input type="hidden" name="_action" value="set" />
<input type="hidden" name="company_id" value="{$company.id}" />

<table class="member form">
  <tr class="company">
    <th>会社名<span class="required">(必須)</span></th>
    <td><input type="text" name="company" class="company" value="{$company.company}"
      placeholder="会社名" required /></td>
  </tr>
  
  <tr class="company_kana">
    <th>会社名（カナ）<span class="required">(必須)</span></th>
    <td><input type="text" name="company_kana" class="company_kana" value="{$company.company_kana}"
      placeholder="会社名（カナ）" required /></td>
  </tr>
  <tr class="representative">
    <th>代表者名<span class="required">(必須)</span></th>
    <td><input type="text" name="representative" value="{$company.representative}"
      placeholder="代表者名" required /></td>
  </tr>
  <tr class="zip">
    <th>〒<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="zip" class="zip" value="{$company.zip}" placeholder="XXX-YYYY" required />
      <button class="zip2address">〒=>住所</button>
    </td>
  </tr>
  <tr class="address">
    <th>住所<span class="required">(必須)</span></th>
    <td>
      <input type="text" name="addr1" class=" addr1" value="{$company.addr1}"
        placeholder="都道府県" required />
      <input type="text" name="addr2" class=" addr2" value="{$company.addr2}"
        placeholder="市区町村" required />
      <input type="text" name="addr3" class=" addr3" value="{$company.addr3}"
        placeholder="番地その他" required />
    </td>
  </tr>
  <tr class="address">
    <th>緯度・経度</th>
    <td>
      非表示、住所から自動入力します<br />
      <input type="text" name="lat" class="lat" value="{$company.lat}" placeholder="緯度" />
      <input type="text" name="lng" class="lng" value="{$company.lng}" placeholder="経度" />
    </td>
  </tr>
  <tr class="tel">
    <th>代表TEL<span class="required">(必須)</span></th>
    <td><input type="tel" name="tel" value="{$company.tel}" placeholder="例) XXXX-YY-ZZZZ" required /></td>
  </tr>
  
  <tr class="fax">
    <th>代表FAX<span class="required">(必須)</span></th>
    <td><input type="tel" name="fax" value="{$company.fax}" placeholder="例) XXXX-YY-ZZZZ" required /></td>
  </tr>
  
  <tr class="mail">
    <th>代表メールアドレス</th>
    <td>
      <input type="email" name="mail" class="mail" value="{$company.mail}" placeholder="aaa@bbbb.com" />
    </td>
  </tr>
  
  <tr class="website">
    <th>ウェブサイトURL</th>
    <td>
      <input type="url" name="website" class="website" value="{$company.website}" placeholder="http://www.～～～～.com/" />
    </td>
  </tr>
  <tr class="group">
    <th>所属団体<span class="required">(必須)</span></th>
    <td>
      <select name="group_id" class="group_id">
        {foreach $groupList as $g}
          <option value="{$g.id}" {if $g.id==$company.group_id|default:16} selected{/if}>
            {$g.treenames}
          </option>
        {/foreach}
      </select>
    </td>
  </tr>

  <tr class="rank">
    <th>ランク<span class="required">(必須)</span></th>
    <td>
      {html_options name="rank" options=$rankRatio selected=$company.rank|default:'0'}

      <input type="hidden" name="parent_company_id" value="" />

      <select name="parent_company_id" disabled="disabled">
        {foreach $companyList as $key => $c}
          {if $c@first}
            <optgroup label="{$c.treenames}">
          {elseif $companyList[$key-1]['treenames'] !=  $c.treenames}
            </optgroup>
            <optgroup label="{$c.treenames}">
          {/if}
            <option value="{$c.id}"
              {if !empty($company.parent_company_id) && $company.parent_company_id == $c.id}selected{/if}>
              {'/(株式|有限|合.)会社/'|preg_replace:'':$c.company}
            </option>
          {if $c@last}
            </optgroup>
          {/if}
        {/foreach}
      </select>
    </td>
  </tr>

  {*
  <tr class="rank">
    <th>支店・営業所フラグ<span class="required">(必須)</span></th>
    <td>
      {html_options name="branch" values=array('', 1) output=array('本社', '支店・営業所') selected=$company.branch|default:''}
    </td>
  </tr>
  *}
</table>
</form>
<button type="button" class="submit" value="member">会社情報を保存</button>
{/block}
