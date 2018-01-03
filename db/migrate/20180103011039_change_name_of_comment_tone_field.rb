class ChangeNameOfCommentToneField < ActiveRecord::Migration[5.1]
  def change
    rename_column :comment_tone_types, :description_text, :tone_text
  end
end
