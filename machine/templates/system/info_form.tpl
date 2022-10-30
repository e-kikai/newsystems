{extends file='include/layout.tpl'}

{block 'header'}
  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery-ui.js"></script>
  <link href="{$_conf.libjs_uri}/css/ui-lightness/jquery-ui.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.textresizer.js"></script>

  <script type="text/javascript">
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
            if (!confirm('保存しますよろしいですか')) { return false; }

            $.post('/system/ajax/info.php',
              {"target": "system", "action": "set", "data": {
              'id': $('input#id').val(),
              'info_date': $('input#info_date').val(),
              'target': $('select#target').val(),
              'group_id': $('select#group_id').val(),
              'contents': $('textarea#contents').val(),
            }
          },
          function(data) {
            if (data == 'success') {
              alert('お知らせを保存しました');
              location.href = '/system/info_list.php';
            } else {
              alert(data);
            }
          }
        );

        return false;
      });

      //// 日付選択 ////
      $('input#info_date').datepicker({
      showAnim: 'fadeIn',
      prevText: '',
      nextText: '',
      dateFormat: 'yy/mm/dd',
      altFormat: 'yy/mm/dd',
      appendText: '',
      minDate: '2011/07/07'
      });

      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="form_comment">
    <span class="alert">※</span>
    　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
  </div>

  <form class="info" method="POST" action="">
    <table class="info form">
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

      <tr class="group_id">
        <th>対象団体</th>
        <td>
          <select name="group_id" id="group_id">
            <option value="">すべて</option>
            {foreach $groupList as $g}
              <option value="{$g.id}" {if $g.id==$info.group_id} selected{/if}>
                {$g.treenames}
              </option>
            {/foreach}
          </select>
        </td>
      </tr>

      <tr class="contents">
        <th>内容<span class="required">(必須)</span></th>
        <td>
          <textarea name="contents" id="contents" required>{$info.contents}</textarea>
        </td>
      </tr>
    </table>

    <button type="button" name="submit" class="submit" value="member">変更を保存</button>

  </form>
{/block}