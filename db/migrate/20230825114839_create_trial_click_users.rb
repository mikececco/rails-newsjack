# db/migrate/20230825000000_create_trial_click_users.rb
class CreateTrialClickUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :trial_click_users do |t|
      t.text :company_description, limit: 150
      t.string :user_email

      t.timestamps
    end
  end
end
