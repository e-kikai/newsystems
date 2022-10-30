{**
 * 共通フッタ部分
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 *}


{*** 問い合わせ枠 ***}
{if empty($hideFooterbanner)}
  <div class="footer_link_area">
    <a class="footer_contact_link" href="./contact.php">
      <img src="./imgs/daihou_c.png" />
    </a>
  </div>
{/if}

<footer class="row footer mt-5 pb-5">
    <div class="footer_compnies col-12 col-sm-7 col-md-6 pt-3">
      <a href="./" class=''>
        <img src="./imgs/daihou_logo_w_02.png" class="footer_logo" alt="大宝機械株式会社" />
      </a>
      <div class="footer_zip">〒 578-0965</div>
      <div class="footer_address">大阪府 東大阪市 本庄西2-4-24</div>
    </div>

    <div class="d-none d-sm-block col-4 offset-1 offset-md-2 pt-3 px-3">
      <div class="footer_menu px-4">
        <a class="" href="./">TOP</a>
        <a class="" href="./machines.php">在庫機械一覧</a>
        <a class="" href="./company.php">会社情報</a>
        <a class="" href="./access.php">アクセス</a>
        <a class="" href="./contact.php">お問い合わせ</a>
      </div>
    </div>

  {*
  <p class="copyright">
    Copyright &copy; {$smarty.now|date_format:"%Y"}
    <a href="{$_conf.website_uri}" target="_blank">{$_conf.copyright}</a>
    All Rights Reserved.
  </p>
  *}
</footer>

</div>
</body>
</html>
