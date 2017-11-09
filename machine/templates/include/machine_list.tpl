<!-- Google Maps APL ver 3 -->
<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
<link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

<script src="http://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>
{literal}
<script type="text/javascript">
$(function() {
    $('.contact.none').click(function() {
        alert("この機械を登録している会社のメールアドレスが登録されていないため、\n" +
        "メールフォームでの問い合わせが行えません。\n\n" +
        "お手数ですが、電話・FAXでお問い合わせお願いいたします。");

        return false;
    });
});
</script>
<style>
.contact.none {
  display: inline-block;
  border: 1px solid #AAA;
  background: #888;
  width: 68px;
  height: 32px;
  font-size: 13px;
  margin: 4px auto;
  padding: 4px 0;
  vertical-align: middle;
  color: white;
  cursor: pointer;
  border-radius: 0.3em;
  line-height: 1.3;
  text-align: center;
}

.machine_list.imagelist .contact.none {
  width: 130px;
  height: 22px;
  padding: 0;
  line-height: 22px;
}

.machine_list.map .contact.none {
  width: 103px;
  height: 22px;
  padding: 0;
  line-height: 22px;
}
</style>
{/literal}

<div class='machine_list list'>
  {*** 機械検索共通ヘッダ ***}
  {include file="include/machine_header.tpl"}

  {*** 一括問い合わせ／マイリスト ***}
  {include file="include/mylist_buttons.tpl"}

  <table class='machines'>
    <tr>
      <th class='checkbox'></th>
      <th class='img'>画像</th>
      <th class='maker'>メーカー</th>
      <th class='model'>型式</th>
      <th class='year'>年式</th>
      <th class='location'>在庫場所</th>
      <th class='company_info'>掲載会社</th>
      <th class='buttons' class='reset'></th>
    </tr>

    {foreach $machineList as $m}
    <tbody class="machine" data-id="{$m.id}">

    {* セパレータ *}
    <tr class='separator'><td colspan='8'></td></tr>

    <tr>
      <td class='checkbox' rowspan='2'>
        <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
      </td>
      <td class='img' rowspan='2'>
        <div class='hidden no'>{$smarty.foreach.ml.index|string_format:"%04d"}</div>
        <div class='hidden genre_id'>{$m.genre_id}</div>
        <div class='hidden model2'>{'/[^A-Z0-9]/'|preg_replace:'':($m.model|mb_convert_kana:'KVrn'|strtoupper)}</div>
        <div class='hidden created_at'>{$m.created_at|strtotime}</div>
        <div class="hidden pure_addr">{$m.addr1} {$m.addr2} {$m.addr3}</div>
        <div class="hidden zoom_addr">{$m.addr1} {$m.addr2}</div>
        <div class="hidden lat">{$m.lat}</div>
        <div class="hidden lng">{$m.lng}</div>

        {*
        {if $m.created_at|strtotime > '-7day'|strtotime}<div class='new'>新着</div>{/if}
        *}


        {if empty($m.deleted_at)}
          <div class='img_area'>
            <a href='/machine_detail.php?m={$m.id}'>
              <div class='name'>{$m.name}</div>
              {if !empty($m.top_img)}
                <img class="top_image hover lazy" src='imgs/blank.png'
                  data-original="media/machine/{$m.top_img}"
                  alt="{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
                <noscript><img src="media/machine/{$m.top_img}" alt="" /></noscript>
              {else}
                <img class='top_image noimage' src='./imgs/noimage.png'
                  alt="{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
              {/if}
            </a>
          </div>
        {else}
          <div class='name'>{$m.name}</div>
        {/if}
      </td>

      <td class='maker'>{$m.maker}</td>
      <td class='model'>{$m.model}</td>
      <td class='year'>{$m.year}</td>
      <td class='locations'>
        {if $m.addr1}<div class="addr1">{$m.addr1}</div>{/if}
        {if $m.location}(<span class="location">{$m.location}</span>){/if}
      </td>
      <td class='company_info'>
        <div class='company'>
          <a href='/company_detail.php?c={$m.company_id}'>{$m.company}</a>
        </div>
        <div class='tel'>TEL : {$m.contact_tel}</div>
        <div class='fax'>FAX : {$m.contact_fax}</div>
      </td>
      <td class='buttons'>
        {if empty($m.deleted_at)}
          {if empty($m.contact_mail)}
            <div class='contact none'>問い<br />合わせ</div>
          {else}
            <a class='contact' href='/contact.php?m={$m.id}'>問い<br />合わせ</a>
          {/if}
          {if Auth::check('mylist')}
            {if !preg_match('/mylist.php/', $smarty.server.PHP_SELF)}
              <button class='mylist' value='{$m.id}'>マイリスト<br />追加</button>
            {/if}
          {/if}
        {else}
          売却日 : {$m.deleted_at|date_format:'%Y/%m/%d'}
        {/if}
      </td>

    </tr>

    {* 能力枠 *}
    <tr class='machine_spec'>
      <td class='spec' colspan='6'>
        {if !empty($m.spec_labels) || !empty($m.capacity_label)}
          <table class="others">

            {* 主能力 *}
            <tr>
              {if !empty($m.capacity_label)}
                <th class="capacity_label">{$m.capacity_label}</th>
              {/if}
              {foreach $m.spec_labels as $d}
                <th class="others_{$d@key}_label {$d.type}">{$d.label}</th>
              {/foreach}
            </tr>
            <tr>
              {if !empty($m.capacity_label)}
                <td class="number">
                  {if empty($m.capacity)}
                    -
                  {else}
                    <span class="capacity">{$m.capacity}</span><span class="capacity_unit">{$m.capacity_unit}</span>
                  {/if}
                </td>
              {/if}

              {foreach $m.spec_labels as $d}
                <td class="others_{$d@key} {$d.type}">
                  {if empty($m.others[$d@key])}
                    -
                  {elseif $d.type == 'x2'}
                    {if empty($m.others[$d@key][0]) || empty($m.others[$d@key][1])}
                      -
                    {else}
                      {$m.others[$d@key][0]} × {$m.others[$d@key][1]}{$d.unit}
                    {/if}
                  {elseif $d.type == 'x3'}
                    {if empty($m.others[$d@key][0]) || empty($m.others[$d@key][1]) || empty($m.others[$d@key][2])}
                      -
                    {else}
                      {$m.others[$d@key][0]} × {$m.others[$d@key][1]} × {$m.others[$d@key][2]}{$d.unit}{$d.unit}
                    {/if}
                  {elseif $d.type == 'c3'}
                    {if empty($m.others[$d@key][0]) || empty($m.others[$d@key][1]) || empty($m.others[$d@key][2])}
                      -
                    {else}
                      {$m.others[$d@key][0]} : {$m.others[$d@key][1]} : {$m.others[$d@key][2]}{$d.unit}
                    {/if}
                  {elseif $d.type == 't2'}
                    {if empty($m.others[$d@key][0]) && empty($m.others[$d@key][1])}
                      -
                    {else}
                      {$m.others[$d@key][0]} ～ {$m.others[$d@key][1]}{$d.unit}
                    {/if}
                  {elseif $d.type == 'nc'}
                    {$m.others[$d@key]['maker']} {$m.others[$d@key]['model']}
                  {else}
                    {$m.others[$d@key]}{$d.unit}
                  {/if}
                </td>
              {/foreach}
            </tr>
          </table>
        {/if}

        {*** ラベル枠 ***}
        {if $m.view_option == 2}<div class="label vo2">商談中</div>{/if}
        {if $m.commission == 1}<div class="label commission">試運転可</div>{/if}
        {if !empty($m.pdfs)}
          {foreach $m.pdfs as $key => $val}
            <a href="{$_conf.media_dir}machine/{$val}"
              class="label pdf" target="_blank">PDF:{$key}</a>
          {/foreach}
        {/if}

        {*
        {if Auth::check('member') && !empty($m.catalog_id)}
          <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$m.catalog_id}"
            class="label catalog" target="_blank">電子カタログ(会員のみ公開)</a>
        {/if}
        *}

        {if !empty($m.catalog_id)}
          <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$m.catalog_id}"
            class="label catalog" target="_blank">電子カタログ</a>
        {/if}

        {$m.spec}
      </td>
    </tr>
    </tbody>
    {/foreach}
  </table>
