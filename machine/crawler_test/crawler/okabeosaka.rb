#! ruby -Ku
#
# クローラクラス(for 岡部機械株式会社　大阪営業所)のソースファイル
# Author::    川端洋平
# Date::      2013/01/20
# Copyright:: Copyright (c) 2013 川端洋平
#
require File.dirname(__FILE__) + '/base'
require 'csv'

# クローラクラス
class Okabeosaka < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()
    
    @company    = '岡部機械株式会社　大阪営業所'
    @company_id = 5
    @start_uri  = 'http://58.1.231.206/Okabe/frmokabe.aspx?searchname='
    
    @crawl_allow = /^xxxxxxxxxx$/
    @crawl_deny  = nil
  end
  
  #
  # スクレイピング処理
  # Return:: self
  #  
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'table.lgText tr.tblData').each do |m|
      begin
        next if m%'th'
        
        # 大阪営業所の場合はスキップ
        location = (m%'td:nth(8)').text.f
        next unless /大阪/ =~ location
        if /(倉庫)/ =~ location
          location = '大阪倉庫'
        else
          location = '大阪営業所'
        end
        
        uid = (m%'td:nth(2)').text.f
        
        ### UIDが-の場合もスキップ ####
        next if /^(\-)*$/ =~ uid
        # next if /^OK/ !~ uid
        
        #### 既存情報の場合スキップ ####
        next unless check_uid(uid)
        
        temp = {
          :uid   => uid,
          :no    => uid,
          :name  => (m%'td:nth(3)').text.f,
          :maker => (m%'td:nth(4)').text.f,
          :model => (m%'td:nth(6)').text.f,
          :year  => (m%'td:nth(5)').text.f,
          :spec  => (m%'td:nth(7)').text.f,
          :comment => (m%'td:nth(9)').text.f,
          :location => location,
          
          :used_imgs => [],
        }
        
        temp[:hint] = temp[:name]
        
        # 主能力
        if /旋盤/ =~ temp[:name]
          temp[:capacity] = $2.gsub(/[^0-9.]/, '').to_f if /(芯間|心間)([0-9\,.]+)/ =~ temp[:spec]
        elsif /プレス/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)TON/i =~ temp[:spec]
        elsif /コンプレッサ/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)kw/i =~ temp[:spec]
        elsif /定盤/ =~ temp[:name]
          if /([0-9\,.]+)x([0-9\,.]+)/i =~ temp[:spec]
            le1 = $1
            le2 = $2
          
            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f
            
            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end
        
        # 画像
        i = 0
        loop do
          i += 1
          iuri = "http://58.1.231.206/Okabe-ImageData/#{uid}-#{i}.jpg"
          begin
            break unless open(iuri).status[0] == "200"
            temp[:used_imgs] << iuri
            @log.debug(iuri)
          rescue => exc
            break
          end      
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
