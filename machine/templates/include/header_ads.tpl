{*** ads ***}
<div class="micro_banner_area">
  {$mAds.toshin = array('東信機工', 'ad_toshin.png', 'http://www.t-mt.com/')}
  {$mAds.endo = array('遠藤機械', 'banner_189.gif', 'http://www.endo-kikai.co.jp/')}
  {$mAds.kobayashi = array('小林機械', 'ad_kobayashi.png', 'http://www.kkmt.co.jp/')}
  {$mAds.tachikawa = array('立川商店', 'ad_tachikawa.png', 'http://www.tachikawa-kikai.com/')}
  {$mAds.hirai = array('平井鈑金機工', 'ad_hirai.png', 'http://www.hiraibankin.com/')}
  {$mAds.yushi = array('ユウシ', 'ad_yushi.png', 'http://www.yuushi.co.jp/index.html')}
  {$mAds.kusumoto = array('楠本機械', 'ad_kusumoto.png', 'http://www.e-kikai.com/kusumotokikai/')}
  {$mAds.sanwa = array('三和精機', 'ad_sanwa_02.gif', 'http://sanwa-seiki.jp/')}
  {$mAds.horikawa = array('堀川機械', 'ad_horikawa.png', 'http://www.e-kikai.com/horikawakikai/')}
  {$mAds.abc = array('エービーシー中古機事業部', 'ad_abc.gif', 'http://www.aida.co.jp/products/used.html')}
  {$mAds.smk = array('新明和機工', 'ad_smk.gif', 'http://www.k-smk.co.jp/')}
  {$mAds.ibuki = array('伊吹産業', 'ad_ibuki.png', 'http://www.ibuki-in.co.jp/')}
  {$mAds.teng = array('東京エンジニアリング', 'ad_t-eng.gif', 'http://www.t-eng.co.jp/')}
  {$mAds.mk = array('エム・ケイ', 'mk3.gif', 'http://www.matsubarakikai.com/')}
  {$mAds.mechany = array('メカニー', 'mechany.gif', 'http://www.mechany.com/')}
  {$mAds.asia = array('アジアマシナリー', 'asia.png', 'http://www.asia-machinery.co.jp/')}
  
  {$num = 9}
  
  {*
  {if !empty($largeGenreId) && array_intersect(array(1,2,3,4,6), (array)$largeGenreId)}
    <a href="http://www.go-dove.com/event-17805?utm_source=zenkiren.net&utm_medium=banner&utm_campaign=17805" target="_blank" class="first"
      onClick="_gaq.push(['_trackEvent', 'banner', 'micro', 'GoIndustry DoveBid Japan(micro)', 1, true]);"
      ><img class="banner" src="media/banner/ad_gdj_m.gif" /></a>
      {$num = $num-1}
  {else}
    {$mAds.gdj = array('GoIndustry DoveBid Japan(micro)', 'ad_gdj_m.gif', 'http://www.go-dove.com/event-17805?utm_source=zenkiren.net&utm_medium=banner&utm_campaign=17805')}
  {/if}
  *}
  
  {*
  {if !empty($largeGenreId) && array_intersect(array(1,7,10,11,12), (array)$largeGenreId)}
    <a href="http://www.go-dove.com/ja/event-17965/" target="_blank" class="first"
      onClick="_gaq.push(['_trackEvent', 'banner', 'micro', 'GoIndustry DoveBid Japan(micro)_02', 1, true]);"
      ><img class="banner" src="media/banner/ad_gdj_m_02.gif" /></a>
      {$num = $num-1}
  {else}
    {$mAds.gdj2 = array('GoIndustry DoveBid Japan(micro)_02', 'ad_gdj_m_02.gif', 'http://www.go-dove.com/ja/event-17965/')}
  {/if}
  *}
    
  <a href="https://www.deadstocktool.com/" target="_blank" class="first"
    onClick="_gaq.push(['_trackEvent', 'banner', 'micro', 'dst_03', 1, true]);"
    ><img class="banner" src="imgs/dst_03.jpg" /></a>
    
  {if (shuffle($mAds))}
    {foreach array_rand($mAds, $num) as $key}
      <a href="{$mAds[$key][2]}" target="_blank"{if $key@first && $num == 10} class="first"{/if}
        {* onClick="_gaq.push(['_trackEvent', 'banner', 'micro', '{$mAds[$key][0]}', 1, true]);" *}
        onClick="ga('send', 'event', 'banner', 'micro', '{$mAds[$key][0]}', 1, true);"
        ><img class="banner" src="media/banner/{$mAds[$key][1]}" alt="{$mAds[$key][0]}" /></a>
    {/foreach}
  {/if}
  <br class="clear"/>
</div>

