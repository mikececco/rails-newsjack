class ChangeCountryToCountryCodeInScrapers < ActiveRecord::Migration[7.0]
  def change
    rename_column :scrapers, :country, :country_code
  end
end
