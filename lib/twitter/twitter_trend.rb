require 'uri'
require 'net/http'
require 'json'

class TwitterTrends < ApplicationController
  def new(woeid)
    @woeid = woeid
  end

  def fetch_trends
    raise
    url = URI("https://twitter-trends5.p.rapidapi.com/twitter/request.php")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Key"] = ENV["RAPID_KEY"]
    request["X-RapidAPI-Host"] = 'twitter-trends5.p.rapidapi.com'

    request.body = "woeid=#{@woeid}"

    response = http.request(request)
    response_body = response.read_body

    JSON.parse(response_body)["trends"]
  end

  def extract_data(trends)
    name_volume_list = []

    trends.each do |trend|
      name = trend["name"]
      volume = trend["volume"]
      name_volume_list << { "name" => name, "volume" => volume }
    end

    name_volume_list
  end

  def save_to_json(data, file_name)
    json_data = JSON.pretty_generate(data)

    File.open(file_name, "w") do |file|
      file.write(json_data)
    end

    puts "Name and volume data has been stored in '#{file_name}'."
  end
end
