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
    # @start_uri  = 'https://www.kkmt.co.jp/products?display_mode=table&page=1'
    @start_uri  = 'https://www.kkmt.co.jp/products?display_mode=table&pictures=no_own&page=1'

    # @crawl_allow = /\/products\?display\_mode\=table\&page\=[0-9]+$/
    @crawl_allow = /\/products\?display_mode\=table\&page\=[0-9]+\&pictures\=no_own$/

    @crawl_deny  = /translate/

    @depth       = 300 # クロール深度

    @comment = "内容と現品に相違がある場合は、現品を優先させていただきます。"
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    # (@p/'table.tableColor tr').each do |m|
    (@p/'table.product_list tr').each do |m|
      begin
        next if m%'th'

        uid = (m%'td:nth(1)').text.f

        # log.info("UID :: #{uid}")
        #### 既存情報の場合スキップ ####
        # if uid !~ /^C14/
          next unless check_uid(uid)
        # end

        # 売約済みスキップ
        next if uid =~ /売約済/

        # 「新品」表記の削除
        name = (m%'td:nth(2)').text.f
        hint = name.gsub(/(新品|一山|1山|未使用品|大量入荷|中\!|各種|[0-9]+本$|他$|セット$)/, "").f

        #### ディープクロール ####
        detail_uri = join_uri(@p.uri, (m%'td:nth(1) a')[:href])
        # log.info("detail :: #{detail_uri}")
        p2 = nokogiri(detail_uri)

        # 初期化
        temp = {
          :uid   => uid,
          :no    => uid,
          :name  => name,
          :hint  => hint,
          :maker => (m%'td:nth(3)').text.f,
          :model => (m%'td:nth(4)').text.f,
        }

        price = 0

        (p2/'.product_spec table tr').each do |tr|
          th = (tr%'th').text.f
          td = (tr%'td').text.f

          # log.info("dt : #{dt.text.f}, dd : #{dd_text}")

          case th
          when /年式/;     temp[:year]     = td
          when /倉庫/;     temp[:location] = td
          when /仕様/;     temp[:spec]     = (tr%'td p').text.f
          when /価格/;     price           = td.gsub(/[^0-9]/, '').to_i
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

        # maker
        temp[:maker] = temp[:maker].delete("--").f

        # spec, comment
        if temp[:spec].include?(@comment)
          temp[:spec]    = temp[:spec].delete(@comment).f
          temp[:comment] = @comment
        end

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
        # (p2/'#disp_img img').each do |i|
        (p2/'.carousel-item img').each do |i|
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
