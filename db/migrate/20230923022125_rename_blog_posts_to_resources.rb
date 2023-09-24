class RenameBlogPostsToResources < ActiveRecord::Migration[7.0]
  def change
    rename_table :blog_posts, :resources
  end
end
