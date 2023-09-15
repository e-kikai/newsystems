{literal}
  <script type="text/javascript">
    $(function() {
      $('.anchor_area a[href*=#]').click(function() {
        var target = $(this.hash);
        if (target) {
          var targetOffset = target.offset().top;
          $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
          return false;
        }
      });
    });
  </script>
  <style>
    .machine_list.company td {
      padding: 8px;
    }

    .machine_list.company .machines .img {
      width: 137px;
    }

    .machine_list.company .img img {
      margin: auto;
    }

    .machine_list.company .company {
      width: 150px;
    }

    .machine_list.company .group {
      width: 160px;
    }

    .machine_list.company .count {
      width: 132px;
    }

    .machine_list.company .buttons {
      width: 90px;
    }

    .machine_list.company .img {
      padding: 0;
    }
  </style>
{/literal}

<div class='machine_full'>

  {*** アンカーリンク ***}
  <div class="filter_area anchor_area">
    <li>
      <span class="area_label">50音順</span>
    </li>
    {foreach $companyList as $c}
      {if !$c@index || B::get50onRow($c.company_kana) != B::get50onRow($companyList[$c@key-1].company_kana)}
        <li><a href="{$smarty.server.REQUEST_URI}#{B::get50onRow($c.company_kana)}">{B::get50onRow($c.company_kana)}</a>
        </li>
      {/if}
    {/foreach}
  </div>

  まとめて：
  <button class='contact_full_company' value='search'>問い合わせする</button>

  {if Auth::check('mylist')}
    {if $smarty.server.PHP_SELF == '/mylist_company.php'}
      <button class='mylist_delete_company' value='mylist'>マイリストから削除</button>
    {else}
      <button class='mylist_full_company' value='mylist'>マイリストに追加</button>
    {/if}
  {/if}
</div>

<div class='machine_list company'>
  <table class='machines'>
    <tr>
      <th class='checkbox'></th>

      {*
      {if preg_match('/company_list.php/', $smarty.server.PHP_SELF) }
        <th class='img'></th>
      {/if}
      *}
      <th class='img'></th>

      <th class="company">会社名</th>
      <th class='group'>所属団体</th>
      <th class='address'>住所・TEL・FAX</th>
      <th class='count'>在庫件数</th>
      <th class='buttons' class='reset'></th>
    </tr>

    {foreach $companyList as $c}
      <tr class='separator machine_{$c.id}'>
        {if !$c@index || B::get50onRow($c.company_kana) != B::get50onRow($companyList[$c@key-1].company_kana)}
          <td colspan="7">
            <h3 id="{B::get50onRow($c.company_kana)}">{B::get50onRow($c.company_kana)}</h3>
          </td>
        {/if}
      </tr>

      <tr class='machine machine_{$c.id}'>
        <td class='checkbox'>
          <input type='checkbox' class='machine_check' name='machine_check' value='{$c.id}' />
        </td>

        {*
        {if preg_match('/company_list.php/', $smarty.server.PHP_SELF) }
          <td class='img'>
            <a href='/company_detail.php?c={$c.id}'>
              {if !empty($c.top_img)}
                <img class="top_image hover lazy" src='imgs/blank.png'
                  data-original="{$_conf.media_dir}company/{$c.top_img}" alt="{$c.company}" title="{$c.company}" />
                  <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="" /></noscript>
                  <br />
              {/if}
              会社情報を見る
            </a>
          </td>
        {/if}
        *}
        <td class='img'>
          <a href='/company_detail.php?c={$c.id}'>
            {if !empty($c.top_img)}
              <img class="top_image hover lazy" src='imgs/blank.png' data-original="{$_conf.media_dir}company/{$c.top_img}"
                alt="{$c.company}" title="{$c.company}" />
              <noscript><img src="{$_conf.media_dir}machine/thumb_{$m.top_img}" alt="" /></noscript>
              <br />
            {/if}
            会社情報を見る
          </a>
        </td>

        <td class="company"><a href='/company_detail.php?c={$c.id}'>{$c.company}</a></td>
        <td class="group">{$c.rootname}<br />{$c.groupname}</td>
        <td class="address">
          〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $c.zip, $r)}{$r[1]}-{$r[2]}{else}{$c.zip}{/if}<br />
          {$c.addr1}{$c.addr2}{$c.addr3}<br />
          TEL: {$c.contact_tel}<br />
          FAX: {$c.contact_fax}
        </td>
        <td class='count'>
          <span class='count_no'>{$c.count|default:0|number_format}</span>件<br />
          {if preg_match("/company_list/", $smarty.server.REQUEST_URI)}
            <a href="search.php?c={$c.id}">
            {else}
              <a
                href='{$smarty.server.REQUEST_URI|regex_replace:"/\&?c=[0-9]+/":""}{if preg_match("/\?/", $smarty.server.REQUEST_URI)}&{else}?{/if}c={$c.id}'>
              {/if}
              在庫一覧
            </a>
        </td>
        <td class="buttons">
          <a class='contact' href='contact.php?c[]={$c.id}'>問い合わせ</a>
          {if Auth::check('mylist') && $smarty.server.PHP_SELF != '/mylist_company.php'}
            <button class='mylist_company' value='{$c.id}'>マイリスト</button>
          {/if}
        </td>
      </tr>
    {/foreach}
  </table>
</div>