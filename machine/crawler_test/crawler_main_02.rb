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
  elsif f == '-u'
    update = true
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
log.info("＜クローラ開始＞ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")

require File.dirname(__FILE__) + '/crawler/onuma'
onuma = Onuma.new

#### ロガーをセット ####
onuma.log = log

#### 既存機械UID一覧を取得 ####
log.info("#{onuma.company}: クロールサイト情報を取得します")
get_uri = 'http://test-machine.etest.wjg.jp/system/ajax/crawl_get_ex.php'
set_uri = URI('http://test-machine.etest.wjg.jp/system/ajax/crawl_set_data.php')

ex_json = open(URI.encode("#{get_uri}?id=#{onuma.company_id}&company=#{onuma.company}")).read
onuma.ex  = JSON.parse(ex_json, :symbolize_names => true, :allow_nan => true)
onuma.update = true if update != nil
onuma.depth = depth if depth != nil

#### クロール開始 ####
onuma.crawl

### 変換したJSONデータをPOST ####
log.info("#{onuma.company}: 機械情報を保存します。")

Net::HTTP.new(set_uri.host, 80).start do |http|
  http.read_timeout = 3000
  res = http.post(set_uri.path, URI.encode("id=#{onuma.company_id}&company=#{onuma.company}&data=#{onuma.d.to_json}&rex=#{onuma.rex.to_json}"))
  # res = http.post(set_uri.path, URI.encode("id=#{onuma.company_id}&company=#{onuma.company}&tarray=#{onuma.tarray.uniq.to_json}"))
  
  # log.info("#{onuma.company}: #{res.body}")
  log.info(res.body)
end

log.info("＜クローラ完了＞ #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}")
exit
