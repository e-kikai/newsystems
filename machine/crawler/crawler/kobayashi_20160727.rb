#! ruby -Ku
#
# クローラクラス(for 大沼機工)のソースファイル
# Author::    川端洋平
# Date::      2012/5/17
# Copyright:: Copyright (c) 2012 川端洋平
#
require  File.dirname(__FILE__) + '/base'

# クローラクラス
class Kobayashi < Base

  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '株式会社小林機械'
    @company_id = 9
    @start_uri  = 'http://www.kkmt.co.jp/site/list?c1=1'

    @crawl_allow = /site\/list\?c1=[12](\&page=[0-9]+)?$/
    @crawl_deny  = nil

    @depth  = 100
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'table.tableColor tr').each do |m|
      begin
        # 初期化
        temp = {
          :hint => '',
          :used_pdfs => {},
          :used_imgs => []
        }

        next unless m%'th:nth(4)'

        (m/'th').each_with_index do |th, key|
          if key == 3
            next if th%'img[alt=Soldout]'  # SOLDOUT除外
            next if /入荷風景/ =~ th.text  # 「入荷風景」を除外

            temp[:uid] = $1 if /([A-Z][0-9]{6})/ =~ th.text.f
          elsif key == 5
            temp[:location] = th.text.f
          end
        end

        next unless check_uid(temp[:uid])

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, (m%'th:nth(2) a')[:href])
        p2 = nokogiri(detail_uri)

        temp[:no]      = temp[:uid]
        temp[:name]    = (p2%'h1').text.f if p2%'h1'
        temp[:hint]    = temp[:name]
        # temp[:youtube] = 'http://youtu.be/' + (p2%'iframe').text.f.gsub(/^.*\//, '') if p2%'iframe'
        temp[:youtube] = 'http://youtu.be/' + (p2%'.deatail_tableAreaa iframe')[:src].f.gsub(/^.*\//, '') if p2%'.deatail_tableAreaa iframe'

        if p2%'.deatail_titleArea strong'
          if /(\\|¥|￥)(.*)$/ =~ (p2%'.deatail_titleArea strong').text.f
            temp[:price] = $2.gsub(/[^0-9]/, '').to_i
            temp[:price_tax] = 1
          end
        end

        (p2/'tr.cellColor td').each_with_index do |n, key|
          if key == 0
            temp[:year]  = n.text.f.to_i if n.text.f != ''
          elsif key == 1
            temp[:maker] = n.text.f
          elsif key == 2
            temp[:model] = n.text.f
          elsif key == 3
            temp[:spec]    = n.text.gsub(/(販売価格|\\|¥|￥).*$/, '').f
            temp[:comment] = $1 if n.text.f =~ /★(.*)$/
          elsif key == 4
            temp[:used_pdfs]['仕様書'] = join_uri(detail_uri, (n%'a')[:href]) if n%'a'
          elsif key == 4
            temp[:used_pdfs]['精度表'] = join_uri(detail_uri, (n%'a')[:href]) if n%'a'
          end
        end

        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /心間([0-9]+)/ =~ temp[:spec]
        elsif /ラジアル/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /振り([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /シャーリング/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /長さ([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /テーブル長さ?([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /プレス/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)t/i =~ temp[:spec]
        elsif /バンドソー/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /φ([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /(コンプレッサ|モーター)/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)kw/i =~ temp[:spec]
        elsif /スポット溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)KVA/i =~ temp[:spec]
        elsif /溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)A/i =~ temp[:spec]
        elsif /定盤/ =~ temp[:name]
          if /([0-9\,.]+)×([0-9\,.]+)/i =~ temp[:spec]
            le1 = $1
            le2 = $2

            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f

            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end

        # 画像
        temp[:used_imgs] = []
        (p2/'.square_table img').each do |i|
          temp[:used_imgs] << join_uri(detail_uri, i[:src]).gsub(/_3\.jpg.*$/, '_1.jpg')
        end

        @d << temp
        @log.debug(temp)

      rescue => exc
        error_report("scrape error (#{temp[:uid]})", exc)
      end
    end

    return self
  end
end
