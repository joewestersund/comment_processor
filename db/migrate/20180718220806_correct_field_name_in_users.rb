class CorrectFieldNameInUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :reset_passwod_sent_at, :password_reset_sent_at
  end
end
