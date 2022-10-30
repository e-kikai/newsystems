{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />>

  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.validate.min.js"></script>
  <script type="text/javascript" src="{$_conf.libjs_uri}/messages_ja.js"></script>

  {literal}
    <script type="text/javascript">
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
            location.href = '/system/companysite_list.php';
          }, 'text');

          return false;
        });
      });
    </script>
    <style type="text/css">
      input[name=subdomain] {
        width: 100px;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <form id="form">
    <input type="hidden" name="_target" value="companysite" />
    <input type="hidden" name="_action" value="set" />

    <input type="hidden" name="companysite_id" value="{$companysite.companysite_id}" />

    <table class="member form">
      <tr class="company">
        <th>会社<span class="required">(必須)</span></th>
        <td>
          {if empty($companysite.companysite_id)}
            <select name="company_id" required>
              <option value="">▼会社を選択▼</option>
              {foreach $companyList as $key => $c}
                {if $c@first}
                  <optgroup label="{$c.treenames}">
                  {elseif $companyList[$key-1]['treenames'] !=  $c.treenames}
                  </optgroup>
                  <optgroup label="{$c.treenames}">
                  {/if}
                  <option value="{$c.id}">{'/(株式|有限|合.)会社/'|preg_replace:'':$c.company}</option>
                  {if $c@last}
                  </optgroup>
                {/if}
              {/foreach}
            </select>
          {else}
            <input type="hidden" name="company_id" value="{$companysite.company_id}" />
            {$companysite.company}
          {/if}
        </td>
      </tr>

      <tr class="company_kana">
        <th>サイトURL<span class="required">(必須)</span></th>
        <td>
          {$_conf.site_uri}s/<input type="text" name="subdomain" value="{$companysite.subdomain}" placeholder="test"
            required />/
        </td>
      </tr>

      <tr class="company_kana">
        <th>公開<span class="required">(必須)</span></th>
        <td>
          {html_options name="closed" values=array(0, 1) output=array('公開中', '閉鎖中')
          selected=$companysite.closed|default:''}
        </td>
      </tr>
    </table>
  </form>
  <button type="button" class="submit" value="member">情報を保存</button>
{/block}