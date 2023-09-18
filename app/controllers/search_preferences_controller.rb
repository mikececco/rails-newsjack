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
      cache_key = "scraper_#{@search_preference.country_code}_#{current_date}"

      cached_scraper = Rails.cache.read(cache_key)
      if today_search_preference && cached_scraper.present?
        @scraper = cached_scraper
      else
        @scraper = Scraper.new
        @scraper.country_code = @search_preference.country_code
        @scraper.country_name = @scraper.set_country(@search_preference.country_code)
        @scraper.scraped_news = @scraper.start
        @scraper.save

        Rails.cache.write(cache_key, @scraper, expires_in: 24.hours)
      end
      redirect_to results_search_preferences_path(scraped: @scraper)
    else
      render :new
    end
  end

  def results
    @scraped_news = Scraper.find(params[:scraped])
  end

  private

  def search_preference_params
    params.require(:search_preference).permit(:country_code)
  end
end
