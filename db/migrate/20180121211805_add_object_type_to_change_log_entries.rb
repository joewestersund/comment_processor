class AddObjectTypeToChangeLogEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :change_log_entries, :object_type, :string
  end
end
