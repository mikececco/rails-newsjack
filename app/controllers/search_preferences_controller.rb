require 'uri'
require 'net/http'
require 'json'

class SearchPreferencesController < ApplicationController
  def new
    if Rails.env.production?
      @country = request.location.country_code
    else
      # Set a default country for non-production environments
      @country = 'US' # Or any default country code you prefer
    end
    @search_preference = SearchPreference.new
  end

  def create
    @search_preference = SearchPreference.new(search_preference_params)
    if @search_preference.save
      country = ISO3166::Country[@search_preference.country_code]
      readable_country = country.translations[I18n.locale.to_s]
      current_time = Time.now

      # Format the current time in the desired format
      formatted_timestamp = current_time.strftime('%Y-%m-%d %H:%M:%S.%N000 %z')

      # Convert the timestamp to a DateTime object
      timestamp_datetime = DateTime.parse(formatted_timestamp)

      # Calculate the start and end of the day for the given timestamp
      start_of_day = timestamp_datetime.beginning_of_day
      end_of_day = timestamp_datetime.end_of_day
      today_search_preference = SearchPreference.find_by(country_code: @search_preference.country_code, created_at: start_of_day..end_of_day)

      current_date = Time.now.strftime('%Y-%m-%d')
      scraper_cache_key = "scraper_#{@search_preference.country_code}_#{current_date}"

      cached_scraper = Rails.cache.read(scraper_cache_key)
      if today_search_preference && cached_scraper.present?
        @scraper = cached_data[:scraper]
        @twitter_trends = cached_data[:twitter_trends]
      else
        @scraper = Scraper.new
        @scraper.country_code = @search_preference.country_code
        @scraper.country_name = @scraper.set_country(@search_preference.country_code)
        @scraper.scraped_news = @scraper.start
        @scraper.save
        @twitter_trends = twitter_trends

        cache_data = {
          scraper: @scraper,
          twitter_trends: @twitter_trends
        }

        Rails.cache.write(scraper_cache_key, cache_data, expires_in: 24.hours)
      end

      redirect_to results_search_preferences_path(google_scraped: @scraper, twitter: @twitter_trends.to_json)
    else
      render :new
    end
  end

  def results
    @twitter_trends = JSON.parse(params[:twitter])
    @scraped_news = Scraper.find(params[:google_scraped])
    string = @scraped_news.scraped_news
    @hash_with_title = eval(string)
    @title = @hash_with_title.delete(:title)
    @new_hash = @hash_with_title.dup
    @to_ask = []
    @new_hash.each do |index, news_item|
      @to_ask << (news_item[:translated] == nil ? news_item[:news] : news_item[:translated])
    end
    @image = stability
    # SHOULD TRIGGER A CHATGPT CALL TO just SKIM the suitable trends, 3, to the brands identity
  end

  def twitter_trends
    url = URI("https://twitter-trends5.p.rapidapi.com/twitter/request.php")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["X-RapidAPI-Key"] = ENV["RAPID_KEY"]
    request["X-RapidAPI-Host"] = 'twitter-trends5.p.rapidapi.com'

    world = "woeid=1"
    us = "woeid=23424977"
    request.body = world #to be CHANGED TO THE REQUESTED COUNTRY INPUT

    response = http.request(request)
    trying = response.read_body

    response_dict = JSON.parse(trying)

    data = response_dict["trends"]

    # Extract "name" and "volume" attributes from each hash
    name_volume_list = []
    @display = []
    data.each do |key, value|
      name = value["name"]
      volume = value["volume"]
      @display << [name, volume]
      name_volume_list << { "name" => name, "volume" => volume }
    end

    # Specify the file name
    file_name = "name_volume.json"

    # Convert the list to JSON format
    json_data = JSON.pretty_generate(name_volume_list)

    # Write the JSON data to the file
    File.open(file_name, "w") do |file|
      file.write(json_data)
    end

    @display
    #SELECT WOEID
    # @world_trends = TwitterTrends.new(1)
    # world_trends_data = @world_trends.fetch_trends
    # world_data = world_trends.extract_data(world_trends_data)
    # world_trends.save_to_json(world_data, "world_name_volume.json")
  end

  def stability
    # Set the API token
    api_token = ENV["STABILITY_KEY"]

    # Define the request parameters
    url = URI.parse('https://api.replicate.com/v1/predictions')
    headers = { 'Content-Type' => 'application/json', 'Authorization' => "Token #{api_token}" }
    data = {
      version: '8beff3369e81422112d93b89ca01426147de542cd4684c244b673b105188fe5f',
      input: {
        prompt: "An illustration of an avocado sitting in a therapist's chair, saying 'I just feel so empty inside' with a pit-sized hole in its center. The therapist, a spoon, scribbles notes."
      }
    }

    # Send the POST request
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url.path, headers)
    request.body = data.to_json
    response = http.request(request)

    # Extract the response id
    if response.code == '200' || response.code == '201'
      parsed_response = JSON.parse(response.body)
      prediction_id = parsed_response['id']

      # Make a GET request to get the response based on the id
      response_url = "https://api.replicate.com/v1/predictions/#{prediction_id}"
      response_request = Net::HTTP::Get.new(response_url, 'Authorization' => "Token #{api_token}")
      response = http.request(response_request)

      # Print the response
      response_hash = JSON.parse(response.body)
      output_url = response_hash['output'] # Assuming 'output' is an array with one URL

      output_url = response_hash['output']

    # Check if output_url is nil and assign a default URL if needed
      output_url = 'https://pbxt.replicate.delivery/mx7Jb91MfwzPZSCgMjC5CpKbRpX2B0bEu4UD6LaxfT9rWOoRA/out-0.png' if output_url.nil?
    else
      output_url = 'https://pbxt.replicate.delivery/R51v7QaXfMTJdibt0IO56BObyFeCAtwQ1rqhjJJLke5Me3gGB/out-0.png'
    end
    output_url
  end

    # def create
    #   redirect_to company_search_preferences_path
    # end

  # def results
  # end

  def company
  end

  def company_submit
    redirect_to results_search_preferences_path
  end

  def post

  end

  private

  def search_preference_params
    params.require(:search_preference).permit(:country_code)
  end
end
