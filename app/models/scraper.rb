require 'nokogiri'
require 'rest-client'
require 'geocoder'
require 'os'
require 'cgi'
require 'easy_translate'
require 'dotenv/load'

class Scraper
  def initialize(country, country_name)
    @country = country
    @country_name = country_name
    @t = 10
  end

  def t
    @t
  end

  def scrap
    url = "https://trends.google.com/trends/trendingsearches/daily/rss?geo=#{@country}"
    begin
      unparsed_page = RestClient.get(url)
      parsed_page = Nokogiri::XML(unparsed_page)
      items = parsed_page.xpath('//item')
      # @news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
      # @news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
    rescue RestClient::ExceptionWithResponse => e
      puts "Error fetching data: #{e.message}"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end


  def news_display(num)
    # p "#{num + 1}. #{CGI.unescapeHTML(@news[num].text)}".delete('\\"')
    begin
      EasyTranslate.api_key = ENV['TRANSLATE_KEY']
      if EasyTranslate.detect(CGI.unescapeHTML(@news[num].text)) != 'en'
        "^Translation: #{EasyTranslate.translate(CGI.unescapeHTML(@news[num].text), to: 'en')}".delete('\\"')
      end
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      false
    end
  end

  def start
    items = scrap
    if items.nil?
      @displayed_news = {title: "No trends found for #{@country_name}"}
    else
      @news = items.xpath('//ht:news_item[1]/ht:news_item_title[1]')
      @news_url = items.xpath('//ht:news_item[1]/ht:news_item_url[1]')
      @displayed_news = {title: "Today's top #{@t} trends in #{@country_name}"}  # Initialize an empty hash

      @t.times do |i|
        @displayed_news[i] = {
          news: @news[i].text,
          url: @news_url[i].text,
          translated: news_display(i)
        }
      end
    end
    return @displayed_news
  end

  def num?(num)
    Integer(num)
  rescue StandardError
    false
  end
end
