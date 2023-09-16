class SearchPreferencesController < ApplicationController
  def new
    @country = request.location.country_code
    @search_preference = SearchPreference.new
  end

  def create
    @search_preference = SearchPreference.new(search_preference_params)
    if @search_preference.save
      redirect_to @search_preference, notice: 'Search preference was successfully created.'
    else
      render :new
    end
  end
end
