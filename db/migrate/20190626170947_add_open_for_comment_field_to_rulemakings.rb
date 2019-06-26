class AddOpenForCommentFieldToRulemakings < ActiveRecord::Migration[5.2]
  def change
    add_column :rulemakings, :open_for_public_to_submit_comments, :boolean
    add_column :rulemakings, :open_for_public_to_view_comments, :boolean
  end
end
