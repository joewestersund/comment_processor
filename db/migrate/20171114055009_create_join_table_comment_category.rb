class CreateJoinTableCommentCategory < ActiveRecord::Migration[5.1]
  def change
    create_join_table :comments, :categories do |t|
      # t.index [:comment_id, :category_id]
      # t.index [:category_id, :comment_id]
    end
  end
end
