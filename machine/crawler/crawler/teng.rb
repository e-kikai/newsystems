#! ruby -Ku
#
# クローラクラス(for 東京エンジニアリング)のソースファイル
# Author::    川端洋平
# Date::      2013/05/12
# Copyright:: Copyright (c) 2013 川端洋平
#
require File.dirname(__FILE__) + '/base'
require 'csv'

# クローラクラス
class Teng < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '株式会社東京エンジニアリング'
    @company_id = 76
    @start_uri  = 'http://www.t-eng.co.jp/products/used/list.cgi'

    @crawl_allow = /list\.cgi\?c1=999&c2=999&page=[0-9]+$/
    @crawl_deny  = nil
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    (@p/'table.usedlist tr').each do |m|
      begin
        next if m%'th'

        #### 名前に「売約済」が入っていたらスキップ ####
        name = (m%'td:nth(3)').text.f
        next if /売約/ =~ name

        #### 既存情報の場合スキップ ####
        detail_uri = join_uri(@p.uri, m.%('td:nth(3) a')[:href])
        next unless /detail.cgi\?id=([0-9]+)/ =~ detail_uri
        uid = $1
        next unless check_uid(uid)

        temp = {
          :uid   => uid,
          :no    => (m%'td:nth(2)').text.f,
          :name  => name,
          :maker => (m%'td:nth(4)').text.f,
          :model => (m%'td:nth(5)').text.f,
          :year  => (m%'td:nth(6)').text.f,
          :spec  => (m%'td:nth(7)').text.f.gsub('★', ''),
          :location => '',
        }

        # 機械名から情報を分離
        if /(新古品)/ =~ temp[:name]
          temp[:name].gsub!('(新古品)', '')
          temp[:spec] += ' | 新古品'
        end
        if /新品/ =~ temp[:name]
          temp[:name].gsub!('新品', '')
          temp[:spec] += ' | 新品'
        end
        if  /商談中/ =~ temp[:name]
          temp[:name].gsub!('商談中', '')
          temp[:view_option] = 2
        end
        temp[:name].gsub!(/(\<\>|《》)/, '')

        temp[:hint] = temp[:name]

        # 機械名と型式が同じ場合は、型式を除去
        temp[:model] = '' if temp[:model] == temp[:name]

        #### ディープクロール ####
        p2 = nokogiri(detail_uri)

        #### 仕様 ####
        (p2/'table.detail th').each do |n|
          nlabel = n.text.f
          ndata  = n.next_element.text.f

          next if ndata == ''

          if nlabel == '在庫場所'
            if /成田第一/ =~ ndata
              temp[:location] = 'TEN成田第1倉庫'
            elsif /成田第二/ =~ ndata
              temp[:location] = 'TEN成田第2倉庫'
            elsif /成田第三/ =~ ndata
              temp[:location] = 'TEN成田第3倉庫'
            elsif /HUB/ =~ ndata
              temp[:location] = 'TEN成田HUB-WORKS'
            elsif /山梨/ =~ ndata
              temp[:location] = 'TEN山梨'
            else
              temp[:location] = ndata
            end
          elsif nlabel == '付属品'
            temp[:accessory] = ndata
          elsif nlabel == '価格(万円)'
            temp[:price] = ndata
          elsif nlabel == '現状'
            temp[:spec] += ' | 現状:' + ndata
          end
        end

        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $2.gsub(/[^0-9.]/, '').to_f if /(心|芯)間:([0-9\,.]+)/ =~ temp[:spec]
        elsif /プレス/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)t/i =~ temp[:spec]
        elsif /ボール盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /能力:([0-9\,.]+)/i =~ temp[:spec]
        elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /テーブル:([0-9\,.]+)/i =~ temp[:spec]
        elsif /(コンプレッサ|モーター)/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)kw/i =~ temp[:spec]
        elsif /シャーリング/ =~ temp[:name]
          temp[:capacity] = $2.gsub(/[^0-9.]/, '').to_f if /(切断寸法|切断長さ|テーブル):([0-9\,.]+)/i =~ temp[:spec]
        elsif /コーナーシャー/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /加工板厚:([0-9\,.]+)/i =~ temp[:spec]
        elsif /スポット溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)KVA/i =~ temp[:spec]
        elsif /溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)A/i =~ temp[:spec]
        elsif /スロッタ/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /エアータンク/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)ℓ/i =~ temp[:spec]
        elsif /バンドソー|ダイヤモンドソー/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)ｘ/i =~ temp[:spec]
        elsif /フォークリフト|ローリフト|ホイスト|チェーンブロック|クレーン/ =~ temp[:name]
          if /([0-9\,.]+)t/i =~ temp[:spec]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
          elsif /([0-9\,.]+)kg/i =~ temp[:spec]
            temp[:capacity] = ($1.gsub(/[^0-9.]/, '').to_f) / 1000
          end
        elsif /定.?盤/ =~ temp[:name]
          if /([0-9\,.]+)x([0-9\,.]+)/i =~ temp[:spec]
            le1 = $1
            le2 = $2

            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f

            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end

        # 画像
        temp[:used_imgs] = []
        (p2/'#tabindex img').each do |i|
          temp[:used_imgs] << join_uri(@p.uri, i[:src])
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
