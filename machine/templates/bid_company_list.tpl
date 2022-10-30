{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  <script type="text/javascript">
    {literal}
      $(function() {
        $('.anchor_area a[href*=#]').click(function() {
          var target = $(this.hash);
          if (target) {
            var targetOffset = target.offset().top;
            $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
            return false;
          }
        });

        $('#map1 td.land').each(function() {
          var state = $(this).text();

          if ($('.anchor_area a[href*=#' + state + ']').text()) {
            console.log($('.anchor_area a[href*=#' + state + ']').text());
            $(this).html($('.anchor_area a[href*=#' + state + ']'));
          }
        });
        $('.anchor_area').hide();
      });
    </script>
    <style type="text/css">
      table.list {
        margin: 2px auto 12px 0;
      }

      table.list .company {
        width: 220px;
      }

      table.list .address {
        width: 240px;
      }

      table.list tr.contact,
      table.list td.contact {
        width: 100px;
        text-align: center;
      }

      table.list .tel,
      table.list .fax {
        width: 140px;
      }

      table.list td.tel,
      table.list td.fax {
        color: #C00;
        font-size: 16px;
      }

      table.list td.region {
        background: #FFF;
        border-width: 1px 0;
      }

      .anchor_area .region {
        display: inline-block;
        width: 70px;
        border-right: 4px double #333;
        padding-right: 6px;
        text-align: right;
      }

      .anchor_area .state {
        display: inline-block;
        padding-right: 6px;
      }

      .anchor_area div.state {
        color: #999;
      }

      /*** MAP ***/
      #map1 {
        margin: auto;
      }

      #map1 a {}

      #map1 td {
        padding: 6px 3px;
        text-align: center;
        color: #BBB;
      }

      #map1 td.frame {
        padding: 0;
        width: 20px;
        height: 10px;
      }

      #map1 td.land {
        background-color: #eef2bf;
        border: #999900 1px solid;
        vertical-align: middle;
      }

      #map1 td.sea {
        background-color: #f0f9ff;
      }

      #map1 td.cr01 {
        background: #99FF00;
      }

      #map1 td.cr02 {
        background: #CCFF99;
      }

      #map1 td.cr03 {
        background: #00FF3C;
      }

      #map1 td.cr04 {
        background: #FFFF99;
      }

      #map1 td.cr05 {
        background: #FFCC66;
      }

      #map1 td.cr06 {
        background: #66FFFF;
      }

      #map1 td.cr07 {
        background: #CCCCFF;
      }

      #map1 td.cr08 {
        background: #CCFFFF;
      }

      #map1 td.cr09 {
        background: #FFCCFF;
      }

      .bid_search_comment {
        font-size: 20px;
        font-weight: bold;
        color: #004675;
        text-align: center;
        width: auto;
        margin: 0 auto;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  {include "include/bid_timer.tpl"}

  <div class="bid_search_comment">地図・一覧より、最寄りの全機連会員を探していただき、入札のご依頼を行って下さい</div>
  {*
<div class="sp_area">
  <img class="" src="/imgs/bid_frow03_02.gif" usemap="#bidfrow"/>

  <map name="bidfrow">
    {if !empty($bidOpenId)}
      <area shape="rect" coords="0,0,240,201" href="bid_door.php?o={$bidOpenId}" alt="商品リスト">
    {/if}
    {if !empty($machineId)}
      <area shape="rect" coords="240,0,480,120" href="bid_detail.php?m={$machineId}" alt="商品詳細">
    {/if}
    <area shape="rect" coords="480,0,720,120" href="bid_company_list.php?o={$bidOpenId}&m={$machineId}" alt="Web入札会 全機連会員一覧">
  </map>
</div>
*}

  <table class="tablemap" id="map1">
    <tr>
      <td colspan="18" class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="15" class="sea"></td>
      <td colspan="2" class="land c01 cr01">北海道</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="18" class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="15" class="sea"></td>
      <td colspan="2" class="land c02 cr02">青森県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="15" class="sea"></td>
      <td class="land c05 cr02">秋田県</td>
      <td class="land c03 cr02">岩手県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="11" class="sea"></td>
      <td rowspan="2" class="land c17 cr04">石川県</td>
      <td colspan="3" class="sea"></td>
      <td class="land c06 cr02">山形県</td>
      <td class="land c04 cr02">宮城県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="11" class="sea"></td>
      <td class="land c16 cr04">富山県</td>
      <td colspan="2" class="land c15 cr04">新潟県</td>
      <td colspan="2" class="land c07 cr02">福島県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="10" class="sea"></td>
      <td colspan="2" class="land c18 cr04">福井県</td>
      <td rowspan="2" class="land c21 cr05">岐阜県</td>
      <td rowspan="2" class="land c20 cr04">長野県</td>
      <td class="land c10 cr03">群馬県</td>
      <td class="land c09 cr03">栃木県</td>
      <td rowspan="2" class="land c08 cr03">茨城県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="5" class="sea"></td>
      <td class="land c35 cr07">山口県</td>
      <td class="land c32 cr07">島根県</td>
      <td class="land c31 cr07">鳥取県</td>
      <td rowspan="2" class="land c28 cr06">兵庫県</td>
      <td class="land c26 cr06">京都府</td>
      <td colspan="2" class="land c25 cr06">滋賀県</td>
      <td colspan="2" class="land c11 cr03">埼玉県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td class="sea frame"> </td>
      <td rowspan="2" class="land c42 cr09">長崎県</td>
      <td rowspan="2" class="land c41 cr09">佐賀県</td>
      <td colspan="2" class="land c40 cr09">福岡県</td>
      <td class="sea"></td>
      <td class="land c34 cr07">広島県</td>
      <td class="land c33 cr07">岡山県</td>
      <td class="land c27 cr06">大阪府</td>
      <td class="land c29 cr06">奈良県</td>
      <td rowspan="2" class="land c24 cr05">三重県</td>
      <td class="land c23 cr05">愛知県</td>
      <td rowspan="2" class="land c22 cr05">静岡県</td>
      <td class="land c19 cr03">山梨県</td>
      <td class="land c13 cr03">東京都</td>
      <td rowspan="2" class="land c12 cr03">千葉県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td class="sea frame"> </td>
      <td rowspan="2" class="land c43 cr09">熊本県</td>
      <td class="land c44 cr09">大分県</td>
      <td colspan="4" class="sea"></td>
      <td colspan="2" class="land c30 cr06">和歌山県</td>
      <td class="sea"></td>
      <td colspan="2" class="land c14 cr03">神奈川県</td>
      <td class="sea frame"> </td>
    </tr>
    <tr>
      <td colspan="3" class="sea"></td>
      <td class="land c45 cr09">宮崎県</td>
      <td class="sea"></td>
      <td class="land c38 cr08">愛媛県</td>
      <td class="land c37 cr08">香川県</td>
      <td colspan="10" class="sea"></td>
    </tr>
    <tr>
      <td class="sea"></td>
      <td class="land c47 cr09">沖縄県</td>
      <td class="sea"></td>
      <td colspan="2" class="land c46 cr09">鹿児島県</td>
      <td class="sea"></td>
      <td class="land c39 cr08">高知県</td>
      <td class="land c36 cr08">徳島県</td>
      <td colspan="100px" class="sea"></td>
    </tr>
    <tr>
      <td colspan="18" class="sea"> </td>
    </tr>
  </table>

  <div class="anchor_area">
    {foreach $stateList as $s}
      {if $s@first || $s.region != $stateList[$s@index-1].region}
        <div class="region">{$s.region}</div>
      {/if}

      {if in_array($s.state, $addr1List)}
        <a class="state" href="{$smarty.server.REQUEST_URI}#{$s.state}">{$s.state}</a>
      {else}
        <div class="state">{$s.state}</div>
      {/if}
      {if !$s@last && $s.region != $stateList[$s@index+1].region}<br />{/if}
    {/foreach}
  </div>
  <table class='list contact'>


    {foreach $companyList as $c}
      {if empty($c.addr1)}{continue}{/if}
      {if $c@first || $companyList[$c@key-1]['addr1'] !=  $c.addr1}
      </table>
      <h3 id="{$c.addr1}">{$c.addr1}</h3>
      <table class='list contact'>
        <thead>
          <tr>
            <th class="company">会社名</th>
            <th class="representative">担当者</th>
            <th class="address">住所</th>
            <th class="tel">TEL</th>
            <th class="tel">FAX</th>
            {*
            <th class="website">Web</th>
            *}
            <th class="contact">お問い合せ</th>
          </tr>
        </thead>
      {/if}
      <tr>
        <td class='company'>
          <a href="/company_detail.php?c={$c.id}" target="_blank">{$c.company}</a>
        </td>
        <td class='representative'>{$c.officer}</td>
        <td class='address'>
          〒 {$c.zip}<br />{$c.addr1} {$c.addr2} {$c.addr3}
        </td>
        <td class='tel'>{$c.contact_tel}</td>
        <td class='fax'>{$c.contact_fax}</td>
        {*
      <td class='website'>{if !empty($c.website)}<a href="{$c.website}" target="_blank">◯</a>{/if}</td>
      *}
        <td class="contact">
          {if !empty($c.contact_mail)}
            <a class="contact" href="contact.php?c={$c.id}&b=1&o={$bidOpenId}&bm={$machineId}">お問い合せ</a>
          {/if}
        </td>
      </tr>
    {/foreach}
  </table>
{/block}