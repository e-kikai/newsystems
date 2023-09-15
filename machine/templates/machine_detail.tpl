{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="description"
    content="{$pageTitle}の中古機械詳細情報です。{if !empty($machine.addr1)}{$machine.addr1}・{/if}{$machine.company|regex_replace:'/(株式|有限|合.)会社/u':''}の中古機械情報ならマシンライフ！" />

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}ekikaiMylist.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}detail.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}detail.css?13" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
  <link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// マイリストに登録（機械：単一） ///
        $('button.mylist').click(function() {
          mylist.set($(this).val(), 'machine');
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block name='main'}
  {foreach $bidOpenList as $bo}
    {if !empty($bo.large_genre_id) && !empty($bo['machines'])}
      <a href="bid_list.php?o={$bo.id}&l={$bo.large_genre_id}" class="search_bid_banner"
        onclick="ga('send', 'event', 'seach2bid', 'bid', 'detail_banner', 1, true);">
        <div class="bid_title">{$bo.title} 開催中</div>
        <div class="bid_banner_now">出品中の{$bo.large_genre}一覧 <span class="bid_banner_click">Click▶</span></div>
      </a>
    {else}
      <a href="bid_door.php?o={$bo.id}" class="search_bid_banner"
        onclick="ga('send', 'event', 'seach2bid', 'bid', 'detail_banner', 1, true);">
        <div class="bid_title">{$bo.title} 開催中</div>
        <div class="bid_banner_now">入札会トップページはこちら <span class="bid_banner_click">Click▶</span></div>
      </a>
    {/if}
    {include "./include/bid_login_area.tpl"}
  {/foreach}

  {if !empty($h1Title)}
    <h1 class="detail_h1">{$h1Title|truncate:50:" ほか"}</h1>
  {elseif !empty($pageTitle)}
    <h1 class="detail_h1">{$pageTitle|truncate:50:" ほか"}</h1>
  {/if}


  {if !empty($machine)}

    {if !empty($machine.deleted_at)}
      <div class="alert alert-danger col-8 mx-auto my-4">
        <i class="fas fa-triangle-exclamation"></i>
        この機械は売却されました。<br /><br />
        お手数ですが、再度マシンライフでお探しの機械を検索して下さい。

        <a href="./" class="btn btn-primary mt-4" onClick="ga('send', 'event', 'mes_link', 'error', 'topppage', 1, true]);">
          <i class="fas fa-home"></i>
          中古機械情報 マシンライフ トップページへ
        </a>
      </div>
    {/if}

    <div class='detail_container'>

      {if empty($machine.deleted_at) || (!empty($_user) && Company::check_sp($_user.company_id))}

        {if Auth::check('mylist')}
          <button class='mylist' value='{$machine.id}'>機械情報をマイリストに追加</button>
        {/if}

        {*** 画像 ***}
        <div class="img_area">

          {if empty($machine.top_img) && empty($machine.imgs)}
            <img class='noimage' src='./imgs/noimage.png' alt="{$alt}" />
          {else}
            <div class='top_image'>
              <div id='viewport'>
                {if !empty($machine.top_img)}
                  <a class="zoom" href="{$_conf.media_dir}machine/{$machine.top_img}" target="_blank">
                    <img class="zoom_img" src="{$_conf.media_dir}machine/{$machine.top_img}" alt="{$alt}" />
                  </a>
                {/if}
              </div>
            </div>

            <div class='images'>
              {if !empty($machine.imgs)}
                {if !empty($machine.top_img)}
                  <a class="img" href="{$_conf.media_dir}machine/{$machine.top_img}" target="_blank">
                    <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="{$alt}" />
                  </a>
                {/if}

                {foreach $machine.imgs as $i}
                  <a class="img" href="{$_conf.media_dir}machine/{$i}" target="_blank">
                    <img src="{$_conf.media_dir}machine/thumb_{$i}" alt="{$alt}" />
                  </a>
                {/foreach}
              {/if}
            </div>
          {/if}

          {if !empty($machine.youtube) && preg_match_all('/([\w\-]{11})/', $machine.youtube, $res)}
            <div class="movies">
              {foreach $res[0] as $y}
                <a href="javascript:void(0)" data-youtubeid="{$y}" class="movie" title="クリックで動画再生します">
                  <img src="http://img.youtube.com/vi/{$y}/mqdefault.jpg" class="youtube_thumb" />
                  <img src="imgs/youtube_icon_48.png" class="youtube_icon" /></a>
              {/foreach}
            </div>
          {/if}

          <h2>中古機械についてのお問い合せ</h2>
          <p class="comment">
            以下のお問い合せフォーム、TEL、FAXより、掲載会社へお問い合せください。
          </p>
          <div class='contact_area'>
            {if !empty($machine.contact_mail)}
              <a class='contact_link' href='contact.php?m={$machine.id}'><img src='./imgs/contact_button.png' /></a>
            {/if}
            {if !empty($machine.contact_tel)}<div class='tel'>TEL : {$machine.contact_tel|replace:',':', '}</div>{/if}
            {if !empty($machine.contact_fax)}<div class='fax'>FAX : {$machine.contact_fax|replace:',':', '}</div>{/if}
          </div>

        </div>

        <div class="spec_area">
          <table class="spec">
            <tr class="">
              <th>管理番号</th>
              <td class="no">{$machine.no}</td>
            </tr>
            <tr class="">
              <th>機械名</th>
              <td>{$machine.name}</td>
            </tr>
            <tr class="">
              <th>メーカー</th>
              <td>{$machine.maker}</td>
            </tr>
            <tr class="">
              <th>型式</th>
              <td>{$machine.model}</td>
            </tr>
            <tr class="">
              <th>年式</th>
              <td>{$machine.year}</td>
            </tr>
          </table>

          <table class="spec">
            {if !empty($machine.capacity_label)}
              <tr class="capacity number">
                <th>{$machine.capacity_label}</th>
                <td>{if empty($machine.capacity)}-{else}{$machine.capacity}{$machine.capacity_unit}{/if}</td>
              </tr>
            {/if}

            <tr class="spec">
              <th>仕様</th>
              <td>
                {if !empty($others)}
                  <div class="others">{$others|escape|regex_replace:"/\s\|\s/":'</div> | <div class="others">' nofilter}</div> |
                {/if}
                {if !empty($machine.spec)}
                  <div class="others">
                    {$machine.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">' nofilter}</div>
                {/if}
              </td>
            </tr>

            <tr class="accessory">
              <th>附属品</th>
              <td>{$machine.accessory}</td>
            </tr>

            <tr class="comment">
              <th>コメント</th>
              <td>{$machine.comment}</td>
            </tr>

            <tr class="">
              <th>在庫場所</th>
              <td class='location'>
                {$machine.addr1} {$machine.addr2} {$machine.addr3}
                {if $machine.location}<br />({$machine.location}){/if}
                {if $machine.addr3}
                  {if preg_match('/^[a-zA-Z0-9]/',$company.addr1)}
                    <a class="accessmap"
                      href="https://maps.google.co.jp/maps?f=q&amp;q={$company.lat|escape:"url"} {$company.lng|escape:"url"}+({$company.company|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m"
                      style="color:#0000FF;text-align:left" target="_blank">
                      <i class="fas fa-map-location-dot"></i> MAP
                    </a>
                  {else}
                    <a class="accessmap"
                      href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
                      target="_blank">
                      <i class="fas fa-map-location-dot"></i> MAP
                    </a>
                  {/if}
                {/if}
              </td>
            </tr>

            {if Auth::check('member')}
              <tr class="price">
                <th>金額<span class="memberonly">(会員のみ公開)</span></th>
                <td>
                  {if !empty($machine.price)}
                    {$machine.price|number_format}円
                    ({if empty($machine.price_tax)}税込価格{else}税抜{/if})
                  {else}-
                  {/if}
                </td>
              </tr>
            {/if}

            <tr class="label_area">
              <td colspan="2">
                {if !empty($bidMachineIds[$machine.id])}
                  <a href="bid_detail.php?m={$bidMachineIds[$machine.id].bid_machine_id}" class="label bid" target="_blank"
                    title="クリックで出品商品ページへリンクします">
                    <i class="fas fa-pen-to-square"></i> {$bidMachineIds[$machine.id].bid_title} 出品中
                  </a>
                {/if}

                {if $machine.view_option == 2}<div class="label vo2">商談中</div>{/if}
                {if $machine.commission == 1}<div class="label commission">試運転可</div>{/if}
                {if !empty($machine.pdfs)}
                  {foreach $machine.pdfs as $key => $val}
                    <a href="{$_conf.media_dir}machine/{$val}" class="label pdf" target="_blank"
                      title="クリックで資料PDFを閲覧できます">PDF:{$key}</a>
                  {/foreach}
                {/if}

                {if !empty($machine.catalog_id)}
                  <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$machine.catalog_id}" class="label catalog" target="_blank"
                    title="クリックで電子カタログを閲覧できま">電子カタログ</a>
                {/if}

                {if !empty($_user) && Company::check_sp($_user.company_id) && $machine.xl_genre_id <= XlGenres::MACHINE_ID_LIMIT && $machine.model != ""}
                  <a href="/admin/histories/?id={$machine.id}" class="btn btn-warning btn-sm float-end">
                    <i class="fas fa-bars-staggered"></i>
                    同型式の在庫登録履歴
                  </a>
                {/if}
              </td>
            </tr>

          </table>

          <h2 class="">掲載会社情報</h2>
          <table class="spec">
            <tr class="">
              <th>会社名</th>
              <td>
                <a href='company_detail.php?c={$machine.company_id}'>{$company.company}</a>
              </td>
            </tr>

            <tr class="">
              <th>担当者</th>
              <td>{$company.officer}</td>
            </tr>

            <tr class='infos opening'>
              <th>営業時間</th>
              <td>{$company.infos.opening}</td>
            </tr>

            <tr class='infos holiday'>
              <th>定休日</th>
              <td>{$company.infos.holiday}</td>
            </tr>

            <tr class='infos license'>
              <th>古物免許</th>
              <td>{$company.infos.license}</td>
            </tr>

            <tr class='infos complex'>
              <th>所属団体</th>
              <td>{$company.treenames}</td>
            </tr>
          </table>
        </div>
        <br class="clear" />
      {/if}

      {if !empty($sameMachineList)}
        <h2 class="same_machine_label">この機械と同じ機械はこちら</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $sameMachineList as $sm}
                <div class="same_machine">
                  <a href="machine_detail.php?m={$sm.id}&r=dtl_same"
                    {* onClick="_gaq.push(['_trackEvent', 'log_detail', 'same', '{$sm.id}', 1, true]);" *}
                    onClick="ga('send', 'event', 'log_detail', 'same', '{$sm.id}', 1, true);">
                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />
                    {/if}
                    <div class="names">
                      {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>{/if}
                      {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>{/if}
                      {if !empty($sm.company)}<div class="name">{$sm.company|regex_replace:'/(株式|有限|合.)会社/u':''}</div>{/if}
                      {if !empty($sm.no)}<div class="name">({$sm.no})</div>{/if}
                    </div>
                  </a>
                </div>
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}

      {if !empty($nitamonoList)}
        <h2 class="same_machine_label">この機械と<span style="color:forestgreen;">見た目が似ている</span>機械はこちら</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $nitamonoList as $sm}
                <div class="same_machine">
                  <a href="machine_detail.php?m={$sm.id}&r=dtl_mnr"
                    {* onClick="_gaq.push(['_trackEvent', 'log_detail', 'nitamono', '{$sm.id}', 1, true]);" *}
                    onClick="ga('send', 'event', 'log_detail', 'nitamono', '{$sm.id}', 1, true);">
                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />
                    {/if}
                    <div class="names">
                      {if !empty($sm.name)} <div class="name">{$sm.name}</div>{/if}
                      {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
                      {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
                      {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>{/if}
                      {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>{/if}
                      {if !empty($sm.company)}<div class="name">{$sm.company|regex_replace:'/(株式|有限|合.)会社/u':''}</div>{/if}
                      {if !empty($sm.no)}<div class="name">({$sm.no})</div>{/if}
                    </div>
                  </a>
                </div>
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}

      {if !empty($logMachineList)}
        <h2 class="same_machine_label">この機械を見た人は、こちらの機械も見ています</h2>
        <div class="same_area">
          <div class='image_carousel'>
            <div class='carousel_products'>
              {foreach $logMachineList as $sm}
                <div class="same_machine">
                  <a href="machine_detail.php?m={$sm.id}&r=dtl_oth"
                    {* onClick="_gaq.push(['_trackEvent', 'log_detail', 'others', '{$sm.id}', 1, true]);" *}
                    onClick="ga('send', 'event', 'log_detail', 'others', '{$sm.id}', 1, true);">
                    {if !empty($sm.top_img)}
                      <img src="{$_conf.media_dir}machine/thumb_{$sm.top_img}" alt="" />
                    {else}
                      <img class='noimage' src='./imgs/noimage.png' alt="" />
                    {/if}
                    <div class="names">
                      {if !empty($sm.name)} <div class="name">{$sm.name}</div>{/if}
                      {if !empty($sm.maker)}<div class="name">{$sm.maker}</div>{/if}
                      {if !empty($sm.model)}<div class="name">{$sm.model}</div>{/if}
                      {if !empty($sm.year)}<div class="name">{$sm.year}年式</div>{/if}
                      {if !empty($sm.addr1)}<div class="name">{$sm.addr1}</div>{/if}
                      {if !empty($sm.company)}<div class="name">{$sm.company|regex_replace:'/(株式|有限|合.)会社/u':''}</div>{/if}
                      {if !empty($sm.no)}<div class="name">({$sm.no})</div>{/if}
                    </div>
                  </a>
                </div>
              {/foreach}
            </div>
          </div>
          {if $sm@total > 6}
            <div class="scrollRight"></div>
            <div class="scrollLeft"></div>
          {/if}
        </div>
      {/if}

    </div>
  {else}
    <div class="error_mes">
      指定された方法では、機械情報の特定ができませんでした<br />
      誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
    </div>
  {/if}

  {assign "keywords" "{$machine.name}|{$machine.hint}|{$machine.maker}|{$machine.model}|{$machine.genre}|{$machine.maker_master}|{$machine.maker_master_kana}"}
  {include file="include/mnok_ads.tpl"}

  <div class="keywords">
    {$machine.name} {$machine.hint} {$machine.maker} {$machine.model} {$machine.genre} {$machine.maker_master}
    {$machine.genre_kana} {$machine.maker_master_kana}
  </div>
{/block}