class AddMailListToGeneratePosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :generate_posts, :mail_list, foreign_key: true
  end
end
