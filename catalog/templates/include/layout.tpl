{**
 * 共通レイアウト部分 
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/04/19
 *}
{*** htmlヘッダ ***}
{block 'html_header'}
  {include "include/html_header.tpl"}
{/block}
  
{block 'header'}{/block}

{*** ヘッダ ***}
{block 'header_bottom'}
  {include "include/header.tpl"}
{/block}
  
{block 'main'}{/block}

{*** フッタ ***}
{block 'footer'}
  {include "include/footer.tpl"}
{/block}
