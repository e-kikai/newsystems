{extends file='include/layout.tpl'}

{block name='header'}
  {*
<meta name="description" content="中古機械情報:{$machine.name} {$machine.maker} {$machine.model} {$machine.company} {$machine.addr1}{$machine.addr2}" />
<meta name="keywords" content="中古機械,used_machine,全機連,{$machine.name},{$machine.maker},{$machine.model},{$machine.company},{$machine.addr1}{$machine.addr2},{$machine.genre},{$machine.large_genre},{$machine.hint}" />
*}

  {*
<meta name="description" content="
{if !empty({$machine.capacity}) && !empty({$machine.capacity_label})}{$machine.capacity_label}:{$machine.capacity}{$machine.capacity_unit} | {/if}
{if !empty({$machine.year})}年式:{$machine.year} | {/if}
{if !empty({$machine.addr1})}在庫場所:{$machine.addr1} | {/if}
{if !empty({$others})}{$others} | {/if}
{$machine.spec}
{if $machine.commission == 1} 試運転可{/if}
" />
<meta name="keywords" content="{$machine.name},{$machine.hint},{$machine.maker},{$machine.model},{$machine.company},{$machine.addr1},中古機械,全機連,マシンライフ" />
*}
  <meta name="description"
    content="{$pageTitle}の中古機械詳細情報です。{if !empty($machine.addr1)}{$machine.addr1}・{/if}{$machine.company|regex_replace:'/(株式|有限|合.)会社/u':''}の中古機械情報ならマシンライフ！" />
  <meta name="keywords" content="{$machine.name},{$machine.maker},{$machine.model},
    中古機械,中古機械販売,中古機械情報,中古機械検索,中古工作機械,機械選び,工作機械,マシンライフ" />

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
        //// マイリストに登録（機械：単一） ////
        $('button.mylist').click(function() {
          mylist.set($(this).val(), 'machine');
        });
      });
    </script>
    <style type="text/css">
      #gmap2 {
        width: 100%;
      }

      h1 {
        display: none;
      }

      h1.detail_h1 {
        display: block;
      }
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
  {/foreach}

  {if !empty($h1Title)}
    <h1 class="detail_h1">{$h1Title|truncate:50:" ほか"}</h1>
  {elseif !empty($pageTitle)}
    <h1 class="detail_h1">{$pageTitle|truncate:50:" ほか"}</h1>
  {/if}


  {if !empty($machine)}
    <div class='detail_container'>
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
            {*
    {if !empty($machine.imgs) || (!empty($machine.youtube) && preg_match("/https?:\/\/youtu.be\/(.+)/", $machine.youtube, $res))}
    *}
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
            <div>
              {foreach $res[0] as $y}
                <a href="javascript:void(0)" data-youtubeid="{$y}" class="movie" title="クリックで動画再生します">
                  <img src="http://img.youtube.com/vi/{$y}/mqdefault.jpg" class="youtube_thumb" />
                  <img src="imgs/youtube_icon_48.png" class="youtube_icon" /></a>
              {/foreach}
            </div>
          {/if}

          {*** youtube ***}
          {*
  {if !empty($machine.youtube) && preg_match("/http:\/\/youtu.be\/(.+)/", $machine.youtube, $res)}
    <div class="youtube">
      <iframe width="400" height="300"
        src="https://www.youtube.com/embed/{$res[1]}?rel=0"
        frameborder="0" allowfullscreen></iframe>
    </div>
  {/if}
  *}

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

          {*
    <table class='machine'>
      <tr>
        <th class="no">管理番号</th>
        <th class='name'>機械名</th>
        <th class='maker'>メーカー</th>
        <th class='model'>型式</th>
        <th class='year'>年式</th>
      </tr>

      <tr class='machine machine_{$machine.id}'>
        <td class='no'>{$machine.no}</td>
        <td class='name'>{$machine.name}</td>
        <td class='maker'>{$machine.maker}</td>
        <td class='model'>{$machine.model}</td>
        <td class='year'>{$machine.year}</td>
      </tr>
    </table>
    *}

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
                  {*
            <button class="accessmap" src="{$smarty.server.REQUEST_URI}#gmap2">MAP</button>
            *}
                  {if preg_match('/^[a-zA-Z0-9]/',$company.addr1)}
                    <a class="accessmap"
                      href="https://maps.google.co.jp/maps?f=q&amp;q={$company.lat|escape:"url"} {$company.lng|escape:"url"}+({$company.company|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m"
                      style="color:#0000FF;text-align:left" target="_blank">MAP</a>
                  {else}
                    <a class="accessmap"
                      href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14"
                      target="_blank">MAP</a>
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
                    title="クリックで出品商品ページへリンクします">{$bidMachineIds[$machine.id].bid_title} 出品中
                    {*
              <br />最低入札金額 : {$bidMachineIds[$machine.id].min_price|number_format}円
              *}
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
                {*
          {if Auth::check('member') && !empty($machine.catalog_id)}
            <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$machine.catalog_id}"
              class="label catalog" target="_blank" title="クリックで電子カタログを閲覧できま">電子カタログ(会員のみ公開)</a>
          {/if}
          *}

                {if !empty($machine.catalog_id)}
                  <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$machine.catalog_id}" class="label catalog" target="_blank"
                    title="クリックで電子カタログを閲覧できま">電子カタログ</a>
                {/if}

                {*
          {if $machine.label_title}
            {if $machine.label_url}
              <a class="label org" href="{$machine.label_url}" target="_blank" style="background:{$machine.label_color};">{$machine.label_title}</a>
            {else}
              <div class="label org" style="background:{$machine.label_color};">{$machine.label_title}</div>
            {/if}
          {/if}
          *}
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
            {*
      <tr class="">
        <th>住所</th>
        <td>
          〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}
            {$company.addr1} {$company.addr2} {$company.addr3}
        </td>
      </tr>
      *}
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

        {*
  {if $machine.addr3}
    <h2 id="gmap_label">
      在庫場所のアクセスマップ
      <a class="map_link" href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m&z=14" target="_blank">大きな地図で見る</a>
    </h2>
    <div>
      <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
        src="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed&z=14"></iframe><br />
    </div>
  {/if}
  *}

        {*
  {if !empty($IPLogMachineList)}
    <h2 class="same_machine_label">最近チェックした機械</h2>
    <div class="same_area">
      <div class='image_carousel'>
      <div class='carousel_products'>
      {foreach $IPLogMachineList as $sm}
        <div class="same_machine">
          <a href="machine_detail.php?m={$sm.id}"
            onClick="ga('send', 'event', 'log_detail', 'checked', '{$sm.id}', 1, true);"
            >
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
        <div class="scrollRight"></div><div class="scrollLeft"></div>
      {/if}
    </div>
  {/if}
*}

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