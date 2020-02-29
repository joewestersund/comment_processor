class RemoveViewSubmitPublicCommentFromRulemaking < ActiveRecord::Migration[5.2]
  def change
    remove_column :rulemakings, :open_for_public_to_submit_comments, :boolean
    remove_column :rulemakings, :open_for_public_to_view_comments, :boolean
  end
end
