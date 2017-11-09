#! ruby -Ku
#
# クローラクラス(for e-kikai用スーパークラス)のソースファイル
# Author::    川端洋平
# Date::      2012/5/17
# Copyright:: Copyright (c) 2012 川端洋平
#
require  File.dirname(__FILE__) + '/base'

# クローラクラス
class Ekikai < Base

  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()
    
    @company    = '中藤機械株式会社'
    @company_id = 324
    @start_uri  = 'http://www.e-kikai.com/PHP/Admin/goods_list/crawled_ekikai.php?date=ALL&me=10'
    
    @crawl_allow = /^xxxxx$/
    @crawl_deny  = nil
  end
  
  #
  # クロールメソッド
  # Param:: String url クロール開始URL
  # Param:: Integer depth 初期クロール深度
  # Return:: self
  #
  def crawl()
    # ページの取得
    ekikai_json = open(@start_uri).read
    machines = JSON.parse(ekikai_json, :symbolize_names => true, :allow_nan => true)
    
    machines.each do |m|
      begin
        #### 既存情報の場合スキップ ####
        uid = m[:goods_id].f
        next unless check_uid(uid)
      
        temp = {
          :uid   => uid,
          :no    => m[:goods_number].f,
          :name  => m[:goods_name].f,
          :hint  => m[:goods_name].f,
          
          :maker => m[:product_maker].f,
          :model => m[:goods_type].f,
          :year  => m[:release_year].f,
          :spec  => m[:specification].f,
          :comment  => m[:comment].f,
          :location => m[:stock_place].f == '機械団地' ? '本社' : m[:stock_place].f,
          :price => m[:customer_price].f.to_i == 0 ? nil : m[:customer_price].f.to_i,
          
          :capacity => m[:goods_degree].f.to_f == 0 ? nil : m[:goods_degree].f.to_f,
        }
        
        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /x([0-9.,]+)[$、]/ =~ temp[:spec]
        elsif /ブローチ/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)トン/i =~ temp[:spec]
        elsif /スロッタ/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /ストローク([0-9\,.]+)/i =~ temp[:spec]
        end
        
        # 画像
        temp[:used_imgs] = []
        m[:imgs].each do |i|
         temp[:used_imgs] << "http://www.e-kikai.com/#{m[:account]}/#{i}"
        end
        
        @d << temp
        @log.debug(temp)
      rescue => exc
        error_report("scrape error (#{temp[:uid]})", exc)
      end
    end
    
    # エラーログをメールで送信(あれば)
    send_error
      
    return self
  rescue => exc
    error_report("e-kikai crawl error", exc)
    # エラーログをメールで送信
    send_error
    
    @log.error("e-kikai error exit")
    return false
  end
end
