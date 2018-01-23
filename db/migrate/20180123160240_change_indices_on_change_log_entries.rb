class ChangeIndicesOnChangeLogEntries < ActiveRecord::Migration[5.1]
  def up
    add_index :change_log_entries, [:comment_id, :created_at]
    add_index :change_log_entries, [:category_id, :created_at]

    remove_index :change_log_entries, :comment_id
    remove_index :change_log_entries, :category_id
  end

  def down
    add_index :change_log_entries, :comment_id
    add_index :change_log_entries, :category_id

    remove_index :change_log_entries, [:comment_id, :created_at]
    remove_index :change_log_entries, [:category_id, :created_at]
  end
end
