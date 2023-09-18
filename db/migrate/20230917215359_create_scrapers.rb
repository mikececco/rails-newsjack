class CreateScrapers < ActiveRecord::Migration[7.0]
  def change
    create_table :scrapers do |t|
      t.string :country
      t.string :country_name
      
      t.timestamps
    end
  end
end
