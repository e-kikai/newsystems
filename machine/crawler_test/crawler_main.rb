#! ruby -Ku
# クローラクラスのソースファイル
# Author::    川端洋平
# Date::      2011/05/26
# Copyright:: Copyright (c) 2011 川端洋平
require 'rubygems'
require 'mechanize'
require 'kconv'
require 'nkf'
require 'open-uri'
require 'uri'
require 'logger'
require 'net/http'
require 'json'

require  File.dirname(__FILE__) + '/lib/crawler'
require  File.dirname(__FILE__) + '/lib/my_string'

# main
#### 実行時オプションによる設定 ####
while f = ARGV.shift
  # デバッグモードに設定する
  if f == '-d'
    debug = true
  # ログを標準出力に切り替える
  elsif f == '-o'
    log_out = true
  # クロール深度を指定する
  elsif /-d(\d+)$/ =~ f
    depth = $1.to_i 
  # 指定された idのサイトだけを解析する
  elsif /-s(\d+)$/ =~ f
    site_id = $1.to_i
    force = true 
  # それ以外
  else
    log.e_msg("main", 1, "illegal opiton #{f}")
    exit 1
  end
end

#### Logger ####
unless File.directory?(File.dirname(__FILE__) + '/log')
  Dir::mkdir(File.dirname(__FILE__) + '/log')
end
log = Logger.new(log_out ? STDERR : File.dirname(__FILE__) + '/log/crawl.log', 'daily')
log.level = debug ? Logger::DEBUG : Logger::INFO


# データ格納
data = []

require 'mechanize'
require 'kconv'
require 'nkf'

a                  = Mechanize.new   # クローラ
a.user_agent_alias = 'Linux Mozilla' # エージェント（alias）
a.html_parser      = MyParser        # 日本語記号対応用パーサ
a.read_timeout     = 180             # タイムアウト時間

#### クロールキューの初期化 ####
queue = [ ['http://www.onuma-mc.co.jp/stock.php?maxRowID=5', 1] ]

#### クロール開始時間を取得 ####
now_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")
log.info("＜クローラ開始＞ #{now_date}")

#### クロールループ ####
begin
  loop do
    break if queue.length < 1
    uri, depth = queue.shift
    
    next if a.visited?(uri)
    
    #### ページの取得 ####
    log.info("#{depth} -> #{uri}")
  
    #### ローカル変数 ####
    count = 0
    
    #### Nokogiri ####
    begin
      p = a.get(uri)
    rescue => exc
      count += 1
      if count <= 3
        sleep 3
        log.warn("retry #{count} : #{uri}")
        mechanize_init
        retry
      else
        log.error("#{exc} : #{uri}\n".toutf8 + $@.to_s)
        return
      end
    end
    
    #### ページ情報のスクレイピング ####
    # 処理
    (p/'#TableList tbody tr').each do |m|
      next if m%'th'
      
      temp = {
        :uid   => (m%'td:nth(3)').text.f,
        :no    => (m%'td:nth(4)').text.f,
        :name  => (m%'td:nth(5)').text.f,
        :maker => (m%'td:nth(6)').text.f,
        :model => (m%'td:nth(8)').text.f,
        :year  => (m%'td:nth(7)').text.f,
        :spec  => '',
      }
      
      #### ディープクロール ####
      detail_uri = p.uri.merge(m.%('td:nth(3) a')[:href]).to_s
      page = NKF.nkf("-wZX--cp932", open(detail_uri).read)
      p2 = Nokogiri::HTML(page, nil, 'UTF-8')
      
      (p2/'table.spec th').each do |n|
        ntext  = n.text.f
        nntext = n.next_element.text.f
        if ntext == '保管'
          temp[:location] = nntext
        elsif ntext == '管理状況'
          temp[:comment] = nntext
        elsif /^(在庫No|問合せ)$/ !~ ntext
          if nntext != ''
            temp[:spec] += "#{ntext}:#{nntext}、"
          end
        end
      end
      
      # 画像
      temp[:top_img] = ''
      temp[:imgs]    = []
      (p2/'img.DetailPhoto').each do |i|
        itemp = p.uri.merge(i[:src]).to_s
        if temp[:top_img] == ''
          temp[:top_img] = itemp
        else
          temp[:imgs] << itemp
        end
      end
      
      data << temp
      log.info(temp)
    end
    
    #### 子要素へのクロール ####
    p.links.each do |l|
      href = p.uri.merge(l.uri).to_s
      
      if /stock\.php\?maxRowID=5&pageNum=[0-9]+$/ =~ href && depth + 1 < 20 && !a.visited?(href)
        queue << [href, depth + 1]
      end
    end
  end
