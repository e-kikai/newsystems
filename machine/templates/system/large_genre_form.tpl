{extends file='include/layout.tpl'}

{block 'header'}
  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.upload.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  {*** JQueryバリデータ ***}
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
          if (!$_form.valid()) { return false; }

          if (!confirm('変更を保存します。よろしいですか。')) { return false; }

          //// 入力データを取得 ////////
          var data = $_form.find('[name]').serializeArray();

          $('button.submit').attr('disabled', 'disabled');

          $.post('/system/ajax/post.php', data, function(res) {
            $('button.submit').removeAttr('disabled');

            if (res != 'success') { alert(res); return false; } // エラー表示

            // 保存完了 : 自社サイト一覧に戻る
            location.href = '/system/large_genre_list.php?x=' + $('input[name=xl_genre_id]').val();
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
  <form id="form">
    <input type="hidden" name="_target" value="largeGenre" />
    <input type="hidden" name="_action" value="set" />
    <input type="hidden" name="id" value="{$largeGenre.id}" />
    <input type="hidden" name="xl_genre_id" value="{$largeGenre.xl_genre_id}" />

    <table class="member form">
      <tr class="xl_genre">
        <th>大ジャンル名</th>
        <td>{$largeGenre.xl_genre}</td>
      </tr>
      <tr class="large_genre">
        <th>中ジャンル名<span class="required">(必須)</span></th>
        <td>
          <input type="text" name="large_genre" value="{$largeGenre.large_genre}" placeholder="中ジャンル名" required />
        </td>
      </tr>

      <tr class="large_genre">
        <th>中ジャンル名(カナ)</th>
        <td>
          <input type="text" name="large_genre_kana" value="{$largeGenre.large_genre_kana}" placeholder="中ジャンル名(カナ)" />
        </td>
      </tr>

      <tr class="hidden_option">
        <th>非表示オプション<span class="required">(必須)</span></th>
        <td>
          {html_options name=hide_option options=LargeGenres::getHideOptions() selected=$largeGenre.hide_option|default:''}
        </td>
      </tr>

      <tr class="order_no">
        <th>並び順<span class="required">(必須)</span></th>
        <td>
          <input type="number" class="digits num" name="order_no" value="{$largeGenre.order_no}" placeholder="並び順(整数)"
            required />
        </td>
      </tr>
    </table>
  </form>
  <button type="button" class="submit">情報を保存</button>
{/block}