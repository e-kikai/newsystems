<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:wfw="http://wellformedweb.org/CommentAPI/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:sy="http://purl.org/rss/1.0/modules/syndication/" xmlns:slash="http://purl.org/rss/1.0/modules/slash/" xmlns:media="http://search.yahoo.com/mrss/">
  <channel>
    <title>マシンライフ｜全機連の中古機械情報サイト</title>
    <description>中古機械のスペシャリスト、全機連会員の中古機械在庫情報を掲載しています</description>
    <link>https://www.zenkiren.net/</link>
    <language>ja-ja</language>
    <ttl>40</ttl>
    <pubDate>{$smarty.now|date_format:"%a, %d %b %Y %H:%M:%S"} JST</pubDate>
    <copyright>Copyright (c) {$smarty.now|date_format:"%Y"} 全日本機械業連合会 All Rights Reserved.</copyright>
    <atom:link href="https://www.zenkiren.net/rss.php" rel="self" type="application/rss+xml"/>
    <image>
      <url>https://www.zenkiren.net/imgs/logo_machinelife.png</url>
      <title>マシンライフ｜全機連の中古機械情報サイト</title>
      <link>https://www.zenkiren.net/</link>
    </image>

    {foreach $newMachineList as $m}
      <item>
        <title>{$m.name} {$m.maker} {$m.model} {if !empty($m.year) && $m.year != '-'}{$m.year}年式{/if}</title>
        <description>
          <![CDATA[{'/(株式|有限|合.)会社/u'|preg_replace:'':$m.company}{if !empty($m.addr1)} ({$m.addr1}){/if}]]>
        </description>
        <pubDate>{$m.created_at|date_format:"%Y/%m/%d %H:%M:%S"}</pubDate>
        <link>https://www.zenkiren.net/machine_detail.php?m={$m.id}</link>
        <guid isPermaLint="true">https://www.zenkiren.net/machine_detail.php?m={$m.id}</guid>

        {if !empty($mail)}
          {if !empty($m.top_img)}
            <enclosure url="https://s3-ap-northeast-1.amazonaws.com/machinelife/machine/public/media/machine/thumb_{$m.top_img}" length="100000" type="image/jpeg"></enclosure>
            <media:content url="https://s3-ap-northeast-1.amazonaws.com/machinelife/machine/public/media/machine/thumb_{$m.top_img}" medium="image" type="image/jpeg"/>
          {else}
            <enclosure url="https://www.zenkiren.net/imgs/noimage.png" length="100000" type="image/jpeg"></enclosure>
            <media:content url="https://www.zenkiren.net/imgs/noimage.png" medium="image" type="image/jpeg"/>
          {/if}

          <category>{if $m@index % 2}#FFF{else}#EEE{/if}</category>
        {else}
          {if !empty($m.top_img)}
            <enclosure url="https://s3-ap-northeast-1.amazonaws.com/machinelife/machine/public/media/machine/{$m.top_img}" length="100000" type="image/jpeg"></enclosure>
            <media:content url="https://s3-ap-northeast-1.amazonaws.com/machinelife/machine/public/media/machine/{$m.top_img}" medium="image" type="image/jpeg"/>
          {/if}

          <category>{$m.genre}</category>
        {/if}
      </item>
    {/foreach}
  </channel>
</rss>
