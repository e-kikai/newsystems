{extends file='include/layout.tpl'}
{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        $('input.submit').click(function() {
          if ($('input#csv').val() == '') {
            alert('ファイルが選択されていません');
            return false;
          }
          return true;
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
      <legend>CSVファイル</legend>
      <input type='file' name='csv' id='csv' />
      <input type='submit' name='submit' class='submit' value='アップロード開始' />
    </fieldset>
  </form>

{/block}