#! ruby -Ku
#
# クローラクラス(for 興和機械)のソースファイル
# Author::    川端洋平
# Date::      2013/02/07
# Copyright:: Copyright (c) 2014 川端洋平
#
require File.dirname(__FILE__) + '/base'

# クローラクラス
class Kowa < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()
    
    @company    = '興和機械株式会社'
    @company_id = 189
    @start_uri  = 'http://www.kowakikai.jp/index.php?lang=jp'
    
    @crawl_allow = /&kind=[0-9]+$/
    @crawl_deny  = nil
  end
  
  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #  
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'table').each do |m|
      begin
        #### 既存情報の場合スキップ ####
        detail_link = m%'tr:nth(1) th:nth(2) a'
        detail_uri = detail_link[:href].f
        uid        = detail_link.text.f
        
        next unless check_uid(uid)
        
        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, detail_uri)
        p2 = nokogiri(detail_uri)
        
        temp = {
          :uid   => uid,
          :no    => uid,
          :name  => (p2%'tr:nth(2) td:nth(2)').text.f,
          :hint  => (p2%'tr:nth(2) td:nth(2)').text.f,
          :maker => (p2%'tr:nth(3) td:nth(2)').text.f,
          :model => (p2%'tr:nth(5) td:nth(2)').text.f,
          :year  => '',
          :spec  => (p2%'tr:nth(6) td:nth(2)').text.f,
          :location => '',
        }
        
        if (p2%'tr:nth(4) td:nth(2)').text.f != '-'
          temp[:year] = (p2%'tr:nth(4) td:nth(2)').text.f
        end
        
        if (p2%'tr:nth(9) td:nth(2)').text.f != '-'
          temp[:location] = (p2%'tr:nth(9) td:nth(2)').text.f
        end
        
        if /^([0-9]+)(万円)$/ =~ (p2%'tr:nth(7) td:nth(2)').text.f
          temp[:price] = $1.to_i * 10000
        end
        
        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $2.gsub(/[^0-9.]/, '').to_f if /(芯間\:|\*)([0-9\,.]+)/ =~ temp[:spec]
        elsif /プレス/ =~ temp[:name]
          if /([0-9\,.]+)T(.*)$/i =~ temp[:name]
            temp[:hint] = $2.f
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)T/i =~ temp[:model] || /([0-9\,.]+)T/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f 
          end
        elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /ボール盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /(シャーリング|ベンディングロール)/ =~ temp[:name]
          if /\*([0-9\,.]+)/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)mm/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)m×/i =~ temp[:spec]
            temp[:capacity] = ($1.gsub(/[^0-9.]/, '').to_f) * 1000
          elsif /([0-9\,.]+)m×/i =~ temp[:name]
            temp[:capacity] = ($1.gsub(/[^0-9.]/, '').to_f) * 1000
          end
        elsif /(コンプレッサ|コンプッレサ)/ =~ temp[:name]
          if /([0-9\,.]+)KW(.*)$/i =~ temp[:name]
            temp[:hint] = $2.f
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)KW/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          end
        elsif /スポット溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)KVA/i =~ temp[:spec]
        elsif /溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)A/i =~ temp[:spec]
        elsif /フォークリフト|ローリフト|チェーンブロック|ホイスト|クレーン|リフタ/ =~ temp[:name]
          if /([0-9\,.]+)t/i =~ temp[:model]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)t/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)kg/i =~ temp[:spec]
            temp[:capacity] = ($1.gsub(/[^0-9.]/, '').to_f) / 1000
          end
        elsif /定盤/ =~ temp[:name]
          if /([0-9\,.]+)(×|\*)([0-9\,.]+)(×|\*)?/i =~ temp[:model] + ' ' +  temp[:spec]
            le1 = $1
            le2 = $3
          
            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f
            
            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end
        
        # 画像
        temp[:used_imgs] = []
        (p2/'a.highslide').each do |i|
          temp[:used_imgs] << join_uri(detail_uri, i[:href])
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