</div>

{*** ページャ ***}
{include file="include/pager.tpl"}

<div class='img_container' style="display:none;">

  {*** 一括問い合わせ／マイリスト ***}
  {include file="include/mylist_buttons.tpl"}

  <table class='machines machine_list imagelist'>
    {foreach from=$machineList item=m name='ml'}

    {if empty($m.top_img)}{continue}{/if}

    <tbody class="img_machine" data-id="{$m.id}">
    <tr>
      <td class='checkbox'>
        <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
      </td>
      <td class='data'>
        <div class='status'>
          <div class='hidden no'>{$m@index|string_format:"%04d"}</div>

          <a class='zoom' href='/machine_detail.php?m={$m.id}'>
            <span class='name'>{$m.name}</span>
            <span class='maker'>{$m.maker}</span>
            <span class='model'>{$m.model}</span>
          </a>
          {if !empty($m.year)}
          <div class='year'>{$m.year}年製</div>
          {/if}

          <div class='company'>
           <a href='/company_detail.php?c={$m.company_id}'>{$m.company}</a>
          </div>
          <div class='tel'>TEL : {$m.contact_tel}</div>
          <div class='fax'>FAX : {$m.contact_fax}</div>

          {if empty($m.deleted_at)}
            {if empty($m.contact_mail)}
              <div class='contact none'>問い合わせする</div>
            {else}
              <a class='contact' href='/contact.php?m={$m.id}'>問い合わせ</a>
            {/if}
            {if Auth::check('mylist')}
              {if !preg_match('/mylist.php/', $smarty.server.PHP_SELF)}
                <button class='mylist' value='{$m.id}'>マイリスト</button>
              {/if}
            {/if}
          {else}
            売却日 : {$m.deleted_at|date_format:'%Y/%m/%d'}
          {/if}
        </div>

        <div class='image_carousel'>
        <ul class='imgs jcarousel-skin-tango'>
          <li>
            <a class='zoom' href='/machine_detail.php?m={$m.id}'>
              {if !empty($m.top_img)}
                <img class="top_image lazy" src='imgs/blank.png' data-original="media/machine/{$m.top_img}" alt="" />
                <noscript><img src="media/machine/{$m.top_img}" alt="" /></noscript>
              {else}
                <img class='top_image noimage' src='./imgs/noimage.png' />
              {/if}
            </a>
          </li>

          {if !empty($m.imgs)}
            {foreach $m.imgs as $i}
              <li>
                <a class='zoom' href='/machine_detail.php?m={$m.id}'>
                  <img class="lazy" src='imgs/blank.png' data-original="media/machine/{$i}" alt="" />
                  <noscript><img src="media/machine/{$i}" alt="" /></noscript>
                </a>
              </li>
            {/foreach}
            <img  class='triangle' src='./imgs/triangle2.gif' />
          {/if}

          {if !empty($m.youtube)}
            <li class="youtube">
              <button class="movie" value="{'/http:\/\/youtu.be\//'|preg_replace:'':$m.youtube}">動画の再生</button>
            </li>
          {/if}
        </ul>
        </div>
      </td>
    </tr>

    <tr class='separator'><td colspan='2'></td></tr>
    </tbody>

    {/foreach}
  </table>
