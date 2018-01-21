class AddActionTypeToChangeLogEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :change_log_entries, :action_type, :string
  end
end
