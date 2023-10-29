class ChangeCompanyDescriptionToCompanyWebsiteUrl < ActiveRecord::Migration[7.0]
  def change
    rename_column :generate_posts, :company_description, :company_website_url
    change_column :generate_posts, :company_website_url, :string
  end
end
