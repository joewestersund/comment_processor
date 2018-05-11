class AddCommentDataSourceIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :comment_data_source_id, :integer

    add_index :comments, :comment_data_source_id
    add_foreign_key :comments, :comment_data_sources, on_delete: :cascade

  end
end
