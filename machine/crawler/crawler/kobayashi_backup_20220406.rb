#! ruby -Ku
#
# クローラクラス(for 大沼機工)のソースファイル
# Author::    川端洋平
# Date::      2012/5/17
# Copyright:: Copyright (c) 2012 川端洋平
#
require  File.dirname(__FILE__) + '/base'

# クローラクラス
class Kobayashi < Base

  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '株式会社小林機械'
    @company_id = 9
    @start_uri  = 'https://www.kkmt.co.jp/products?page=1'

    @crawl_allow = /\?page/
    @crawl_deny  = /translate/

    @depth       = 200 # クロール深度

  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    # (@p/'table.tableColor tr').each do |m|
    (@p/'.card.mb-4').each do |m|
      begin
        uid = (m%'i').text.f
        # log.info("UID :: #{uid}")
        #### 既存情報の場合スキップ ####
        next unless check_uid(uid)

        # 「新品」表記の削除
        name = (m%'.card-title').text.f
        hint = name.gsub(/新品|一山|1山/, "").f

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, (m%'a.btn.btn-outline-info')[:href])
        # log.info("detail :: #{detail_uri}")
        p2 = nokogiri(detail_uri)

        # 初期化
        temp = {
          :uid   => uid,
          :no    => uid,
          :name  => name,
          :hint  => hint,
          # :maker => (p2%'.card.mt-2:nth(1) dd.col-sm-9:nth(3)').text.f,
          # :model => (p2%'.card.mt-2:nth(1) dd.col-sm-9:nth(4)').text.f,
          # :year  => (p2%'.card.mt-2:nth(1) dd.col-sm-9:nth(5)').text.f,
          # :location => (p2%'.card.mt-2:nth(1) dd.col-sm-9:nth(6)').text.f,
          # :spec  => (p2%'.card.mt-2:nth(1) dd.col-sm-9:nth(7)').text.f,
        }

        price = 0

        (p2/'dt').each do |dt|
          next unless (dt%'+ dd')

          dd_text = (dt%'+ dd').text.f
          # log.info("dt : #{dt.text.f}, dd : #{dd_text}")

          case dt.text.f
          when /メーカー/; temp[:maker] = dd_text
          when /型式/;     temp[:model] = dd_text
          when /年式/;     temp[:year] = dd_text
          when /倉庫/;     temp[:location] = dd_text
          when /仕様/;     temp[:spec] = dd_text
          when /価格/;     price = dd_text.gsub(/[^0-9]/, '').to_i
          end
        end

        temp[:youtube] = 'http://youtu.be/' + (p2%'iframe')[:src].f.gsub(/^.*\//, '') if p2%'iframe'

        # price = (p2%'.card.mt-3 dd.col-sm-9:nth(1)')
        # if price && price.text.f.gsub(/[^0-9]/, '').to_i > 0
        #   temp[:price] = price.text.f.gsub(/[^0-9]/, '').to_i
        #   temp[:ekikai_price] = temp[:price]
        # end

        # if price && price > 0
        if price && price > 0 && price <= 100_000_000
          temp[:price]        = price
          temp[:ekikai_price] = price
        end


        # (p2/'.media-body').each_with_index do |n, key|
        #   if n.text.f =~ /主仕様(.*)/
        #     temp[:spec] = $1
        #   end
        # end

        # (p2/'.media-body').each do |n|
        #   nbody = n.text.f
        #   # log.debug nbody
        #
        #   if nbody =~ /置場/
        #     temp[:location] = nbody.gsub(/置場/, '').strip
        #   elsif nbody =~ /価格/
        #     temp[:price] = nbody.gsub(/\D/, '').to_i
        #     temp[:price] = nil if temp[:price] < 1
        #     temp[:ekikai_price] = temp[:price]
        #   end
        # end

        # 主能力
        if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /心間([0-9]+)/ =~ temp[:spec]
        elsif /ラジアル/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /振り([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /シャーリング/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /長さ([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /テーブル長さ?([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /プレス/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)t/i =~ temp[:spec]
        elsif /バンドソー/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /φ([0-9\,.]+)mm/i =~ temp[:spec]
        elsif /(コンプレッサ|モーター)/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)kw/i =~ temp[:spec]
        elsif /スポット溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)KVA/i =~ temp[:spec]
        elsif /溶接/ =~ temp[:name]
          temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)A/i =~ temp[:spec]
        elsif /定盤/ =~ temp[:name]
          if /([0-9\,.]+)×([0-9\,.]+)/i =~ temp[:spec]
            le1 = $1
            le2 = $2

            le1 = le1.gsub(/[^0-9.]/, '').to_f
            le2 = le2.gsub(/[^0-9.]/, '').to_f

            temp[:capacity] = le1 > le2 ? le1 : le2
          end
        end

        # 画像
        temp[:used_imgs] = []
        (p2/'.carousel-indicators img').each do |i|
          temp[:used_imgs] << join_uri(detail_uri, i[:src].gsub(/\?.*$/, "")) unless i[:src] =~ /noimage/
        end

        @d << temp
        @log.debug(temp)

      rescue => exc
        # error_report("scrape error (#{temp[:uid]})", exc)
        error_report("", exc)
      end
    end

    return self
  end
end
