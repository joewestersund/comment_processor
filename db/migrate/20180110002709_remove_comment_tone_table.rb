class RemoveCommentToneTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :comment_tone_types
  end

  def down
    create_table :comment_tone_types do |t|
      t.integer :tone_text
      t.integer :order_in_list

      t.timestamps
    end
  end
end
