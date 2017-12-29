class ChangeActionNeededColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :comments, :action_needed, :status_details
  end
end