</div>

{*** 地図で表示 ***}
<div class='map_container' style="display:none;">
  {*** GoogleMap ***}
  <div id="gmap"></div>
  <div class='machine_list map'>
    {foreach $machineList as $m}
    <div class='map_machine' data-id="{$m.id}">
      <div class='status'>
        <div class='hidden no'>{$m@index|string_format:"%04d"}</div>

        <div class='name'>{$m.name}</div>
        <div class='maker'>{$m.maker}</div>
        <div class='model'>{$m.model}</div>
        <div class='hidden year'>{$m.year}</div>

        {if empty($m.deleted_at)}
          {if empty($m.contact_mail)}
            <div class='contact none'>問い合わせ</div>
          {else}
            <a class='contact' href='/contact.php?m={$m.id}'>問い合わせ</a>
          {/if}
          {if Auth::check('mylist')}
            {if !preg_match('/mylist.php/', $smarty.server.PHP_SELF)}
              <button class='mylist' value='{$m.id}'>マイリスト</button>
            {/if}
          {/if}
        {else}
          売却日 : {$m.deleted_at|date_format:'%Y/%m/%d'}
        {/if}
      </div>

      <div class='company_info'>
        <a href='/machine_detail.php?m={$m.id}'>
          {if !empty($m.top_img)}
            <img class="top_image lazy" src='imgs/blank.png' data-original="media/machine/{$m.top_img}" alt="" />
            <noscript><img src="media/machine/{$m.top_img}" alt="" /></noscript>
          {else}
            <img class='top_image noimage' src='./imgs/noimage.png' />
          {/if}
        </a>

        <div class='company'><a href='/company_detail.php?c={$m.company_id}'>{$m.company}</a></div>
      </div>

      <div style='clear:both;'></div>
    </div>
    {/foreach}

  </div>
