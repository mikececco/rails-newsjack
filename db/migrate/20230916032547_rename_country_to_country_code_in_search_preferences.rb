class RenameCountryToCountryCodeInSearchPreferences < ActiveRecord::Migration[7.0]
  def change
    rename_column :search_preferences, :country, :country_code
  end
end
