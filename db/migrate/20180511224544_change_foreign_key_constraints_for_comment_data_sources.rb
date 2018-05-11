class ChangeForeignKeyConstraintsForCommentDataSources < ActiveRecord::Migration[5.1]
  def up
    remove_foreign_key :comments, :comment_data_sources

    add_foreign_key :comments, :comment_data_sources, on_delete: :nullify

  end

  def down
      remove_foreign_key :comments, :comment_data_sources

      add_foreign_key :comments, :comment_data_sources, on_delete: :cascade
  end
end
