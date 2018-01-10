class ChangeCategoryAssignedToToAssignedToId < ActiveRecord::Migration[5.1]
  def change
    rename_column :categories, :assigned_to, :assigned_to_id
  end
end
