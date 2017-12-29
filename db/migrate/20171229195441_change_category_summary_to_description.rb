class ChangeCategorySummaryToDescription < ActiveRecord::Migration[5.1]
  def change
    rename_column :categories, :summary, :description
  end
end
