{*** ads ***}
<div class="micro_banner_area">
  {$mAds.toshin = array('東信機工', 'ad_toshin.png', 'https://www.t-mt.com/')}
  {$mAds.endo = array('遠藤機械', 'banner_189.gif', 'https://www.endo-kikai.co.jp/')}
  {$mAds.kobayashi = array('小林機械', 'ad_kobayashi.png', 'https://www.kkmt.co.jp/')}
  {$mAds.tachikawa = array('立川商店', 'ad_tachikawa.png', 'http://www.tachikawa-kikai.com/')}
  {$mAds.hirai = array('平井鈑金機工', 'ad_hirai.png', 'http://www.hiraibankin.com/')}
  {* {$mAds.yushi = array('ユウシ', 'ad_yushi.png', 'https://www.yuushi.co.jp/index.html')} *}
  {* {$mAds.kusumoto = array('楠本機械', 'ad_kusumoto.png', 'https://kusumotokikai.e-kikai.com/')} *}
  {$mAds.kusumoto = array('楠本機械', 'ad_kusumoto.png', 'https://kusumotokikai.co.jp/')}
  {$mAds.sanwa = array('三和精機', 'ad_sanwa_02.gif', 'https://sanwa-seiki.jp/')}
  {$mAds.horikawa = array('堀川機械', 'ad_horikawa.png', 'https://horikawakikai.e-kikai.com/')}
  {* {if strtotime("2018/04/01 00:00:00") > time()}
    {$mAds.abc = array('エービーシー中古機事業部', 'ad_abc.gif', 'http://www.aida.co.jp/products/used.html')}
  {else}
    {$mAds.abc = array('アイダエンジニアリング株式会社 中古機グループ', 'ad_aida.gif', 'http://www.aida.co.jp/products/used.html')}
  {/if} *}
  {$mAds.abc = array('アイダエンジニアリング株式会社 中古機グループ', 'ad_aida.gif', 'https://www.aida.co.jp/products/used.html')}

  {$mAds.smk = array('新明和機工', 'ad_smk.gif', 'http://www.k-smk.co.jp/')}
  {$mAds.ibuki = array('伊吹産業', 'ad_ibuki.png', 'http://www.ibuki-in.co.jp/')}
  {$mAds.teng = array('東京エンジニアリング', 'ad_t-eng.gif', 'http://www.t-eng.co.jp/')}
  {$mAds.mk = array('エム・ケイ', 'mk4.gif', 'http://www.matsubarakikai.com/')}
  {$mAds.mechany = array('メカニー', 'mechany.gif', 'https://www.mechany.com/')}
  {$mAds.asia = array('アジアマシナリー', 'asia.png', 'https://www.asia-machinery.co.jp/')}

  {$mAds.mori = array('森鉄工所', 'mori.gif', 'https://moritekkousho.jp/')}
  {$num = 10}

  {*
  {if !empty($largeGenreId) && array_intersect(array(1,2,3,4,6), (array)$largeGenreId)}
    <a href="http://www.go-dove.com/event-17805?utm_source=zenkiren.net&utm_medium=banner&utm_campaign=17805" target="_blank" class="first"
      onClick="_gaq.push(['_trackEvent', 'banner', 'micro', 'GoIndustry DoveBid Japan(micro)', 1, true]);"
      ><img class="banner" src="{$_conf.media_dir}banner/ad_gdj_m.gif" /></a>
      {$num = $num-1}
  {else}
    {$mAds.gdj = array('GoIndustry DoveBid Japan(micro)', 'ad_gdj_m.gif', 'http://www.go-dove.com/event-17805?utm_source=zenkiren.net&utm_medium=banner&utm_campaign=17805')}
  {/if}
  *}

  {*
  {if !empty($largeGenreId) && array_intersect(array(1,7,10,11,12), (array)$largeGenreId)}
    <a href="http://www.go-dove.com/ja/event-17965/" target="_blank" class="first"
      onClick="_gaq.push(['_trackEvent', 'banner', 'micro', 'GoIndustry DoveBid Japan(micro)_02', 1, true]);"
      ><img class="banner" src="{$_conf.media_dir}banner/ad_gdj_m_02.gif" /></a>
      {$num = $num-1}
  {else}
    {$mAds.gdj2 = array('GoIndustry DoveBid Japan(micro)_02', 'ad_gdj_m_02.gif', 'http://www.go-dove.com/ja/event-17965/')}
  {/if}
  *}

  {*
  <a href="https://www.deadstocktool.com/" target="_blank" class="first"
    onClick="_gaq.push(['_trackEvent', 'banner', 'micro', 'dst_03', 1, true]);"
    ><img class="banner" src="imgs/dst_03.jpg" /></a>
  *}

  {if (shuffle($mAds))}
    {foreach array_rand($mAds, $num) as $key}
      <a href="{$mAds[$key][2]}" target="_blank" {if $key@first && $num == 10} class="first" {/if}
        {* onClick="_gaq.push(['_trackEvent', 'banner', 'micro', '{$mAds[$key][0]}', 1, true]);" *}
        onClick="ga('send', 'event', 'banner', 'micro', '{$mAds[$key][0]}', 1, true);"><img class="banner"
          src="{$_conf.media_dir}banner/{$mAds[$key][1]}" alt="{$mAds[$key][0]}" /></a>
    {/foreach}
  {/if}
  <br class="clear" />
</div>