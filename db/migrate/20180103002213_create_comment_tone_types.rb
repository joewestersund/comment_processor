class CreateCommentToneTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :comment_tone_types do |t|
      t.integer :description_text
      t.integer :order_in_list

      t.timestamps
    end
  end
end
