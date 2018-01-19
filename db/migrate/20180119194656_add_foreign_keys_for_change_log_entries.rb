class AddForeignKeysForChangeLogEntries < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :change_log_entries, :comments, on_delete: :cascade
    add_foreign_key :change_log_entries, :categories, on_delete: :cascade
    add_foreign_key :change_log_entries, :users, on_delete: :restrict

  end
end
