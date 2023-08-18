class AddAttributesToWaitingUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :waiting_users, :firstname, :string
    add_column :waiting_users, :company_name, :text
  end
end
