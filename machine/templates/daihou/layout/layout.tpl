{**
 * 共通レイアウト部分
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2011/10/03
 *}
 {block 'html_header'}
  {include "daihou/layout/html_header.tpl"}
{/block}

{block 'header'}{/block}

{*** ヘッダ ***}
{block 'header_bottom'}
  {include "daihou/layout/header.tpl"}
{/block}

{block 'main'}{/block}

{*** フッタ ***}
{block 'footer'}
  {include "daihou/layout/footer.tpl"}
{/block}
