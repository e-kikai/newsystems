{extends file='include/layout.tpl'}

{block 'header'}
  {literal}
    <script type="text/javascript">
      <!--
  //
  -->
    </script>
    <style type="text/css">
      <!--
  -->
    </style>
  {/literal}
{/block}

{block 'main'}
  <ul class="top_menu">
    <li class="title">ログ情報</li>
    <li><a href="admin/log_list.php">アクションログ</a></li>

    <li class="title">システム管理</li>
    <li><a href="http://lion.etest.wjg.jp:81/munin/" target="_blank">munin</a></li>
  </ul>
{/block}