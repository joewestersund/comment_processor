class FixCommentToneColumnType < ActiveRecord::Migration[5.1]
  def up
    change_column :comment_tone_types, :description_text, :string
  end

  def down
    change_column :comment_tone_types, :description_text, :integer
  end
end
