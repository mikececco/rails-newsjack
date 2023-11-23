class CreateGeneratePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :generate_posts do |t|
      t.string :trend
      t.text :company_description

      t.timestamps
    end
  end
end
