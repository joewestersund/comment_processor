class RemoveStringFromCommentDataSources < ActiveRecord::Migration[5.1]
  def change
    remove_column :comment_data_sources, :string, :string
  end
end
