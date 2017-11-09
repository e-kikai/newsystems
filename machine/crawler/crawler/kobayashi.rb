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
    # @start_uri  = 'http://www.kkmt.co.jp/site/list?c1=1'
    @start_uri  = 'http://www.kkmt.co.jp/site/list?mode=tool&page=1'

    @crawl_allow = /site\/list\?mode=tool(\&page=[0-9]+)?$/
    @crawl_deny  = nil

    @depth       = 100 # クロール深度
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    # (@p/'table.tableColor tr').each do |m|
    (@p/'table.table.table-bordered tr').each do |m|
      begin
        next if m%'th'

        #### 名前に「売約済」が入っていたらスキップ ####
        next if m%'img[alt=Soldout]'  # SOLDOUT除外
        next if /入荷風景/ =~ m.text  # 「入荷風景」を除外

        # 初期化
        temp = {
          :uid   => (m%'td:nth(2)').text.f,
          :no    => (m%'td:nth(2)').text.f,
          :name  => (m%'td:nth(3)').text.f,
          :hint  => (m%'td:nth(3)').text.f,
          :maker => (m%'td:nth(4)').text.f,
          :model => (m%'td:nth(5)').text.f,
          :year  => (m%'td:nth(6)').text.f.to_i,
          :price  => (m%'td:nth(7)').text.f.to_i,
          :location => '',
        }

        #### 既存情報の場合スキップ ####
        next unless check_uid(temp[:uid])

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, (m%'td:nth(2) a')[:href])
        p2 = nokogiri(detail_uri)

        temp[:youtube] = 'http://youtu.be/' + (p2%'iframe')[:src].f.gsub(/^.*\//, '') if p2%'iframe'

        (p2/'.media-body').each_with_index do |n, key|
          if n.text.f =~ /主仕様(.*)/
            temp[:spec] = $1
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
        (p2/'#slider img').each do |i|
          temp[:used_imgs] << join_uri(detail_uri, i[:src].gsub(/\?.*$/, "")) unless i[:src] =~ /noimage/
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
