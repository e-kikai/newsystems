#! ruby -Ku
#
# クローラクラス(for 三善機械)のソースファイル
# Author::    川端洋平
# Date::      2013/01/20
# Copyright:: Copyright (c) 2013 川端洋平
#
require File.dirname(__FILE__) + '/base'
require 'csv'

# クローラクラス
class Sanzen < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '有限会社三善機械'
    @company_id = 23
    @start_uri  = 'http://sanzenkikai.co.jp/%E5%B7%A5%E4%BD%9C%E6%A9%9F%E6%A2%B0/%E3%83%9E%E3%82%B7%E3%83%8B%E3%83%B3%E3%82%B0%E3%82%BB%E3%83%B3%E3%82%BF%E3%83%BC.html'

    @crawl_allow = /(工作機械|鍛圧_板金_切断機|その他機械|工具_測定器)/
    @crawl_deny  = /page|ボール盤_4/
  end

  #
  # スクレイピング処理
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'table.product_list').each do |m|
      begin
        uid = (m%'a:nth(1)')[:href]
        next unless check_uid(uid)
        @log.debug(URI.escape(uid))

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, uid)
        next unless check_uid(URI.escape(uid))
        next unless p2 = nokogiri(URI.escape(uid))

        trs = {
          "メーカー名:" => :maker,
          "管理番号:"   => :no,
          "機械名:"     => :name,
          "型番:"       => :model,
          "年式:"       => :year,
          "仕様:"       => :spec,
        }

        temp = {:uid => uid, :location => "本社"}
        p2.search('table.product_property tr').each do |tr|
          th = tr.search('th').text.f
          td = tr.search('td').text.f

          temp[trs[th]] = td if trs.include? th
        end

        # if /管理番号/ =~ (p2%'table.product_property').text
        #   temp = {
        #     :uid   => uid,
        #     :no    => (p2%'table.product_property tr:nth(3) td').text.f,
        #     :name  => (p2%'table.product_property tr:nth(4) td').text.f,
        #     :maker => (p2%'table.product_property tr:nth(2) td').text.f,
        #     :model => (p2%'table.product_property tr:nth(5) td').text.f,
        #     :year  => (p2%'table.product_property tr:nth(6) td').text.f,
        #     :spec  => (p2%'table.product_property tr:nth(8) td').text.f,
        #     # :price => (p2%'table.product_property tr:nth(7) td').text.f,
        #     :location => "本社",
        #
        #     :used_imgs => [],
        #   }
        # else
        #   temp = {
        #     :uid   => uid,
        #     :no    => '',
        #     :name  => (p2%'table.product_property tr:nth(3) td').text.f,
        #     :maker => (p2%'table.product_property tr:nth(2) td').text.f,
        #     :model => (p2%'table.product_property tr:nth(4) td').text.f,
        #     :year  => (p2%'table.product_property tr:nth(5) td').text.f,
        #     :spec  => (p2%'table.product_property tr:nth(7) td').text.f,
        #     # :price => (p2%'table.product_property tr:nth(6) td').text.f,
        #     :location => "本社",
        #
        #     :used_imgs => [],
        #   }
        # end

        temp[:hint] = temp[:name]
        # @log.debug(temp[:name])

        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /心間([0-9]+)/ =~ temp[:spec]
        elsif /プレス/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)t/i =~ temp[:spec]
        elsif /(コンプレッサ|モーター)/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)kw/i =~ temp[:spec]
        elsif /溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)A/i =~ temp[:spec]
        end

        # 画像
        temp[:used_imgs] = []
        (p2/'.product_img_thumbnail a').each do |i|
          # @log.debug(join_uri(detail_uri, i[:href]))
          # @log.debug(URI.escape(join_uri(detail_uri, i[:href])))
          temp[:used_imgs] << URI.escape(join_uri(detail_uri, i[:href])).gsub(/\%E2\%88\%92/, '%EF%BC%8D')
          # temp[:used_imgs] << URI.escape(join_uri(detail_uri, i[:href]))
        end

        @d << temp if temp[:name]
        @log.debug(temp)
      rescue => exc
        error_report("scrape error (#{uid || 0})", exc)
        next
      end
    end

    return self
  end

  #
  # 2次クロール（セーフレベル2内で処理）
  # Param:: String uri 2次クロールするURI
  #
  def nokogiri(uri)
    page = NKF.nkf("-wX--cp932", open(uri).read)
    Nokogiri::HTML(page, nil, 'UTF-8')
  end
end

class MyParser
  def self.parse(thing, url = nil,
                 encoding = nil,
                 options = Nokogiri::XML::ParseOptions::DEFAULT_HTML,
                 &block)
    thing = NKF.nkf("-wX--cp932", thing)
    Nokogiri::HTML.parse(thing, url, encoding, options, &block)
  end
end
