{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="d-grid gap-2 col-8 mx-auto my-3">
    <h2>入札を受け付けました。</h2>
    <p>
      入札締め切り日時は、<span class="fs-5 px-2">{$bid_open.user_bid_date|date_format:'%Y/%m/%d %H:%M'}</span>です。<br />
      入札の結果については、下見・入札期間終了まで、今しばらくお待ち下さい。
    </p>
    <p class="contents">
      ・ 入札は、下見・入札期間内であれば、取消・再入札を行うことができます。<br />
      ・ 入札の結果は、入札締め切り後に確定・公開されます。<br />
      (入札締切後は、入札の取り消しを行うことはできません)<br />
      ・ 同額の入札があった場合は、同額入札から落札者をシステムで自動的に決定いたします。予めご了承ください。<br />
      ・ 落札された場合は、各自出品会社と直接取引を行ってください。
    </p>
  </div>

  <hr />

  <div class="d-grid gap-2 col-6 mx-auto my-3">
    <a href="/bid_detail.php?m={$bid_machine.id}"" class=" btn btn-outline-secondary">
    <i class="fas fa-backward"></i> この商品詳細ページに戻る
  </a>
  <a href="/bid_door.php?o={$bid_machine.bid_open_id}" class="btn btn-outline-secondary" target="_blank">
    <i class="fas fa-magnifying-glass"></i> 別の商品をさがす - Web入札会トップページ
  </a>
  <a href="/mypage/my_bid_bids/?o={$bid_machine.bid_open_id}" class="btn btn-outline-secondary">
    <i class="fas fa-pen-to-square"></i> マイページ - 入札履歴一覧ページへ
  </a>
  <a href="/mypage/" class="btn btn-outline-secondary">
    <i class="fas fa-house"></i> マイページ トップに戻る
    </a>
{/block}