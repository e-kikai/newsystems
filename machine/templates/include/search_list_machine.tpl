<tbody class="machine" data-id="{$m.id}">

{* セパレータ *}
<tr class='separator'><td colspan='8'></td></tr>

<tr>
  <td class='checkbox' rowspan='2'>
    <input type='checkbox' class='machine_check' name='machine_check' value='{$m.id}' />
  </td>
  <td class='img' rowspan='2'>
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
              alt="中古{$m.name} {$m.maker} {$m.model}" title="{$m.name} {$m.maker} {$m.model}" />
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
    <div class='tel'>TEL: {$m.contact_tel}</div>
    <div class='fax'>FAX: {$m.contact_fax}</div>
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
              {elseif !empty($os[$d.type])}
                {foreach $os[$d.type][0] as $key}
                  {$m.others[$d@key][$key]}{if !($key@last)}{$os[$d.type][1]}{/if}
                {/foreach}
                {$d.unit}
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
    {if Auth::check('member') && !empty($m.catalog_id)}
      <a href="{$_conf.catalog_uri}/catalog_pdf.php?id={$m.catalog_id}"
        class="label catalog" target="_blank">電子カタログ(会員のみ公開)</a>
    {/if}
    
    {$m.spec}
  </td>
</tr>
</tbody>
