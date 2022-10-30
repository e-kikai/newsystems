{extends file='daihou/layout/layout.tpl'}


{block 'header'}

{literal}
<script type="text/javascript">
$(function() {
});
</script>
<style type="text/css">


</style>
{/literal}
{/block}

{block 'main'}
  <h2 class="minititle"><i class="fas fa-paper-plane"></i>フォームからお問い合わせ 完了</h2>
  <p class="contact_message">
    お問い合わせありがとうございます。<br />
    担当者が確認次第、折り返しご連絡を差し上げます。<br /><br />

    万が一、システムからの通知メールが届かなかった場合は、入力メールアドレスに誤りがあった可能性があります。<br />
    お手数ですがメールアドレスをご確認の上、再度お問い合わせをしていただきますようお願いいたします。<br /><br />

    今後とも、<a href="./"">{$company.company}</a>をよろしくお願いいたします。
  </p>
{/block}