class AddScraperToSearchPreferences < ActiveRecord::Migration[7.0]
  def change
    add_reference :search_preferences, :scraper, foreign_key: true
  end
end
