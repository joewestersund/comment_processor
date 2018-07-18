class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :admin, :application_admin
    add_column :users, :last_rulemaking_viewed, :integer
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_passwod_sent_at, :datetime
    remove_column :users, :read_only
  end
end
