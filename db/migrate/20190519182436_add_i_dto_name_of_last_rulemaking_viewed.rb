class AddIDtoNameOfLastRulemakingViewed < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :last_rulemaking_viewed, :last_rulemaking_viewed_id
  end
end
