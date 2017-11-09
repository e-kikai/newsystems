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
    @start_uri  = 'http://www.tachikawa-kikai.com/zaiko01.html'
    
    @crawl_allow = /zaiko[0-9]{2}\.html$/
    @crawl_deny  = nil
  end
  
  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #  
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'table tr').each do |m|
      begin
        # スキップ
        next if m%'th'
        next unless m%'td:nth(7)'
        next if m%'td:nth(8)'
        next unless m%'td:nth(2) a'
        
        #### 既存情報の場合スキップ ####
        detail_link = m%'td:nth(2) a'
        detail_uri = detail_link[:href].f
        uid        = $1.f if /([A-Za-z]-[0-9]*)/ =~ detail_uri
        name       = detail_link.text.f
        
        next unless check_uid(uid)
        
        temp = {
          :uid   => uid,
          :no    => uid,
          :name  => name,
          :hint  => name,
          :maker => (m%'td:nth(4)').text.f,
          :model => (m%'td:nth(5)').text.f,
          :year  => (m%'td:nth(3)').text.f,
          :spec  => (m%'td:nth(6)').text.f,
          :location => (m%'td:nth(7)').text.f,
        }
        
        if /(\\|¥|￥)(.*)$/ =~ (m%'td:nth(2)').text
          temp[:price] = $2.gsub(/[^0-9.]/, '').to_i
        end
        
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
        
        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, detail_uri)
        p2 = nokogiri(detail_uri)
        
        # 画像
        temp[:used_imgs] = []
        (p2/'img').each do |i|
          temp[:used_imgs] << join_uri(detail_uri, i[:src])
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
