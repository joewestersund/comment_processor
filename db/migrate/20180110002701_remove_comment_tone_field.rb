class RemoveCommentToneField < ActiveRecord::Migration[5.1]
  def change
    remove_column :comments, :comment_tone_type_id, :integer
  end
end
