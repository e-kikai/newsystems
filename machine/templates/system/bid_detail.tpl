{extends file='include/layout.tpl'}

{block name='header'}
<meta name="description" content="
{if !empty({$machine.capacity}) && !empty({$machine.capacity_label})}{$machine.capacity_label}:{$machine.capacity}{$machine.capacity_unit} | {/if}
{if !empty({$machine.year})}年式:{$machine.year} | {/if}
{if !empty({$machine.addr1})}在庫場所:{$machine.addr1} | {/if}
{if !empty({$others})}{$others} | {/if}
{$machine.spec}
{if $machine.commission == 1} 試運転可{/if}
" />
<meta name="keywords" content="{$machine.name},{$machine.hint},{$machine.maker},{$machine.model},{$machine.company},{$machine.addr1},中古機械,全機連,マシンライフ" />

<link href="{$_conf.site_uri}{$_conf.css_dir}detail.css" rel="stylesheet" type="text/css" />
<link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="{$_conf.libjs_uri}/jquery.jqzoom-core.js"></script>
<link href="{$_conf.libjs_uri}/css/jquery.jqzoom.css" rel="stylesheet" type="text/css" />

{literal}
<script type="text/JavaScript">
$(window).load(function() {
    //// @ba-ta 2011/12/27 画像処理 ////
    $(".zoom").jqzoom({
        zoomType: 'standard',  
        lens:true,  
        preloadImages: true,  
        alwaysOn:false,  
        zoomWidth: 400,  
        zoomHeight: 300,  
        xOffset:24,  
        yOffset: 0,  
        position:'right',
        title: false
    }); 
    
    $(".zoom").click(function() {
        window.open($(this).attr('href'));
    });
        
    // ロード時に、拡大縮小を生成
    $('.img a:first').click();
    
    //// スクロール ////
    $('a[href*=#]').click(function() {
        var target = $(this.hash);
        if (target) {
            var targetOffset = target.offset().top;
            $('html,body').animate({scrollTop: targetOffset},400,"easeInOutQuart");
            return false;
        }
    });
    
    //// 入札処理 ////
    $('button.bid').click(function() {
        var data = {
            'bid_machine_id': $.trim($('input.bid_machine_id').val()),
            
            'amount': $.trim($('input.amount').val()),
            'charge': $.trim($('input.charge').val()),
            'comment': $.trim($('input.comment').val()),
        };
        
        //// 入力のチェック ////
        var e = '';
        $('input[required]').each(function() {
            if ($(this).val() == '') {
                e += "必須項目が入力されていません\n\n";
                return false;
            }
        });
        
        if (!data['amount']) {
            e += '入札金額が入力されていません\n';
        } else if (data['amount'] < parseInt($('input.min_price').val())) {
            e += "入札金額が、最低入札金額より小さく入力されています\n";
            e += "最低入札金額 : " + parseInt($('input.min_price').val()) + '円';
        } else if ((data['amount'] % parseInt($('input.rate').val())) != 0) {
            e += '入札金額が、入札レートの倍数ではありません\n';
        }
        
        //// エラー表示 ////
        if (e != '') { alert(e); return false; }
        
        // 送信確認
        if (!confirm('この内容で入札します。よろしいですか。')) { return false; }
        
        if (data['amount'] > parseInt($('input.min_price').val()) * 5) {
            if (!confirm("入札金額が最低入札金額の5倍を超えています。\nこの内容で入札してよろしいですか。")) { return false; }
        }
        
        $('button.bid').attr('disabled', 'disabled').text('保存処理中');
        
        $.post('/admin/ajax/bid.php', {
            'target': 'member',
            'action': 'bid',
            'data'  : data,
        }, function(res) {
            if (res != 'success') {
                $('button.bid').removeAttr('disabled').text('入札');
                alert(res);
                return false;
            }
            
            // 登録完了
            alert('入札が完了しました');
            location.href = '/admin/bid_list.php?o=' + $('input.bid_open_id').val();
            return false;
        }, 'text');
        
        return false;
    });
});
</script>
<style type="text/css">
.others {
  display: inline-block;
}

