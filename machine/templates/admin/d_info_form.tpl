{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        //// 数値のみに自動整形 ////
        $('input.price').change(function() {
          var price = mb_convert_kana($(this).val(), 'KVrn').replace(/[^0-9]/g, '');
          $(this).val(price ? parseInt(price) : '');
        });

        //// datepicker ////
        $('input.date').datepicker({
          showAnim: 'fadeIn',
          prevText: '',
          nextText: '',
          dateFormat: 'yy/mm/dd',
          altFormat: 'yy/mm/dd',
          changeMonth: true,
          appendText: '',
          maxDate: '',
          minDate: ''
        });

        //// お知らせ処理 ////
        $('button.submit').click(function() {
          var data = {
            'id': $.trim($('input.id').val()),
            'info_date': $.trim($('input.info_date').val()),
            'title': $.trim($('input.title').val()),
            'contents': $.trim($('textarea.contents').val()),
          };

          //// 入力のチェック ////
          var e = '';
          if (data.info_date == '') { e += "表示日付がありません\n"; }
          if (data.title == '') { e += "タイトルがありません\n"; }
          if (data.contents == '') { e += "内容がありません\n"; }

          //// エラー表示 ////
          if (e != '') {
            alert(e);
            // sendEvent('form_error');
            return false;
          }

          // 送信確認
          if (!confirm('お知らせを送信します。よろしいですか。')) {
            // sendEvent('cancel');
            return false;
          }

          $.post('/admin/ajax/d_info.php', {
            'target': 'machine',
            'action': 'set',
            'data': data
          }, function(res) {
            if (res != 'success') {
              alert(res);
              // sendEvent('server_error');
              return false;
            }
            location.href = '/admin/d_info_list.php?r=update'; // 保存完了
          });

          return false;
        });
      });
    </script>
    <style type="text/css">
      table.form td textarea {
        width: 492px;
        height: 9.6em;
        line-height: 1.2;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <div class="form_comment">
    <span class="alert">※</span>
    　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
  </div>

  <form class="machine" method="post" action="admin/d_info_do.php" enctype="multipart/form-data">
    <input type="hidden" name="id" class="id" value="{$dInfo.id}" />

    <table class="machine form">
      <tr class="bid">
        <th>日付</th>
        <td>
          <input type="text" name="info_date" class="date info_date" value="{$dInfo.info_date|date_format:'%Y/%m/%d'}" />
        </td>
      </tr>

      <tr class="name">

        <th>タイトル<span class="required">(必須)</span></th>
        <td>
          <input type="text" name="title" class="title default" value="{$dInfo.title}" placeholder="タイトル" required />
        </td>
      </tr>
      <tr class="spec">
        <th>内容</th>
        <td>
          <textarea name="contents" class="contents" placeholder="お知らせページに表示する内容本文を入力してください">{$dInfo.contents}</textarea>
        </td>
      </tr>
    </table>

    <button type="button" name="submit" class="submit" value="member">入力内容を保存</button>

  </form>
{/block}