class CreateSearchPreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :search_preferences do |t|
      t.string :country

      t.timestamps
    end
  end
end
