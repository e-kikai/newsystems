{extends file='include/layout.tpl'}

{block 'header'}
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/JavaScript">
{literal}
$(function() {
});
</script>
<style type="text/css">
  .flyer_menu a {
    display: block;
    font-size: 17px;
    margin: 16px 16px;
    text-decoration: none;
    color: #FFF;
    background: #3434da;
    border: 2px solid #00A;
    width: 240px;
    height: 40px;
    text-align: center;
    line-height: 40px;
  }
</style>
{/literal}
{/block}

{block 'main'}
  <a href="admin/flyer_list.php" class="back_link">← チラシメール一覧に戻る</a>

  <div class="flyer_menu">
    <p>
      送信されるメール内容は「デザイン確認」で表示を確認できます。
    </p>
    <a href="admin/flyer_design.php?id={$flyer.id}">デザイン確認</a>

    {if $campaign.status == "schedule"}
      <p>
        スケジュールした送信時間をキャンセルします。
      </p>
      <a href="admin/flyer_cancel_do.php?id={$flyer.id}">スケジュールキャンセル</a>
    {else}
      <p>
        デザインや内容を修正したい場合は、「送信内容修正」から修正を行って下さい。
      </p>
      <a href="admin/flyer_form.php?id={$flyer.id}">送信内容修正</a>

      <p>
        内容確認のために、実際にメールをテスト送信することができます。
      </p>
      <a href="admin/flyer_test.php?id={$flyer.id}">送信テスト</a>

      <p>
        デザインに問題がなければ、「送信最終確認」にお進み下さい
      </p>
      <a href="admin/flyer_conf.php?id={$flyer.id}">送信最終確認</a>
    {/if}

  </div>
{/block}
