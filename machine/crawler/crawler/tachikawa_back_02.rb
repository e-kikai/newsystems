#! ruby -Ku
#
# クローラクラス(for 立川商店)のソースファイル
# Author::    川端洋平
# Date::      2013/02/07
# Copyright:: Copyright (c) 2013 川端洋平
#
require File.dirname(__FILE__) + '/base'

# クローラクラス
class Tachikawa < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '有限会社立川商店'
    @company_id = 13
    @start_uri  = 'http://www.tachikawa-kikai.com/zaiko/stocks/N-002'

    @crawl_allow = /zaiko\/(stocks|toolshop)/
    @crawl_deny  = nil
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'a').each do |m|
      begin
        # スキップ
        detail_uri = m[:href].f
        next unless /zaiko\/detail\/([A-Za-z0-9-]*)/ =~ detail_uri
        uid = $1

        next unless check_uid(uid)

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, detail_uri)
        p2 = nokogiri(detail_uri)

        temp = {
          :uid   => uid,
          :no    => uid,
          :name  => (p2%'h2').text.f,
          :hint  => (p2%'h2').text.f,
          :maker => (p2%'ul.divided li:nth(1) span').text.f,
          :model => (p2%'ul.divided li:nth(2) span').text.f,
          :year  => (p2%'ul.divided li:nth(3) span').text.f,
          :spec         => (p2%'ul.divided li:nth(4) span').text.f,
          :location     => (p2%'ul.divided li:nth(5) span').text.f,
          :ekikai_price => (p2%'ul.divided li:nth(6) span').text.f.gsub(/\D/, '').to_i,

          :capacity => nil,
        }

        temp[:ekikai_price] = nil if temp[:ekikai_price] < 1

        if temp[:location] =~ /ツールショップ/
          temp[:location] = "ツールショップ寿"
        elsif temp[:location] =~ /東京/
          temp[:addr1] = "東京都"
        end

        # if /(\\|¥|￥)(.*)$/ =~ (m%'td:nth(2)').text
        #   temp[:price] = $2.gsub(/[^0-9.]/, '').to_i
        # end

        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          if /([3-9])尺/ =~ temp[:name]
            temp[:capacity] = LATER_CAP[$1.to_i]
          elsif /([0-9.]+)m/ =~ temp[:name]
            temp[:capacity] = $1.to_f * 1000
          end
        elsif /プレス/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)T/i =~ temp[:spec]
        elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /ボール盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /(コンプレッサ)/ =~ temp[:name]
          if /([0-9\,.]+)KW(.*)$/i =~ temp[:name]
            temp[:hint] = $2
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          end
        elsif /定盤/ =~ temp[:name]
          if /([0-9\,.]+)×([0-9\,.]+)/i =~ temp[:model]
            le1 = $1
            le2 = $2

            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f

            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end

        # 画像
        temp[:used_imgs] = []
        (p2/'img.image').each do |i|
          temp[:used_imgs] << i[:src]
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
