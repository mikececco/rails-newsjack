class AddFieldsToGeneratePosts < ActiveRecord::Migration[7.0]
  def change
    add_column :generate_posts, :social_media_url, :string
    add_column :generate_posts, :topic, :string
  end
end
