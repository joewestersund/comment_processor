class AddIndicesToChangeLogEntries < ActiveRecord::Migration[5.1]
  def change
    add_index :change_log_entries, :comment_id
    add_index :change_log_entries, :category_id
    add_index :change_log_entries, :user_id
    add_index :change_log_entries, :created_at
  end
end
