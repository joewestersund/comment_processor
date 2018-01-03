class AddCommentToneToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :comment_tone_type_id, :integer
  end
end
