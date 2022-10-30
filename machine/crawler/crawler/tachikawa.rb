#! ruby -Ku
#
# クローラクラス(for 立川商店)のソースファイル
# Author::    川端洋平
# Date::      2013/02/07
# Copyright:: Copyright (c) 2013 川端洋平
#
require File.dirname(__FILE__) + '/base'

# クローラクラス
class Tachikawa < Base
  #
  # コンストラクタ
  # Param:  Hash site クロール対象サイト情報
  #
  def initialize()
    # 親クラスのコンストラクタ
    super()

    @company    = '有限会社立川商店'
    @company_id = 13
    @start_uri  = 'https://tachikawa-kikai.com/stocks'

    @crawl_allow = /(page|\/tool_shop)/
    @crawl_deny  = nil
  end

  #
  # スクレイピング処理
  # Param:: String uri URI
  # Return:: self
  #
  def scrape
    #### ページ情報のスクレイピング ####
    # ツールショップと処理分割
    if @p.uri.to_s =~ /tool_shop/
      (@p/'tr').each do |m|
        begin
          # スキップ
          link = (m/'td:nth(3) a')
          next if link.empty?

          detail_uri = link.first[:href].f
          uid        = link.first.text.f

          next unless check_uid(uid)

          temp = {
            :uid      => uid,
            :no       => uid,
            :location => "ツールショップ寿",
          }
          price = 0

          #### ディープクロール ####
          detail_uri = join_uri(@p.uri, detail_uri)
          p2 = nokogiri(detail_uri)

          (p2/'dt').each do |dt|
            next unless (dt%'+ dd')

            dd_text = (dt%'+ dd').text.f
            # log.info("dt : #{dt.text.f}, dd : #{dd_text}")

            case dt.text.f
            when /機械名/;       temp[:name]  = dd_text
            # when /機械カテゴリ/; temp[:hint]  = dd_text
            when /メーカー/;     temp[:maker] = dd_text
            when /型番/;         temp[:model] = dd_text
            when /年式/;         temp[:year]  = dd_text
            when /仕様/;         temp[:spec]  = dd_text
            when /価格/;         price        = dd_text.gsub(/[^0-9]/, '').to_i
            when /仕様/;         temp[:spec]    = dd_text
            when /コメント/;     temp[:comment] = dd_text
            end
          end

          temp[:hint]  = temp[:name]

          # 販売価格
          if price && price > 0 && price <= 100_000_000
            temp[:price]        = price
            temp[:ekikai_price] = price
          end

          # 画像
          temp[:used_imgs] = []
          (p2/'img.slide-photo').each do |i|
            temp[:used_imgs] << i[:src]
          end

          @d << temp
          @log.debug(temp)
        rescue => exc
          error_report("scrape error (#{temp[:uid]})", exc)
        end
      end
    else
      (@p/'a.all-machine').each do |m|
        begin
          # スキップ
          detail_uri = m[:href].f
          next unless (m/'dd')

          uid = (m/'dd').first.text.f
          next unless check_uid(uid)

          temp = {
            :uid      => uid,
            :no       => uid,
            :location => "関東組合",
          }
          price = 0

          (m/'dt').each do |dt|
            next unless (dt%'+ dd')

            dd_text = (dt%'+ dd').text.f
            # log.info("dt : #{dt.text.f}, dd : #{dd_text}")

            case dt.text.f
            when /機械名/;       temp[:name]  = dd_text
            # when /機械カテゴリ/; temp[:hint]  = dd_text
            when /メーカー/;     temp[:maker] = dd_text
            when /型番/;         temp[:model] = dd_text
            when /年式/;         temp[:year]  = dd_text
            when /価格/;         price        = dd_text.gsub(/[^0-9]/, '').to_i
            end
          end

          temp[:hint]  = temp[:name]

          #### ディープクロール ####
          detail_uri = join_uri(@p.uri, detail_uri)
          p2 = nokogiri(detail_uri)

          (@p/'dt').each do |dt|
            next unless (dt%'+ dd')

            dd_text = (dt%'+ dd').text.f
            # log.info("dt : #{dt.text.f}, dd : #{dd_text}")

            case dt.text.f
            when /仕様/;     temp[:spec]    = dd_text
            when /コメント/; temp[:comment] = dd_text
            end
          end

          # 販売価格
          if price && price > 0 && price <= 100_000_000
            temp[:price]        = price
            temp[:ekikai_price] = price
          end

          # 主能力
          if /旋盤/ =~ temp[:name] && /NC/ !~ temp[:name]
            if /([3-9])尺/ =~ temp[:name]
              temp[:capacity] = LATER_CAP[$1.to_i]
            elsif /([0-9.]+)m/ =~ temp[:name]
              temp[:capacity] = $1.to_f * 1000
            end
          elsif /プレス/ =~ temp[:name]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)T/i =~ temp[:spec]
          elsif /ベンダー/ =~ temp[:name] && /NC/ !~ temp[:name]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
          elsif /ボール盤/ =~ temp[:name] && /NC/ !~ temp[:name]
            temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f if /([0-9\,.]+)mm/i =~ temp[:spec]
          elsif /(コンプレッサ)/ =~ temp[:name]
            if /([0-9\,.]+)KW(.*)$/i =~ temp[:name]
              temp[:hint] = $2
              temp[:capacity] = $1.gsub(/[^0-9.]/, '').to_f
            end
          elsif /定盤/ =~ temp[:name]
            if /([0-9\,.]+)×([0-9\,.]+)/i =~ temp[:model]
              le1 = $1
              le2 = $2

              le1 = le1.gsub(/[^0-9.]/, '').to_f
              le2 = le2.gsub(/[^0-9.]/, '').to_f

              temp[:capacity] = le1 > le2 ? le1 : le2
            end
          end

          # 画像
          temp[:used_imgs] = []
          (p2/'img.slide-photo').each do |i|
            temp[:used_imgs] << i[:src]
          end

          @d << temp
          @log.debug(temp)
        rescue => exc
          error_report("scrape error (#{temp[:uid]})", exc)
        end
      end
    end

    return self
  end
end
