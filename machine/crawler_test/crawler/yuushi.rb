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
class Yuushi < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '株式会社ユウシ'
    @company_id = 25
    @start_uri  = 'http://chuuko-kikai.com/cyuuko1.html'

    @crawl_allow = /cyuuko[0-9]+/
    @crawl_deny  = /page/
  end

  #
  # スクレイピング処理
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    @p.search('tr').each do |m|
      begin
        next unless m.search(" > td:nth(8)")

        next unless m.at(" > td:nth(2)")
        uid = m.at(" > td:nth(2)").text.f
        next unless /^[A-Z]+[0-9]+$/ =~ uid
        next unless check_uid(uid)

        temp = {
          uid:      uid,
          no:       uid,
          name:     m.at(" > td:nth(3)").text.f,
          maker:    m.at(" > td:nth(4)").text.f,
          model:    m.at(" > td:nth(5)").text.f,
          year:     m.at(" > td:nth(6)").text.f,
          spec:     m.at(" > td:nth(7)").text.f,
          location: m.at(" > td:nth(9)").text.f,
          hint:     m.at(" > td:nth(3)").text.f,
        }

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

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, m.at(" > td:nth(1) a")[:href])
        begin
          p2 = nokogiri(detail_uri)

          # 画像
          temp[:used_imgs] = []
          p2.search('td > img').each do |i|

            next unless /(jpg|JPG|jpeg|JPEG)$/ =~ i[:src]
            next if     /CATCHIL/ =~ i[:src]
            temp[:used_imgs] << join_uri(detail_uri, i[:src])
          end
        rescue
          log.debug "---------404----------"
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
end
