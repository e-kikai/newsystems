#! ruby -Ku
#
# クローラクラス(for メカニー)のソースファイル
# Author::    川端洋平
# Date::      2012/5/17
# Copyright:: Copyright (c) 2012 川端洋平
#
require  File.dirname(__FILE__) + '/base'

# クローラクラス
class Mechany < Base

  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '株式会社メカニー'
    @company_id = 232
    @start_uri  = 'http://www.mechany.com/inventory.html'

    @crawl_allow = /xxxxxxxx/
    @crawl_deny  = nil
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'#item .name a').each do |m|
      begin
        #### ディープクロール ####
        detail_uri = m[:href]
        p2 = nokogiri(detail_uri)

        # 初期化
        temp = {
          hint:  (p2/'#area_1 table:nth(1) td:nth(2)').text.f,
          uid:   (p2/'#area_1 table:nth(3) td:nth(1)').text.f,
          no:    (p2/'#area_1 table:nth(3) td:nth(1)').text.f,
          name:  (p2/'#area_1 table:nth(1) td:nth(2)').text.f,
          maker: (p2/'#area_1 table:nth(1) td:nth(1)').text.f,
          model: (p2/'#area_1 table:nth(1) td:nth(3)').text.f,
          year:  (p2/'#area_1 table:nth(1) td:nth(4)').text.f,
          spec:  (p2/'#area_1 table:nth(2) td:nth(1)').text.f.gsub('【仕様・その他】', ""),
          used_pdfs: {},
          used_imgs: [],
          location: ''
        }

        next unless check_uid(temp[:uid])

        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /芯間\:([0-9\,.]+)/ =~ temp[:spec]
        elsif /万能.*プレスブレーキ/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)ton/i =~ temp[:spec]
        elsif /プレスブレーキ/ =~ temp[:name]
          temp[:capacity] = $3.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)(ton|T)\*([0-9\,.]+)/i =~ temp[:spec]
        elsif /(プレス|ハンマーパンチ)/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)ton/i =~ temp[:spec]
        elsif /ラジアル/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /振り\:([0-9\,.]+)/i =~ temp[:spec]
        elsif /万能.*ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)ton/i =~ temp[:spec]
        elsif /本ロール/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /L\:([0-9\,.]+)/i =~ temp[:spec]
        elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $2.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)ton\*([0-9\,.]+)/i =~ temp[:spec]
        elsif /(コンプレッサ|モーター)/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)kw/i =~ temp[:spec]
        elsif /シャーリング/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /\*([0-9\,.]+)/i =~ temp[:spec]
        elsif /スポット溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)KVA/i =~ temp[:spec]
        elsif /溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)A/i =~ temp[:spec]
        elsif /エアータンク/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)リットル/i =~ temp[:spec]
        elsif /フォーク|ローリフト|ホイスト|クレーン|チェーンブロック/ =~ temp[:name]
          if /([0-9\,.]+)(ton|トン)/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)kg/i =~ temp[:spec]
            temp[:capacity] = ($1.gsub(/[^0-9.]/, '').to_f) / 1000
          end
        elsif /放電加工/ =~ temp[:name]
          temp[:genre_id] = 220
        elsif /定.?盤/ =~ temp[:name]
          if /([0-9\,.]+)\*([0-9\,.]+)/i =~ temp[:spec]
            le1 = $1
            le2 = $2

            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f

            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end

        # 動画、PDF
        (p2/'.shiyou a').each do |a|
          if /v=([0-9a-zA-Z])&/ =~ a[:href]
            temp[:youtube] = 'http://youtu.be/' + $1
          elsif /\.pdf$/ =~ a[:href]
            temp[:used_pdfs]["PDF"] = join_uri(detail_uri, a[:href])
          end
        end

        # 画像
        (p2/'#area_2 img, #area_3 img').each do |i|
          temp[:used_imgs] << join_uri(detail_uri, i[:src]) unless /\.gif$/ =~ i[:href]
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