rescue => exc
  log.error("#{exc}\n".toutf8 + $@.to_s)
end
log.info("＜クローラ完了＞ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
exit













#### クロールするサイト設定をGET、JSONパース ####
logger.info("クロールサイト情報を取得します。")
model_url = 'http://mal.etest.wjg.jp/crawl_do.php?id=' + site_id.to_s
modeli    = URI(model_url)

site_json = open(model_url).read
crawl_site = JSON.parse(site_json, :symbolize_names => true, :allow_nan => true)

#### クロール開始時間を取得 ####
now_date = Time.now.strftime("%Y-%m-%d %H:%M:%S")

#### クローラクラス実行 ####
thread  = []
group_thread = []
crawler = []

logger.info("＜クローラ開始＞ #{now_date}")
crawl_site.each.with_index do |s, i|
  #### 各サイトごとにクロール用スレッドを生成 ####
  thread[i] = Thread.new do
    logger.info("Site : 「#{s[:name]}」クロール開始します。")
    
    #### グループごとに別スレッドでクロール処理 ####
    crawler[i] = []
    group_thread[i] = []
    s[:root_url].split.each.with_index do |gs, gi|
      next if !gs
      
      logger.info("Thread #{gi} : #{gs}")
      group_thread[i][gi] = Thread.new do
        crawler[i][gi] = Crawler.new(s)
        crawler[i][gi].logger = logger
        crawler[i][gi].depth = depth if depth
        crawler[i][gi].crawl(gs)
        
        #### 取得した情報をJSON変換 ####
        result = JSON.generate(crawler[i][gi].d)
        
        ### 変換したJSONデータをPOST ####
        logger.info("Thread #{gi} : 機械情報を保存します。")
        Net::HTTP.new(modeli.host, 80).start do |http|
          http.read_timeout = 3000
          response = http.post(modeli.path, "id=#{s[:id]}&data=#{result}")
          logger.info("Thread #{gi} : #{response.body}")
        end
      end
    end
    
    #### グループごとのスレッドを結合 ####
    group_thread[i].each { |t| t.join }
    
    logger.info("Site : 「#{s[:name]}」クロール終了します。")
    
    ### 更新されていないデータを削除するためPOST ####
    logger.info("Site : 「#{s[:name]}」更新されていない機械情報を削除します。")
    Net::HTTP.new(modeli.host, 80).start do |http|
      http.read_timeout = 3000
      response = http.post(modeli.path, "query=delete&id=#{s[:id]}&data=#{now_date}")
      logger.info("Site : 「#{s[:name]}」 #{response.body}")
    end
  end
end

#### スレッドを結合 ####
thread.each { |t| t.join }

logger.info("＜クローラ完了＞ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
exit

# MechanizeのパーサNokogiriを再定義
# 記号のエンコーディングがうまくいかないので
class MyParser
  
  # パーサの再定義
  def self.parse(thing, url = nil, encoding = nil,
                 options = Nokogiri::XML::ParseOptions::DEFAULT_HTML, &block)
    thing = NKF.nkf("-wZX--cp932", thing)
    Nokogiri::HTML.parse(thing, url, encoding, options, &block)
  end
end
