class AddScrapedNewsToScrapers < ActiveRecord::Migration[7.0]
  def change
    add_column :scrapers, :scraped_news, :text
  end
end
