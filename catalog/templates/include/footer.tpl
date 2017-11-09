{**
 * 共通フッタ部分 
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/04/19
 *}
  </div>
  <footer>
    {*
    <img class='footer_title' src='img/footer_title.png' alt='COPYRIGHT {$_conf.copyright} {$smarty.now|date_format:"%Y"} {$_conf.copyright}'/>
    *}
     Copyright © {$smarty.now|date_format:"%Y"} <a href="{$_conf.website_uri}" target="_blank">{$_conf.copyright}</a> All Rights Reserved.
  </footer> 
</div> 
</body> 
</html>