</div>

{*** 会社別一覧 ***}
<div class='company_container' style="display:none;">
  {include file="include/machine_company.tpl"}
  {*
  <div class='machine_full'>
    まとめて：
    <button class='contact_full_company' value='search'>問い合わせする</button>

    {if Auth::check('mylist')}
      {if $smarty.server.PHP_SELF == '/mylist_company.php'}
        <button class='mylist_delete_company' value='mylist'>マイリストから削除</button>
      {else}
        <button class='mylist_full_company' value='mylist'>マイリストに追加</button>
      {/if}
    {/if}
    <input type='checkbox' id='machine_check_full' name='machine_check_full' value='' /><label for='machine_check_full'>
      すべての会社をチェック
    </label>
  </div>
  <div class='machine_list company'>
    <table class='machines'>
      <tr>
        <th class='checkbox'></th>
        <th class='img'></th>
        <th class='company_info'>掲載会社</th>
        <th class='count'>在庫件数</th>
        <th class='opening'>営業時間 定休日</th>
        <th class='number'>古物許可番号</th>
        <th class='buttons' class='reset'></th>
      </tr>

      {foreach $companyList as $c}
        <tr class='separator machine_{$c.id}'><td colspan='7'></td></tr>

        <tr class='machine machine_{$c.id}'>
          <td class='checkbox'>
            <input type='checkbox' class='machine_check' name='machine_check' value='{$c.id}' />
          </td>
          <td class='img'>
            <a href='/company_detail.php?c={$c.id}'>
              {if isset($c.top_img)}
                <img class="top_image" src="media/company/{$c.top_img}"
                  alt="{$c.company}" title="{$c.company}" /><br />
              {/if}
              会社情報を見る
            </a>
          </td>

          <td class='company_info'>
            <div class='company'>
              <a href='/company_detail.php?c={$c.id}'>{$c.company}</a>
            </div>
            <div class='address'>
              〒{$c.zip}<br />
              {$c.addr1}{$c.addr2}{$c.addr3}
            </div>
            <div class='tel'>
              TEL : {$c.contact_tel}<br />
              FAX : {$c.contact_fax}
            </div>
          </td>
          <td class='count'><strong class='machine_count'>
            {$c.count|default:0}</strong>件<br />
            <a href="/machine_list.php?c={$c.id}">在庫一覧</a>
          </td>

          <td class='opening'>{$c.infos.opening}<br />{$c.infos.holiday}</td>
          <td class='number'>{$c.infos.license}</td>
          <td class='buttons'>
            {if empty($c.contact_mail)}
              <div class='contact none'>問い合わせする</div>
            {else}
              <a class='contact' href='contact.php?c[]={$c.id}'>問い合わせする</a>
            {/if}
            {if Auth::check('mylist')}
              {if !preg_match('/mylist_company.php/', $smarty.server.PHP_SELF)}
                <button class='mylist' value='{$m.id}'>マイリスト追加</button>
              {/if}
            {/if}
          </td>
        </tr>
      {/foreach}
    </table>
  </div>
  *}
</div>
