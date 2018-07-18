class AddRulemakingIdToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :rulemaking_id, :integer
    add_column :category_response_types, :rulemaking_id, :integer
    add_column :category_status_types, :rulemaking_id, :integer
    add_column :change_log_entries, :rulemaking_id, :integer
    add_column :comments, :rulemaking_id, :integer
    add_column :comment_data_sources, :rulemaking_id, :integer
    add_column :comment_status_types, :rulemaking_id, :integer

  end
end
