{extends file='include/layout.tpl'}

{block name='header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}machines.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        $('.anchor_area a[href*=#]').click(function() {
          var target = $(this.hash);
          if (target) {
            var targetOffset = target.offset().top;
            $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
            return false;
          }
        });
      });
    </script>
    <style type="text/css">
      .maker {
        display: inline-block;
        width: 13.9%;
        vertical-align: top;
        overflow: hidden;
      }

      .maker a {
        white-space: nowrap;
      }

      .maker_area {
        margin-bottom: 16px;
        border: 0;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  {*** アンカーリンク ***}
  <div class="filter_area capacity_area anchor_area">
    <li>
      <span class="area_label">50音順</span>
    </li>
    {foreach $makerList as $ma}
      {if preg_match('/行$/', B::get50onRow($ma.maker_kana))}
        {if !$ma@index || B::get50onRow($ma.maker_kana) != B::get50onRow($makerList[$ma@key-1].maker_kana)}
          <li><a href="{$smarty.server.REQUEST_URI}#{B::get50onRow($ma.maker_kana)}">{B::get50onRow($ma.maker_kana)}</a></li>
        {/if}
      {/if}
    {/foreach}
    <li><a href="{$smarty.server.REQUEST_URI}#英数字・その他">英数字・その他</a></li>
  </div>

  <div>
    {foreach $makerList as $ma}
      {if preg_match('/行$/', B::get50onRow($ma.maker_kana))}
        {if $ma@first || B::get50onRow($ma.maker_kana) != B::get50onRow($makerList[$ma@key - 1].maker_kana)}
        </div>
        <h2 id="{B::get50onRow($ma.maker_kana)}">{B::get50onRow($ma.maker_kana)}</h2>
        <div>
        {/if}

        {if $ma@first || mb_substr($ma.maker_kana, 0, 1) != mb_substr($makerList[$ma@key - 1].maker_kana, 0, 1)}
        </div>
        <h3>{$ma.maker_kana|mb_substr:0:1}</h3>
        <div class="maker_area">
        {/if}

        <div class="maker">
          <a href="search.php?ma={$ma.maker}" {if $ma.maker != $ma.makers}title="{$ma.makers}" {/if}>{$ma.maker}<span
              class="count">({$ma.count})</span></a>
        </div>
      {/if}

      {if $ma@last}
      </div>
    {/if}
  {/foreach}

  <h2 id="英数字・その他">英数字・その他</h2>
  <div class="maker_area">
    {foreach $makerList as $ma}
      {if !preg_match('/行$/', B::get50onRow($ma.maker_kana))}
        <div class="maker">
          <a href="search.php?ma={$ma.maker}" {if $ma.maker != $ma.makers}title="{$ma.makers}" {/if}>{$ma.maker}<span
              class="count">({$ma.count})</span></a>
        </div>
      {/if}
    {/foreach}
  </div>

{/block}