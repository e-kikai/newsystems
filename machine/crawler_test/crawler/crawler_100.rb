#! ruby -Ku
#
# クローラクラス(for 百貨店)のソースファイル
# Author::    川端洋平
# Date::      2012/5/17
# Copyright:: Copyright (c) 2012 川端洋平
#
require 'rubygems'
require 'mechanize'
require 'kconv'
require 'nkf'
require 'uri'
require 'logger'

require  File.dirname(__FILE__) + '/my_string'

require 'zlib'

# クローラクラス
class Crawler_100
  #### インスタンス変数アクセッサ ####
  attr_reader   :d
  attr_accessor :depth, :logger
  
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize(site)
    mechanize_init # Mechinizeの初期化
    
    @s      = site # サイトクロール設定
    @d      = []   # スクレイピング結果の格納
    @q      = []   # クロールURIキュー
    @v      = []   # 履歴URI配列
    
    @depth  = 20   # クロール深度デフォルト
    @retnum = 3    # getリトライ回数
    @retslp = 20   # リトライ時スリープ秒
    @logger = Logger.new(STDERR)
  end
  
  GENRE_HINTS = {
    # NC工作機械(19その他NCフライスは欠番)
    /c\/3$/ => 1,
    /c\/4$/ => 2,
    /c\/5$/ => 3,
    /c\/6$/ => 4,
    /c\/7$/ => 5,
    /c\/325$/ => 6,
    /c\/9$/ => 7,
    /c\/10$/ => 8,
    /c\/11$/ => 9,
    /c\/328$/ => 10,
    /c\/12$/ => 11,
    /c\/13$/ => 12,
    /c\/329$/ => 13,
    /c\/14$/ => 14,
    /c\/15$/ => 15,
    /c\/16$/ => 16,
    /c\/17$/ => 17,
    /c\/18$/ => 18,
    /c\/330$/ => 19,
    /c\/331$/ => 20,
    /c\/332$/ => 21,
    /c\/333$/ => 22,
    /c\/20$/ => 23,
    /c\/21$/ => 24,
    /c\/22$/ => 25,
    /c\/23$/ => 26,
    /c\/24$/ => 27,
    /c\/25$/ => 28,
    /c\/26$/ => 29,
    /c\/27$/ => 30,
    /c\/28$/ => 31,
    /c\/334$/ => 32,
    /c\/335$/ => 33,
    /c\/336$/ => 34,
    /c\/337$/ => 35,
    /c\/338$/ => 36,
    /c\/339$/ => 37,
    /c\/340$/ => 38,
    /c\/342$/ => 39,
    /c\/343$/ => 40,
    /c\/344$/ => 41,
    /c\/345$/ => 42,
    /b\/11$/ => 43,
    
    # 一般工作機械(350タレット旋盤、351単能盤、364センター穴研削盤は欠番)
    /c\/32$/ => 51,
    /c\/(3[3-9]|346)$/ => 52,
    /c\/347$/ => 53,
    /c\/348$/ => 54,
    /c\/349$/ => 55,
    /c\/352$/ => 56,
    /c\/353$/ => 57,
    /c\/354$/ => 58,
    /c\/355$/ => 59,
    /c\/356$/ => 60,
    /c\/358$/ => 61,
    
    /c\/40$/ => 62,
    /c\/41$/ => 63,
    /c\/42$/ => 64,
    /c\/43$/ => 65,
    /c\/44$/ => 66,
    /c\/45$/ => 67,
    /c\/46$/ => 68,
    /c\/47$/ => 69,
    /c\/48$/ => 70,
    
    /c\/49$/ => 71,
    /c\/50$/ => 72,
    /c\/51$/ => 73,
    /c\/52$/ => 74,
    /c\/53$/ => 75,
    /c\/54$/ => 76,
    /c\/55$/ => 77,
    /c\/56$/ => 78,
    /c\/57$/ => 79,
    /c\/359$/ => 80,
    /c\/360$/ => 81,
    /c\/361$/ => 82,
    /c\/362$/ => 83,
    /c\/365$/ => 84,
    /c\/366$/ => 85,
    
    /c\/58$/ => 86,
    /c\/(59|6[012])$/ => 87,
    /c\/(6[34]|36[78])$/ => 88,
    /c\/369$/ => 89,
    /c\/370$/ => 90,
    /c\/371$/ => 91,
    /c\/372$/ => 92,
    /c\/373$/ => 93,
    /c\/374$/ => 94,
    /c\/375$/ => 95,
    
    /c\/65$/ => 96,
    /c\/66$/ => 97,
    /c\/376$/ => 98,
    /c\/67$/ => 99,
    
    /c\/68$/ => 100,
    /c\/377$/ => 101,
    /c\/69$/ => 102,
    /c\/70$/ => 103,
    /c\/71$/ => 104,
    
    /c\/73$/ => 105,
    /c\/74$/ => 106,
    /c\/75$/ => 107,
    /c\/76$/ => 108,
    /c\/77$/ => 109,
    /c\/78$/ => 110,
    /c\/79$/ => 111,
    /c\/80$/ => 112,
    /c\/380$/ => 113,
    
    /c\/81$/ => 114,
    /c\/82$/ => 115,
    /c\/83$/ => 116,
    /c\/84$/ => 117,
    /c\/85$/ => 118,
    /c\/86$/ => 119,
    /c\/87$/ => 120,
    /c\/381$/ => 121,
    /c\/382$/ => 122,
    
    /c\/89$/ => 123,
    /c\/90$/ => 124,
    /c\/91$/ => 125,
    /c\/92$/ => 126,
    /c\/93$/ => 127,
    
    # プレス
    /c\/(133|40[0-5])/ => 44,
    /c\/(134|40[678])/ => 45,
    /c\/(135|409|41[01])/ => 46,
    /b\/216/ => 47,
    /b\/217/ => 48,
    /c\/(57[89]|58[0-5])/ => 49,
    /c\/(14[4-8]|41[2-7])/ => 50,
    
    # 板金機械(コイル加工ラインは欠番)
    /c\/15[0-3]/ => 128,
    /c\/(15[45]|418)/ => 129,
    /c\/419/ => 130,
    /c\/156/ => 131,
    /c\/420/ => 132,
    /c\/421/ => 133,
    /c\/422/ => 134,
    /c\/576/ => 135,
    /c\/425/ => 136,
    /c\/157/ => 137,
    /c\/158/ => 138,
    /c\/159/ => 139,
    /c\/160/ => 140,
    /c\/162/ => 141,
    /c\/163/ => 142,
    /c\/(164|424)/ => 143,
    /c\/425/ => 144,
    /c\/166/ => 145,
    /c\/431/ => 146,
    /c\/(16[789]|170|427)/ => 147,
    /c\/171/ => 190,
    /c\/430/ => 148,
    /c\/431/ => 149,
    /c\/432/ => 150,
    /b\/41/ => 151,
    
    # 鉄骨加工機械
    /c\/17[2-5]/ => 152,
    /c\/176/ => 153,
    /c\/177/ => 154,
    /c\/178/ => 155,
    /c\/438/ => 156,
    /c\/439/ => 157,
    /c\/440/ => 158,
    /c\/571/ => 159,
    /c\/441/ => 160,
    /c\/180/ => 161,
    /c\/181/ => 162,
    /c\/182/ => 163,
    /c\/183/ => 164,
    /c\/184/ => 165,
    /c\/185/ => 166,
    /c\/186/ => 167,
    /c\/187/ => 168,
    /c\/188/ => 169,
    /c\/442/ => 170,
    /c\/443/ => 171,
    /c\/189/ => 172,
    /c\/191/ => 173,
    /c\/190/ => 174,
    /c\/194/ => 175,
    /c\/192/ => 176,
    /c\/193/ => 177,
    /c\/572/ => 178,
    /c\/196/ => 179,
    /c\/197/ => 180,
    /c\/198/ => 181,
    /c\/199/ => 182,
    /c\/446/ => 183,
    /c\/447/ => 184,
    /c\/200/ => 185,
    /b\/191/ => 186,
  }
  
  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #  
  def scrape
    uri = @a.page.uri
    
    # ジャンル
    genre_hint = /general_list_(.\/[0-9]+)/ =~ uri.to_s ? $1 : ''
    genre_id = ''
    if genre_hint != ''
      GENRE_HINTS.each do |key, val|
        if key =~ genre_hint
          genre_id = val
          break
        end
      end
    end
  
    (@a.page/'tr').each do |m|
      next if m%'th'
      
      data = {
        :uid => (m%'.name a')[:href].scan(/[0-9]*$/).first,
        
        :name     => (m%'.name').text.f,
        :maker    => (m%'.manu').text.f,
        :model    => (m%'.model').text.f,
        :year     => (m%'.year').text.f,
        :spec     => (m%'.spec').text.f,
        :location => (m%'.country').text.f,
        :company  => (m%'.company').text.f,
        
        :detail_uri => (m%'td:nth(2) a')[:href].uf(uri),
        :ref_uri    => uri.to_s,
        :imgs       => ((m%'.photo a')[:href].uf(uri) + '#GET' rescue ''),
        # :company_uri => (m%'td:nth(10) a')[:href].uf(uri),
        # :contact_uri => (m%'td:nth(11) a')[:href].uf(uri),
        
        :thumbnail => ((m%'.photo img')[:src].uf(uri) rescue ''),
      }
      
      # ジャンルID
      data[:genre_id] = genre_id if genre_id != ''
        
      # 能力
      if /^([0-9\.]+)(T|m|mm)/ =~ data[:name]
        data[:capacity] = $1
        # p "#{$1}T"
      end
      
      # 能力(旋盤：尺の場合)
      if genre_id == 52
        if /c\/33$/ =~ genre_hint
          data[:capacity] = 0.36
        elsif /c\/34$/ =~ genre_hint
          data[:capacity] = 0.6
        elsif /c\/35$/ =~ genre_hint
          data[:capacity] = 0.8
        elsif /c\/36$/ =~ genre_hint
          data[:capacity] = 1.0
        elsif /c\/37$/ =~ genre_hint
          data[:capacity] = 1.2
        elsif /c\/346$/ =~ genre_hint
          data[:capacity] = 1.5
        end
      end
      
      @d << data
    end
    
    return self
  rescue => exc
    @logger.error("scrape error : #{exc}\n".toutf8 + $@.join("\n"))
    raise "scrape error"
  end
  
  #
  # 2次クロール（セーフレベル2内で処理）
  # Param:: String uri 2次クロールするURI
  #
  def nokogiri(uri)
    page = NKF.nkf("-wZX--cp932", open(uri).read)
    Nokogiri::HTML(page, nil, 'UTF-8')
  end
  
  #
  # ページの取得
  # Param:: String uri 取得するURI
  # Return:: self
  #
  def getpage(uri, retcount=@retnum)
    @a.get(uri)
    return self
  rescue => exc
    if (retcount -= 1) > 0
      sleep @retslp
      @logger.warn("retry #{count} : #{uri}")
      mechanize_init
      retry
    else
      @logger.error("getpage error : #{exc} : #{uri}\n".toutf8 + $@.join("\n"))
      raise "getpage error"
    end
  end
  
  #
  # クロールキューにURLを追加
  # Param:: Int depth クロール深度
  # Return:: self
  #
  def append_quere(depth)
    # クロールキューにURIを追加
    uri = @a.page.uri
    # @a.page.links.each do |a|
    #   href = join_uri(uri, a.href)
    (@a.page/"a[href*='list']").each do |a|
      href = join_uri(uri, a[:href])
      if check_uri(href)
        @q << [href, depth]
        @v << href
      end
    end
    
    return self
  end
  
  #
  # クロールメソッド
  # Param:: String url クロール開始URL
  # Param:: Integer depth 初期クロール深度
  # Return:: self
  #
  def crawl(uri ,depth = 1)
    # クロールキューにスタートURIを追加
    @q << [uri, depth]
    
    #### クロールループ ####
    loop do
      break if @q.length < 1
      uri, depth = @q.shift
      # next if @a.visited?(uri)
      
      @logger.info("#{depth} -> #{uri}")
      
      getpage(uri) # ページの取得
      scrape       # スクレイピング
    
      # クロール深度チェック
      if depth < @depth
        next_depth = depth + 1
        append_quere(next_depth)
      end
    end
    
    return self
  rescue => exc
    @logger.error("crawl error : #{exc}\n".toutf8 + $@.join("\n"))
  end
  
  #
  # 拒否URL、許可URLのチェック
  # Param:: String uri チェックするURL文字列
  # Return:: boolean 許可されればtrue
  #
  def check_uri(uri)
    unless @s[:crawl_allow].nil? || @s[:crawl_allow].empty?
      return false unless /#{@s[:crawl_allow]}/  =~ uri
    end
    
    unless @s[:crawl_deny].nil? || @s[:crawl_deny].empty?
      return false unless /#{@s[:crawl_deny]}/ !~ uri
    end
    
    return false if @v.include?(uri)
    
    return true
  end
  
  #
  # URLを絶対パスに変換、#を削除
  #
  # Param:: String base_path ベースURL文字列
  # Param:: String uri 変換する相対URL文字列
  # Return:: String 変換後のURL文字列
  #
  def join_uri(base_path, uri)
    uri.gsub!(/#.*$/, '')
    URI.join(base_path.to_s, uri.to_s).to_s
  rescue
    uri
  end
  
  #
  # Mechinizeの初期化
  #
  def mechanize_init
    @a = Mechanize.new
    @a.user_agent_alias = 'Linux Mozilla'
    @a.html_parser      = MyParser # 日本語記号対応用パーサ
    @a.read_timeout     = 180      # タイムアウト時間
    @a.max_history      = 1
  end
end

#
# MechanizeのパーサNokogiriを再定義
# 記号のエンコーディングがうまくいかないので
#
class MyParser
  def self.parse(thing, url = nil,
                 encoding = nil,
                 options = Nokogiri::XML::ParseOptions::DEFAULT_HTML,
                 &block)
    thing = NKF.nkf("-wZX--cp932", thing)
    Nokogiri::HTML.parse(thing, url, encoding, options, &block)
  end
end
