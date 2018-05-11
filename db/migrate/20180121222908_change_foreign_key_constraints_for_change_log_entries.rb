class ChangeForeignKeyConstraintsForChangeLogEntries < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :change_log_entries, :comments
    remove_foreign_key :change_log_entries, :categories

    add_foreign_key :change_log_entries, :comments, on_delete: :nullify
    add_foreign_key :change_log_entries, :categories, on_delete: :nullify
  end

  def down
      remove_foreign_key :change_log_entries, :comments
      remove_foreign_key :change_log_entries, :categories

      add_foreign_key :change_log_entries, :comments, on_delete: :cascade
      add_foreign_key :change_log_entries, :categories, on_delete: :cascade
  end
end
