{extends file='include/layout.tpl'}
{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        //// 一括削除処理 ////
        $('button.csv_submit').click(function() {
          if (!confirm("電子カタログ一括登録・変更を開始します。よろしいですか？")) { return false; }
          var $_self = $(this);
          $_self.addClass('doing')
            .attr('disabled', 'disabled')
            .text('一括登録処理中');

          // 処理を実行
          $.post('/system/ajax/catalog_csv.php',
            {"target": "system", "action": "setCsv", "data": ''},
            function(data) {
              if (data == 'success') {
                alert('電子カタログ一括登録・変更が完了しました');
                location.href = '/system/';
              } else {
                alert(data);
                $_self.removeClass('doing')
                  .removeAttr('disabled')
                  .text('一括登録・変更を反映する');
              }
            }
          );
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <form class='csv' method='post' action='system/catalog_csv_conf.php' enctype="multipart/form-data">
    <fieldset class='csv_form'>
      <legend>CSVファイル(再アップロード)</legend>
      <input type='file' name='csv' id='csv' />
      <input type='submit' name='submit' class='submit' value='アップロード開始' />
    </fieldset>
  </form>

  <button class="csv_submit">一括登録・変更を反映する</button>
  <div class="company">{$company.company} 新規登録 : {$createCount}件、変更 : {$updateCount}件</div>

  <ul>
    <li>
      新規登録の場合、PDFファイルがない場合(PDFが<span style="color:red;">×</span>のもの)は登録されません<br />
      (変更の場合は、情報のみ更新されます)
    </li>
    <li>ジャンルが表示されない場合は、ジャンル名が間違っている可能性がありますので、再度確認してください</li>

  </ul>

  <div class="table_area">
    <table class='catalog csv list'>
      <thead>
        <tr>
          <th class="id">ID</th>
          <th class="uid">UID</th>
          <th class="file">PDF</th>
          <th class="genres">ジャンル</th>
          <th class="maker">メーカー</th>
          <th class="model">型式</th>
          <th class="year">年式</th>
          <th class="catalog_no">カタログNo.</th>
        </tr>
      </thead>

      {foreach $catalogList as $m}
        {* (変更)変更しない、処理を飛ばす *}
        <tr class='{cycle values='even, odd'}'>
          <td class="id">
            {if empty($m.id)}新規{else}{$m.id}{/if}
          </td>
          <td class="uid">{$m.uid}</td>
          <td class="file">{if $m.exsist==true}◯{else}<span style="color:red;">×</span>{/if}</td>
          <td class="genres">
            {foreach $m.genres_temp as $g}
              <div>{$g.genre}</div>
            {foreachelse}
              <span style="color:red;">ジャンル取得出来ませんでした</span>
            {/foreach}
          </td>
          <td class="maker">{$m.maker}</td>
          <td class="model">{$m.models}</td>
          <td class="year">{$m.year}</td>
          <td class="catalog_no">{$m.catalog_no}</td>
        </tr>
      {/foreach}
    </table>
  </div>
{/block}