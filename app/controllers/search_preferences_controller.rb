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
      country = ISO3166::Country[search_preference_params[:country_code]]
      readable_country = country.translations[I18n.locale.to_s]
      @scraper = Scraper.new(@search_preference.country_code, readable_country)
      @scraped_news = @scraper.start
      redirect_to results_search_preferences_path(scraped_news: @scraped_news)
      # redirect_to @search_preference, notice: 'Search preference was successfully created.'
    else
      render :new
    end
  end

  def results
    @scraped_news = params[:scraped_news]
  end

  private

  def search_preference_params
    params.require(:search_preference).permit(:country_code)
  end
end
