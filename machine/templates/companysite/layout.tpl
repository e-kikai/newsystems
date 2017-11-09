{**
 * 自社サイト共通レイアウト部分 
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.2
 * @since   2011/10/03
 *} 
{*** htmlヘッダ ***}
{block 'html_header'}
  {include "companysite/html_header.tpl"}
{/block}
  
{block 'header'}{/block}

{*** ヘッダ ***}
{block 'header_bottom'}
  {include "companysite/header.tpl"}
{/block}
  
{block 'main'}{/block}

{*** フッタ ***}
{block 'footer'}
  {include "companysite/footer.tpl"}
{/block}