button.bid {
  width: 80px;
  margin-left: 16px;
}

table.spec.form {
  width: 552px;
}

table.spec.form th {
  background: #556B2F;
}

a.contact {
  margin-left: 16px;
}

.bid_open {
  margin: 0 0 4px 0;
  width: 544px;
}
</style>
{/literal}
{/block}

{block name='main'}
{if !empty($machine)}
<div class='detail_container'>
  {*** 画像 ***}
  <div class="img_area">
  {if empty($machine.top_img) && empty($machine.imgs)}
    {*
    <div class="message">画像は登録されていません</div>
    *}
    <img class='noimage' src='./imgs/noimage.png' alt="{$alt}" />
  {else}
    <div class='top_image'>
      <div id='viewport'>
      {if !empty($machine.top_img)}
        <a class="zoom" href="{$_conf.media_dir}machine/{$machine.top_img}" rel='gal1'>
          <img class="zoom_img" src="{$_conf.media_dir}machine/{$machine.top_img}" alt="{$alt}" />
        </a>
      {/if}
      </div>
    </div>
  
    <div class='images'>
    {if !empty($machine.imgs)}
      {if !empty($machine.top_img)}
        <a class="img" href='javascript:void(0);'
           rel="{literal}{{/literal}
             gallery:'gal1',
             smallimage:'{$_conf.site_uri}{$_conf.media_dir}machine/{$machine.top_img}',
             largeimage:'{$_conf.site_uri}{$_conf.media_dir}machine/{$machine.top_img}'
           {literal}}{/literal}">
          <img src="{$_conf.media_dir}machine/thumb_{$machine.top_img}" alt="{$alt}" />
        </a>
      {/if}
    
      {foreach $machine.imgs as $i}
        <a class="img" href='javascript:void(0);'
           rel="{literal}{{/literal}
             gallery:'gal1',
             smallimage:'{$_conf.media_dir}machine/{$i}',
             largeimage:'{$_conf.media_dir}machine/{$i}'
           {literal}}{/literal}">
          <img src="{$_conf.media_dir}machine/thumb_{$i}" alt="{$alt}" />
        </a>
      {/foreach}
    {/if}
    </div>
  {/if}
  
  {*** youtube ***}
  {if !empty($machine.youtube)}
    <div class="youtube">
      <iframe width="400" height="300" 
        src="https://www.youtube.com/embed/{'/http:\/\/youtu.be\//'|preg_replace:'':$machine.youtube}?rel=0" 
        frameborder="0" allowfullscreen></iframe>
    </div>
  {/if}
  
  </div>
  
  <div class="spec_area">
    {*
    {include "include/bid_announce.tpl"}
    *}
    {*
    <table class='machine'>
      <tr>
        <th class="no">入札商品ID</th>    
        <th class='name'>機械名</th>
        <th class='maker'>メーカー</th>
        <th class='model'>型式</th>
        <th class='year'>年式</th>
      </tr>
      <tr class='machine machine_{$machine.id}'>
        <td class='bid_machine_id'>{$machine.list_no}</td>
        <td class='name'>{$machine.name}</td>
        <td class='maker'>{$machine.maker}</td>
        <td class='model'>{$machine.model}</td>
        <td class='year'>{$machine.year}</td>
      </tr>
    </table>
    *}
    <table class="spec">
      <tr class="" >
        <th>出品番号</th>
        <td class="bid_machine_id">{* {$machine.id} - *}{$machine.list_no}</td>
      </tr>
      <tr class="" >
        <th>機械名</th>
        <td>{$machine.name}</td>
      </tr>
      <tr class="" >
        <th>メーカー</th>
        <td>{$machine.maker}</td>
      </tr>
      <tr class="" >
        <th>型式</th>
        <td>{$machine.model}</td>
      </tr>
      <tr class="" >
        <th>年式</th>
        <td>{$machine.year}</td>
      </tr>
    </table>
    
    <table class="spec">
      {if !empty($machine.capacity_label)}
        <tr class="capacity number" >
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
            <div class="others">{$machine.spec|escape|regex_replace:"/(\s\|\s|\,\s)/":'</div> | <div class="others">' nofilter}</div>
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
      
      <tr class="carryout_note">
        <th>引取留意事項</th>
        <td>{$machine.carryout_note}</td>
      </tr>
      
      <tr class="">
        <th>在庫場所</th>
        <td class='location'>
          <a href="{$smarty.server.REQUEST_URI}#gmap2">
          <div class="location_address">{$machine.addr1} {$machine.addr2} {$machine.addr3}</div>
          {if $machine.location}({$machine.location}){/if}
          </a>
        </td>
      </tr>
      
      <tr class="price">
        <th>最低入札金額</th>
        <td class="detail_min_price">{$machine.min_price|number_format}円</td>
      </tr>
      
      <tr class="label_area">
        <td colspan="2">
          {if $machine.commission == 1}<div class="label commission">試運転可</div>{/if}
          {if !empty($machine.pdfs)}
            {foreach $machine.pdfs as $key => $val}
              <a href="{$_conf.media_dir}machine/{$val}"
                class="label pdf" target="_blank">PDF:{$key}</a>
            {/foreach}
          {/if}
        </td>
      </tr>
    </table>
    
    {if in_array($bidOpen.status, array('carryout', 'after'))}
      <h2>入札詳細</h2>
      
      {if !empty($bidBidList)}
      <table class="spec bid">
        <tr>
          <th class="no">ID</th>
          <th>入札会社</th>
          <th>入札金額</th>
          <th>同額No</th>
          <th class="created_at">入札日時</th>
        </tr>
        
        {foreach $bidBidList as $b}
          <tr>
            <td class="no">{$b.id}</td>
            <td>{$b.company}</td>
            <td class="price">{$b.amount|number_format}円</td>
            <td class="price">{$b.sameno}</td>
            <td class="created_at">{$b.created_at|date_format:'%Y/%m/%d %H:%M:%S'}</td>
          </tr>
        {/foreach}
  
      </table>
      {else}
        <div>入札はありませんでした</div>
      {/if}
    {/if}
    
    <h2>出品会社情報</h2>
    <table class="spec">
      <tr class="">
        <th>会社名</th>
        <td>
          <a href='company_detail.php?c={$machine.company_id}'>{$company.company}</a>
          <a class="contact" href="contact.php?c={$m.company_id}" target="_blank">お問い合せ</a>
        </td>
      </tr>
      <tr class="">
        <th>住所</th>
        <td>
          〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}<br />
           {$company.addr1} {$company.addr2} {$company.addr3}
        </td>
      </tr>
      <tr class="">
        <th>お問い合せTEL</th>
        <td>{$company.contact_tel}</td>
      </tr>
      <tr class="">
        <th>お問い合せFAX</th>
        <td>{$company.contact_fax}</td>
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
    
    {if $machine.addr3}
    <iframe id="gmap2" frameborder="0" scrolling="no" marginheight="0" marginwidth="0"
      src="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=s_q&amp;hl=ja&amp;geocode=ie=UTF8&amp;t=m&amp;output=embed"></iframe><br />
    <a href="https://maps.google.co.jp/maps?f=q&amp;q={$machine.addr1|escape:"url"}{$machine.addr2|escape:"url"}{$machine.addr3|escape:"url"}+({$machine.location|escape:"url"})&source=embed&amp;hl=ja&amp;geocode=&amp;ie=UTF8&amp;t=m" style="color:#0000FF;text-align:left" target="_blank">大きな地図で見る</a> 
    {/if}
  </div>
  <br class="clear" />
</div>
{else}
    <div class="error_mes">
      指定された方法では、機械情報の特定ができませんでした<br />
      誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
    </div>
{/if}

{/block}
