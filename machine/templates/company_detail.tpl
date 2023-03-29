{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="description"
    content="{$company.addr1}{$company.addr2}{$company.addr3}{if !empty($company.infos.pr)} {$company.infos.pr}{/if}{if !empty($company.infos.comment)} {$company.infos.comment}{/if}" />
  {*
  <meta name="keywords" content="{$company.company},{$company.treenames}" />
  *}

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}ekikaiMylist.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}company_detail.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// マイリストに登録（会社：単一） ///
        $('button.mylist').click(function() {
          mylist.set($(this).val(), 'company');
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}

{/block}

{block 'main'}
  <div class='company_container'>
    {if Auth::check('mylist')}
      <button class='mylist' value='{$company.id}'>会社をマイリストに追加</button>
    {/if}

    <div class='message_area'>
      {if !empty($company.infos.pr)}
        <strong>{$company.infos.pr|escape|nl2br|auto_link nofilter}</strong>
      {/if}
      {if !empty($company.infos.comment)}
        <p>{$company.infos.comment|escape|nl2br|auto_link nofilter}</p>
      {/if}

      <div class='img_area'>
        {if !empty($company.top_img)}
          <img src='{$_conf.media_dir}company/{$company.top_img}'
            alt="中古機械登録会社 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}" />
        {/if}

        {if !empty($company.imgs)}
          {foreach $company.imgs as $i}
            <img src='{$_conf.media_dir}company/{$i}'
              alt="中古機械登録会社 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}" />
          {/foreach}
        {/if}
      </div>
    </div>

    <div class='contents_area' itemscope itemtype="http://data-vocabulary.org/Organization">
      {if $company.id == 1}
        <a href="{$company.website}" target="_blank" class="e-kikai_sticker">
          <img class="sticker_img" src="https://www.e-kikai.com/images/e-kikai-header-logo.gif" alt="e-kikai" />
          <span class="sticker_name">{$company.company}</span>
        </a>
      {/if}

      <table class='contents'>
        <tr class='name'>
          <th>名称</th>
          <td itemprop="name">{$company.company}</td>
        </tr>
        <tr class='address'>
          <th>住所</th>
          <td>
            〒
            <span class="pure_address" itemprop="address" itemscope itemtype="http://data-vocabulary.org/Address">
              <span itemprop="postal-code">
                {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}
              </span>
              <span itemprop="region">{$company.addr1}</span>
              <span itemprop="locality">{$company.addr2}</span>
              <span itemprop="street-address">{$company.addr3}</span>
            </span>
            {*
          <div class="hidden lat">{$company.lat}</div>
          <div class="hidden lng">{$company.lng}</div>
          *}
          </td>
        </tr>

        <tr class='contact'>
          <th>お問い合わせ</th>
          <td>
            <span class='tel'>TEL : <span itemprop="tel">{$company.contact_tel}</span></span><br />
            ご連絡の際に、<br />
            「{$_conf.site_name}を見て」<br />
            とお伝え下さい<br />
            <span class='tel'>FAX : {$company.contact_fax}</span>
            {if !empty($company.contact_mail)}
              <br /><a class='contact' href='/contact.php?c={$company.id}'>メールフォームからお問い合わせ</a>
            {/if}
          </td>
        </tr>

        <tr class='officer'>
          <th>担当者</th>
          <td>{$company.officer}</td>
        </tr>

        <tr class='machine_list'>
          <th>在庫一覧</th>
          <td>
            <a href="/search.php?c={$company.id}">
              <i class="fas fa-list"></i> 在庫一覧
            </a>
          </td>
        </tr>

        <tr class='infos access_train'>
          <th>交通機関：<br />最寄り駅</th>
          <td>
            {if !empty($company.infos.access_train)}
              {$company.infos.access_train|escape|default:""|nl2br nofilter}<br />
            {/if}
            <a href='https://www.google.co.jp/maps?daddr={$company.addr1|urlencode}{$company.addr2|urlencode}{$company.addr3|urlencode}&hl=ja&ie=UTF8'
              target='_blank'>
              <i class="fas fa-train"></i> 乗換案内
            </a>
          </td>
        </tr>

        <tr class='infos access_car'>
          <th>交通機関：車</th>
          <td>
            {if !empty($company.infos.access_car)}
              {$company.infos.access_car|escape|default:""|nl2br nofilter}<br />
            {/if}
            <a href='https://www.google.co.jp/maps?daddr={$company.addr1|urlencode}{$company.addr2|urlencode}{$company.addr3|urlencode}&hl=ja&ie=UTF8&dirflg=d'
              target='_blank'>
              <i class="fas fa-car"></i> Googleルート案内
            </a>
          </td>
        </tr>

        <tr class='infos opening'>
          <th>営業時間</th>
          <td>{$company.infos.opening}</td>
        </tr>

        <tr class='infos holiday'>
          <th>定休日</th>
          <td>{$company.infos.holiday}</td>
        </tr>

        {if $company.website}
          <tr class='officer'>
            <th>ウェブサイト</th>
            <td>
              <a href="{$company.website}" target="_blank" itemprop="url">{$company.website}</a>
            </td>
          </tr>
        {/if}

        {if !empty($companysite.subdomain)}
          <tr class='officer'>
            <th>マシンライフ<br />ウェブサイト</th>
            <td><a href="{$_conf.site_uri}s/{$companysite.subdomain}/"
                target=="_blank">{$_conf.site_uri}s/{$companysite.subdomain}/</a></td>
          </tr>
        {/if}

        <tr class='infos license'>
          <th>古物免許</th>
          <td>{$company.infos.license}</td>
        </tr>

        <tr class='infos complex'>
          <th>所属団体</th>
          <td>{$company.treenames}</td>
        </tr>
      </table>

      {*
    <div id="gmap"></div>
    *}

      {*
    <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
      src="https://maps.google.co.jp/maps?f=q&amp;q={$company.addr1|escape:"url"}{$company.addr2|escape:"url"}{$company.addr3|escape:"url"}+({$company.company|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
    <a href="https://maps.google.co.jp/maps?f=q&amp;q={$company.addr1|escape:"url"}{$company.addr2|escape:"url"}{$company.addr3|escape:"url"}+({$company.company|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m" style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
    *}

      {if preg_match('/^[a-zA-Z0-9]/',$company.addr1)}
        <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
          src="https://maps.google.co.jp/maps?f=q&amp;q={$company.lat|escape:"url"} {$company.lng|escape:"url"}+({$company.company|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
        <a href="https://maps.google.co.jp/maps?f=q&amp;q={$company.lat|escape:"url"} {$company.lng|escape:"url"}+({$company.company|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m"
          style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
      {else}
        <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
          src="https://maps.google.co.jp/maps?f=q&amp;q={$company.addr1|escape:"url"}{$company.addr2|escape:"url"}{$company.addr3|escape:"url"}+({$company.company|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
        <a href="https://maps.google.co.jp/maps?f=q&amp;q={$company.addr1|escape:"url"}{$company.addr2|escape:"url"}{$company.addr3|escape:"url"}+({$company.company|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m"
          style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a>
      {/if}
    </div>
    <br style='clear:both;' />

    {if $company.id == 1}
      <div>ものづくりオークション 出品中</div>
      {assign "keywords" "堀川機械"}
      {include file="include/mnok_ads.tpl"}
    {/if}

  </div>
{/block}