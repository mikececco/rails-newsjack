class RemoveUserEmailFromTrialClickUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :trial_click_users, :user_email
  end
end
