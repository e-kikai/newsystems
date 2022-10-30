{extends file='include/layout.tpl'}

{block 'header'}
  <meta name="description"
    content="新着中古機械一覧、{$keywords}の中古機械に関する情報が満載。{$keywords}の中古機械検索や中古機械販売などの中古機械情報ならマシンライフ！全機連が運営する中古機械情報サイトです。{$keywords}の中古機械が様々な条件で検索可能。" />
  <meta name="keywords" content="新着中古機械一覧,中古機械,中古機械販売,中古機械情報,中古機械検索,中古工作機械,機械選び,工作機械,マシンライフ
" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />
  {literal}
    <script type="text/javascript">
    </script>
    <style>
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class='machine_list list'>
    {*** ページャ ***}
    {include file="include/pager.tpl"}

    {foreach $machineList as $m}
      {include file="include/machine_news.tpl" m=$m baseKey=$baseKey}
    {/foreach}

    {*** ページャ ***}
    {include file="include/pager.tpl"}
  </div>

{/block}